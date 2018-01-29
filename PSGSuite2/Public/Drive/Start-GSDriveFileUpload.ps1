function Start-GSDriveFileUpload {
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias('FullName')]
        [ValidateScript({Test-Path $_})]
        [String[]]
        $Path,
        [parameter(Mandatory = $false)]
        [String]
        $Name,
        [parameter(Mandatory = $false)]
        [String]
        $Description,
        [parameter(Mandatory = $false)]
        [String[]]
        $Parents,
        [parameter(Mandatory = $false)]
        [Switch]
        $Wait,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [Alias('Owner','PrimaryEmail','UserKey','Mail')]
        [string]
        $User = $Script:PSGSuite.AdminEmail
    )
    Begin {
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
        $taskList = [System.Collections.ArrayList]@()
    }
    Process {
        try {
            foreach ($file in $Path) {
                $details = Get-Item $file
                $contentType = Get-MimeType $details
                $body = New-Object 'Google.Apis.Drive.v3.Data.File' -Property @{
                    Name = [String]$details.Name
                }
                if ($Parents) {
                    $body.Parents = [String[]]$Parents
                }
                if ($Description) {
                    $body.Description = $Description
                }
                $stream = New-Object 'System.IO.FileStream' $details.FullName,'Open','Read'
                $request = $service.Files.Create($body,$stream,$contentType)
                $request.SupportsTeamDrives = $true
                $request.ChunkSize = 512KB
                $request.GetProgress()
                $upload = $request.UploadAsync()
                $task = $upload.ContinueWith([System.Action[System.Threading.Tasks.Task]]{$stream.Dispose()})
                Write-Verbose "[$($details.Name)] upload started for user '$User'. You can check the status with Get-GSDriveFileUploadStatus -Id $($upload.Id)"
                if (!$Script:DriveUploadTasks) {
                    $Script:DriveUploadTasks = [System.Collections.ArrayList]@()
                }
                $script:DriveUploadTasks += [PSCustomObject]@{
                    Id = $upload.Id
                    File = $details
                    Length = $details.Length
                    SizeInMB = [Math]::Round(($details.Length/1MB),2,[MidPointRounding]::AwayFromZero)
                    StartTime = $(Get-Date)
                    User = $User
                    Upload = $upload
                    Request = $request
                }
                $taskList += [PSCustomObject]@{
                    Id = $upload.Id
                    File = $details
                    Length = $details.Length
                    SizeInMB = [Math]::Round(($details.Length/1MB),2,[MidPointRounding]::AwayFromZero)
                    StartTime = $(Get-Date)
                    User = $User
                    Upload = $upload
                    Request = $request
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
    End {
        if (!$Wait) {
            $taskList | Select-Object Id,File,SizeInMB,User
        }
        else {
            do {
                $i = 1
                $statusList = Get-GSDriveFileUploadStatus -Id $taskList.Id
                $totalPercent = 0
                $totalSecondsRemaining = 0
                $count = 0
                $statusList | ForEach-Object {
                    $count++
                    $totalPercent += $_.PercentComplete
                    $totalSecondsRemaining += $_.Remaining.TotalSeconds
                }
                $totalPercent = $totalPercent / $count
                $totalSecondsRemaining = $totalSecondsRemaining / $count
                $parentParams = @{
                    Activity = "[$([Math]::Round($totalPercent,4))%] Uploading $count files to Google Drive"
                    SecondsRemaining = $($statusList.Remaining.TotalSeconds | Sort-Object | Select-Object -Last 1)
                }
                if (!($statusList | Where-Object {$_.Status -ne "Completed"})) {
                    $parentParams['Completed'] = $true
                }
                else {
                    $parentParams['PercentComplete'] = [Math]::Round($totalPercent,4)
                }
                if ($psEditor -or $IsMacOS -or $IsLinux) {
                    Write-InlineProgress @parentParams
                }
                else {
                    $parentParams['Id'] = 1
                    Write-Progress @parentParams
                }
                if (!$psEditor -and !$IsMacOS -and !$IsLinux) {
                    foreach ($status in $statusList) {
                        $i++
                        $statusFmt = if ($status.Status -eq "Completed") {
                            "Completed uploading"
                        }
                        else {
                            $status.Status
                        }
                        $progParams = @{
                            Activity = "[$($status.PercentComplete)%] [ID: $($status.Id)] $($statusFmt) file '$($status.File.FullName)' to Google Drive$(if($Parents){" (Parents: '$($Parents -join "', '")')"})"
                            SecondsRemaining = $status.Remaining.TotalSeconds
                            Id = $i
                            ParentId = 1
                            PercentComplete = $status.PercentComplete
                        }
                        Write-Progress @progParams
                    }
                }
            }
            until (!($statusList | Where-Object {$_.Status -ne "Completed"}))
            Write-Verbose "All files have finished uploading!"
        }
    }
}