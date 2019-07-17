function Get-GSDriveRevision {
    <#
    .SYNOPSIS
    Gets information about a Drive file's revisions

    .DESCRIPTION
    Gets information about a Drive file's revisions

    .PARAMETER FileId
    The unique Id of the file to get revisions of

    .PARAMETER RevisionId
    The unique Id of the revision to get. If excluded, gets the list of revisions for the file

    .PARAMETER User
    The email or unique Id of the owner of the Drive file

    Defaults to the AdminEmail user

    .PARAMETER Fields
    The specific fields to returned

    .EXAMPLE
    Get-GSDriveFile -FileId $fileId | Get-GSDriveRevision

    Gets the list of revisions for the file

    .EXAMPLE
    Get-GSDriveRevision -FileId $fileId -Limit 1

    Gets the most recent revision for the file
    #>
    [OutputType('Google.Apis.Drive.v3.Data.Revision')]
    [cmdletbinding(DefaultParameterSetName = "List")]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [Alias('Id')]
        [String]
        $FileId,
        [parameter(Mandatory = $false,Position = 1,ParameterSetName = "Get")]
        [String[]]
        $RevisionId,
        [parameter(Mandatory = $false,ParameterSetName = "Get")]
        [Alias('SaveFileTo')]
        [String]
        $OutFilePath,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [Alias('Owner','PrimaryEmail','UserKey','Mail')]
        [string]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false)]
        [String[]]
        $Fields = '*',
        [parameter(Mandatory = $false,ParameterSetName = "Get")]
        [Switch]
        $Force,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [Alias('MaxResults')]
        [ValidateRange(1,1000)]
        [Int]
        $PageSize = 1000,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [Alias('First')]
        [Int]
        $Limit = 0
    )
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
        switch ($PSCmdlet.ParameterSetName) {
            Get {
                try {
                    foreach ($revision in $RevisionId) {
                        $request = $service.Revisions.Get($FileId,$revision)
                        $baseVerbose = "Getting"
                        if ($Fields) {
                            $baseVerbose += " Fields [$($Fields -join ",")] of"
                            $request.Fields = $($Fields -join ",")
                        }
                        $baseVerbose += " Drive File Revision Id '$revision' of File Id '$FileId' for User '$User'"
                        Write-Verbose $baseVerbose
                        $res = $request.Execute() | Add-Member -MemberType NoteProperty -Name 'User' -Value $User -PassThru | Add-Member -MemberType NoteProperty -Name 'FileId' -Value $FileId -PassThru
                        if ($OutFilePath) {
                            if (Test-Path $OutFilePath) {
                                $outFilePathItem = Get-Item $OutFilePath -ErrorAction SilentlyContinue
                                if ($outFilePathItem.PSIsContainer) {
                                    $resPath = $outFilePathItem.FullName
                                    $cleanedName = Get-SafeFileName "$($res.Name).$($res.FileExtension)"
                                    $filePath = Join-Path $resPath $cleanedName
                                }
                                elseif ($Force) {
                                    $endings = [System.Collections.Generic.List[string]]@('.bak')
                                    1..100 | ForEach-Object {$endings.Add(".bak$_")}
                                    foreach ($end in $endings) {
                                        $backupPath = "$($outFilePathItem.FullName)$end"
                                        if (-not (Test-Path $backupPath)) {
                                            break
                                        }
                                        else {
                                            $backupPath = $null
                                        }
                                    }
                                    Write-Warning "Renaming '$($outFilePathItem.Name)' to '$($outFilePathItem.Name).bak' in case replacement download fails."
                                    Rename-Item $outFilePathItem.FullName -NewName $backupPath -Force
                                    $filePath = $OutFilePath
                                }
                                else {
                                    throw "File already exists at path '$($OutFilePath)'. Please specify -Force to overwrite any files with the same name if they exist."
                                }
                            }
                            else {
                                $filePath = $OutFilePath
                            }
                            Write-Verbose "Saving file to path '$filePath'"
                            $stream = [System.IO.File]::Create($filePath)
                            $request.Download($stream)
                            $stream.Close()
                            $res | Add-Member -MemberType NoteProperty -Name OutFilePath -Value $filePath -Force
                            if ($backupPath) {
                                Write-Verbose "File has been downloaded successfully! Removing the backup file at path: $backupPath"
                                Remove-Item $backupPath -Recurse -Force -Confirm:$false
                            }
                        }
                        $res
                    }
                }
                catch {
                    $err = $_
                    if ($backupPath) {
                        if (Test-Path $outFilePathItem.FullName) {
                            Remove-Item $outFilePathItem.FullName -Recurse -Force
                        }
                        Rename-Item $backupPath -NewName $outFilePathItem.FullName -Force
                    }
                    if ($ErrorActionPreference -eq 'Stop') {
                        $PSCmdlet.ThrowTerminatingError($err)
                    }
                    else {
                        Write-Error $err
                    }
                }
            }
            List {
                try {
                    $request = $service.Revisions.List($FileId)
                    if ($Limit -gt 0 -and $PageSize -gt $Limit) {
                        Write-Verbose ("Reducing PageSize from {0} to {1} to meet limit with first page" -f $PageSize,$Limit)
                        $PageSize = $Limit
                    }
                    $request.PageSize = $PageSize
                    if ($Fields) {
                        $request.Fields = "$($Fields -join ",")"
                    }
                    $baseVerbose = "Getting"
                    if ($Fields) {
                        $baseVerbose += " Fields [$($Fields -join ",")] of"
                    }
                    $baseVerbose += " all Drive File Revisions of File Id '$FileId' for User '$User'"
                    Write-Verbose $baseVerbose
                    [int]$i = 1
                    $overLimit = $false
                    do {
                        $result = $request.Execute()
                        $result.Revisions | Add-Member -MemberType NoteProperty -Name 'User' -Value $User -PassThru | Add-Member -MemberType NoteProperty -Name 'FileId' -Value $FileId -PassThru
                        if ($result.NextPageToken) {
                            $request.PageToken = $result.NextPageToken
                        }
                        [int]$retrieved = ($i + $result.Revisions.Count) - 1
                        Write-Verbose "Retrieved $retrieved Revisions..."
                        if ($Limit -gt 0 -and $retrieved -eq $Limit) {
                            Write-Verbose "Limit reached: $Limit"
                            $overLimit = $true
                        }
                        elseif ($Limit -gt 0 -and ($retrieved + $PageSize) -gt $Limit) {
                            $newPS = $Limit - $retrieved
                            Write-Verbose ("Reducing PageSize from {0} to {1} to meet limit with next page" -f $PageSize,$newPS)
                            $request.PageSize = $newPS
                        }
                        [int]$i = $i + $result.Revisions.Count
                    }
                    until ($overLimit -or !$result.NextPageToken)
                }
                catch {
                    if ($ErrorActionPreference -eq 'Stop') {
                        $PSCmdlet.ThrowTerminatingError($_)
                    }
                    else {
                        Write-Error $_
                    }
                }
            }
        }
    }
}
