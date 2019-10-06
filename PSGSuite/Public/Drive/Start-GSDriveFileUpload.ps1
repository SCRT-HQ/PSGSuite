function Start-GSDriveFileUpload {
    <#
    .SYNOPSIS
    Starts uploading a file or list of files to Drive asynchronously

    .DESCRIPTION
    Starts uploading a file or list of files to Drive asynchronously. Allows full folder structure uploads by passing a folder as -Path and including the -Recurse parameter

    .PARAMETER Path
    The path of the file or folder to upload

    .PARAMETER Description
    The description of the file or folder in Drive

    .PARAMETER Parents
    The unique Id of the parent folder in Drive to upload the file to

    Defaults to the root folder in My Drive

    .PARAMETER Recurse
    If $true and there is a Directory passed to -Path, this will rebuild the folder structure in Drive under the Parent Id and upload the files within accordingly

    .PARAMETER Wait
    If $true, waits for all uploads to complete and shows progress around the total upload

    .PARAMETER RetryCount
    How many times uploads should be retried when using the -Wait parameter

    Defaults to 10

    .PARAMETER ThrottleLimit
    The limit of files to upload per batch while waiting

    .PARAMETER User
    The email or unique Id of the user to upload the files for

    .EXAMPLE
    Start-GSDriveFileUpload -Path "C:\Scripts","C:\Modules" -Recurse -Wait

    Starts uploading the Scripts and Modules folders and the files within them and waits for the uploads to complete, showing progress as files are uploaded
    #>
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias('FullName')]
        [ValidateScript( {Test-Path $_})]
        [String[]]
        $Path,
        [parameter(Mandatory = $false)]
        [String]
        $Description,
        [parameter(Mandatory = $false)]
        [String[]]
        $Parents,
        [parameter(Mandatory = $false)]
        [Switch]
        $Recurse,
        [parameter(Mandatory = $false)]
        [Switch]
        $Wait,
        [parameter(Mandatory = $false)]
        [Int]
        $RetryCount = 10,
        [parameter(Mandatory = $false)]
        [ValidateRange(1,1000)]
        [Int]
        $ThrottleLimit = 20,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [Alias('Owner','PrimaryEmail','UserKey','Mail')]
        [string]
        $User = $Script:PSGSuite.AdminEmail
    )
    Begin {
        $taskList = [System.Collections.ArrayList]@()
        $fullTaskList = [System.Collections.ArrayList]@()
        $start = Get-Date
        $folIdHash = @{}
        $throttleCount = 0
        $totalThrottleCount = 0
        $totalFiles = 0
    }
    Process {
        if ($User -ceq 'me') {
            $User = $Script:PSGSuite.AdminEmail
        }
        elseif ($User -notlike "*@*.*") {
            $User = "$($User)@$($Script:PSGSuite.Domain)"
        }
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/drive'
            ServiceType = 'Google.Apis.Drive.v3.DriveService'
            User        = $User
        }
        $service = New-GoogleService @serviceParams
        try {
            foreach ($file in $Path) {
                $details = Get-Item $file
                if ($details.PSIsContainer) {
                    $newFolPerms = @{
                        Name    = $details.Name
                        User    = $User
                        Type    = 'DriveFolder'
                        Verbose = $false
                    }
                    $parentVerbose = $null
                    if ($PSBoundParameters.Keys -contains 'Parents') {
                        $newFolPerms['Parents'] = $PSBoundParameters['Parents']
                        if ($par = Get-GSDriveFileInfo -FileId $PSBoundParameters['Parents'] -User $User -Verbose:$false -ErrorAction Stop) {
                            $parentVerbose = " under parent folder '$($par.Name -join ',')'"
                        }
                    }
                    Write-Verbose "Creating new Drive folder '$($details.Name)'$parentVerbose"
                    $id = New-GSDriveFile @newFolPerms | Select-Object -ExpandProperty Id
                    $folIdHash[$details.FullName.TrimEnd('\').TrimEnd('/')] = $id
                    if ($Recurse) {
                        $recurseList = Get-ChildItem $details.FullName -Recurse
                        $recDirs = $recurseList | Where-Object {$_.PSIsContainer} | Sort-Object FullName
                        if ($recDirs) {
                            Write-Verbose "Creating recursive folder structure under '$($details.Name)'"
                            $recDirs | ForEach-Object {
                                $parPath = "$(Split-Path $_.FullName -Parent)"
                                $newFolPerms = @{
                                    Name    = $_.Name
                                    User    = $User
                                    Type    = 'DriveFolder'
                                    Parents = [String[]]$folIdHash[$parPath]
                                    Verbose = $false
                                }
                                $id = New-GSDriveFile @newFolPerms | Select-Object -ExpandProperty Id
                                $folIdHash[$_.FullName] = $id
                                Write-Verbose "    + Created: [ID $id] $($_.FullName -replace "^$([RegEx]::Escape($details.FullName))",$details.Name)"
                            }
                        }
                        $details = $recurseList | Where-Object {!$_.PSIsContainer} | Sort-Object FullName
                        $checkFolIdHash = $true
                        $totalFiles = [int]$totalFiles + $details.Count
                    }
                }
                else {
                    $totalFiles++
                    $checkFolIdHash = $false
                }
                foreach ($detPart in $details) {
                    $throttleCount++
                    $contentType = Get-MimeType $detPart
                    $body = New-Object 'Google.Apis.Drive.v3.Data.File' -Property @{
                        Name = [String]$detPart.Name
                    }
                    if (!$checkFolIdHash -and ($PSBoundParameters.Keys -contains 'Parents')) {
                        if ($Parents) {
                            $body.Parents = [String[]]$Parents
                        }
                    }
                    elseif ($checkFolIdHash) {
                        $parPath = "$(Split-Path $detPart.FullName -Parent)"
                        $body.Parents = [String[]]$folIdHash[$parPath]
                    }
                    if ($Description) {
                        $body.Description = $Description
                    }
                    $stream = New-Object 'System.IO.FileStream' $detPart.FullName,([System.IO.FileMode]::Open),([System.IO.FileAccess]::Read),([System.IO.FileShare]"Delete, ReadWrite")
                    $request = $service.Files.Create($body,$stream,$contentType)
                    $request.QuotaUser = $User
                    $request.SupportsAllDrives = $true
                    $request.ChunkSize = 512KB
                    $upload = $request.UploadAsync()
                    $task = $upload.ContinueWith([System.Action[System.Threading.Tasks.Task]] {if ($stream) {
                                $stream.Dispose()
                            }})
                    Write-Verbose "[$($detPart.Name)] Upload Id $($upload.Id) has started"
                    if (!$Script:DriveUploadTasks) {
                        $Script:DriveUploadTasks = [System.Collections.ArrayList]@()
                    }
                    $script:DriveUploadTasks += [PSCustomObject]@{
                        Id             = $upload.Id
                        File           = $detPart
                        Length         = $detPart.Length
                        SizeInMB       = [Math]::Round(($detPart.Length / 1MB),2,[MidPointRounding]::AwayFromZero)
                        StartTime      = $(Get-Date)
                        Parents        = $body.Parents
                        User           = $User
                        Upload         = $upload
                        Request        = $request
                        Stream         = $stream
                        StreamDisposed = $false
                    }
                    $taskList += [PSCustomObject]@{
                        Id       = $upload.Id
                        File     = $detPart
                        SizeInMB = [Math]::Round(($detPart.Length / 1MB),2,[MidPointRounding]::AwayFromZero)
                        User     = $User
                    }
                    $fullTaskList += [PSCustomObject]@{
                        Id       = $upload.Id
                        File     = $detPart
                        SizeInMB = [Math]::Round(($detPart.Length / 1MB),2,[MidPointRounding]::AwayFromZero)
                        User     = $User
                    }
                    if ($throttleCount -ge $ThrottleLimit) {
                        $totalThrottleCount += $throttleCount
                        if ($Wait) {
                            Watch-GSDriveUpload -Id $taskList.Id -CountUploaded $totalThrottleCount -TotalUploading $totalFiles
                            $throttleCount = 0
                            $taskList = [System.Collections.ArrayList]@()
                        }
                    }
                }
            }
        }
        catch {
            if ($ErrorActionPreference -eq 'Stop') {
                $PSCmdlet.ThrowTerminatingError($_)
            }
            else {
                Write-Error $_
            }
        }
        finally {
            if ($Host.Name -and $Host.Name -notlike "Windows*PowerShell*ISE*") {
                [System.Console]::CursorVisible = $true
            }
        }
    }
    End {
        if (-not $Wait) {
            $fullTaskList
        }
        else {
            try {
                Watch-GSDriveUpload -Id $fullTaskList.Id -CountUploaded $totalFiles -TotalUploading $totalFiles
                $fullStatusList = Get-GSDriveFileUploadStatus -Id $fullTaskList.Id
                $failedFiles = $fullStatusList | Where-Object {$_.Status -eq "Failed"}
                if (!$failedFiles) {
                    Write-Verbose "All files uploaded to Google Drive successfully! Total time: $("{0:c}" -f ((Get-Date) - $start) -replace "\..*")"
                }
                elseif ($RetryCount) {
                    $totalRetries = 0
                    do {
                        $throttleCount = 0
                        $totalThrottleCount = 0
                        $taskList = [System.Collections.ArrayList]@()
                        $fullTaskList = [System.Collections.ArrayList]@()
                        $details = Get-Item $failedFiles.File
                        $totalFiles = [int]$totalFiles + $details.Count
                        $totalRetries++
                        Write-Verbose "~ ~ ~ RETRYING [$totalFiles] FAILED FILES [Retry # $totalRetries / $RetryCount] ~ ~ ~"
                        $details = Get-Item $failedFiles.File
                        foreach ($detPart in $details) {
                            $throttleCount++
                            $contentType = Get-MimeType $detPart
                            $body = New-Object 'Google.Apis.Drive.v3.Data.File' -Property @{
                                Name = [String]$detPart.Name
                            }
                            $parPath = "$(Split-Path $detPart.FullName -Parent)"
                            $body.Parents = [String[]]$folIdHash[$parPath]
                            if ($Description) {
                                $body.Description = $Description
                            }
                            $stream = New-Object 'System.IO.FileStream' $detPart.FullName,([System.IO.FileMode]::Open),([System.IO.FileAccess]::Read),([System.IO.FileShare]::Delete + [System.IO.FileShare]::ReadWrite)
                            $request = $service.Files.Create($body,$stream,$contentType)
                            $request.QuotaUser = $User
                            $request.SupportsAllDrives = $true
                            $request.ChunkSize = 512KB
                            $upload = $request.UploadAsync()
                            $task = $upload.ContinueWith([System.Action[System.Threading.Tasks.Task]] {$stream.Dispose()})
                            Write-Verbose "[$($detPart.Name)] Upload Id $($upload.Id) has started"
                            if (!$Script:DriveUploadTasks) {
                                $Script:DriveUploadTasks = [System.Collections.ArrayList]@()
                            }
                            $script:DriveUploadTasks += [PSCustomObject]@{
                                Id             = $upload.Id
                                File           = $detPart
                                Length         = $detPart.Length
                                SizeInMB       = [Math]::Round(($detPart.Length / 1MB),2,[MidPointRounding]::AwayFromZero)
                                StartTime      = $(Get-Date)
                                Parents        = $body.Parents
                                User           = $User
                                Upload         = $upload
                                Request        = $request
                                Stream         = $stream
                                StreamDisposed = $false
                            }
                            $taskList += [PSCustomObject]@{
                                Id       = $upload.Id
                                File     = $detPart
                                SizeInMB = [Math]::Round(($detPart.Length / 1MB),2,[MidPointRounding]::AwayFromZero)
                                User     = $User
                            }
                            $fullTaskList += [PSCustomObject]@{
                                Id       = $upload.Id
                                File     = $detPart
                                SizeInMB = [Math]::Round(($detPart.Length / 1MB),2,[MidPointRounding]::AwayFromZero)
                                User     = $User
                            }
                            if ($throttleCount -ge $ThrottleLimit) {
                                $totalThrottleCount += $throttleCount
                                if ($Wait) {
                                    Watch-GSDriveUpload -Id $taskList.Id -CountUploaded $totalThrottleCount -TotalUploading $totalFiles -Action Retrying
                                    $throttleCount = 0
                                    $taskList = [System.Collections.ArrayList]@()
                                }
                            }
                        }
                        Watch-GSDriveUpload -Id $fullTaskList.Id -Action Retrying -CountUploaded $totalFiles -TotalUploading $totalFiles
                        $fullStatusList = Get-GSDriveFileUploadStatus -Id $fullTaskList.Id
                        $failedFiles = $fullStatusList | Where-Object {$_.Status -eq "Failed"}
                    }
                    until (!$failedFiles -or ($totalRetries -ge $RetryCount))
                    if ($failedFiles) {
                        Write-Warning "The following files failed to upload:`n`n$($failedFiles | Select-Object Id,Status,Exception,File | Format-List | Out-String)"
                    }
                    elseif (!$failedFiles) {
                        Write-Verbose "All files uploaded to Google Drive successfully! Total time: $("{0:c}" -f ((Get-Date) - $start) -replace "\..*")"
                    }
                }
            }
            catch {
                if ($ErrorActionPreference -eq 'Stop') {
                    $PSCmdlet.ThrowTerminatingError($_)
                }
                else {
                    Write-Error $_
                }
            }
            finally {
                if ($Host.Name -and $Host.Name -notlike "Windows*PowerShell*ISE*") {
                    [System.Console]::CursorVisible = $true
                }
                Stop-GSDriveFileUpload
            }
        }
    }
}
