function Get-GSDriveFile {
    <#
    .SYNOPSIS
    Gets information about or downloads a Drive file

    .DESCRIPTION
    Gets information about or downloads a Drive file

    .PARAMETER FileId
    The unique Id of the file to get

    .PARAMETER User
    The email or unique Id of the owner of the Drive file

    Defaults to the AdminEmail user

    .PARAMETER OutFilePath
    The directory path that you would like to download the Drive file to. If excluded, only the Drive file information will be returned

    .PARAMETER Projection
    The defined subset of fields to be returned

    Available values are:
    * "Standard"
    * "Full"
    * "Access"

    .PARAMETER Fields
    The specific fields to returned

    .PARAMETER Force
    If $true and OutFilePath is specified, overwrites any existing files at the desired path.

    .EXAMPLE
    Get-GSDriveFile -FileId '1rhsAYTOB_vrpvfwImPmWy0TcVa2sgmQa_9u976'

    Gets the information for the file

    .EXAMPLE
    Get-GSDriveFile -FileId '1rhsAYTOB_vrpvfwImPmWy0TcVa2sgmQa_9u976' -OutFilePath (Get-Location).Path

    Gets the information for the file and saves the file in the current working directory
    #>
    [OutputType('Google.Apis.Drive.v3.Data.File')]
    [cmdletbinding(DefaultParameterSetName = "Depth")]
    Param
    (
        [parameter(Mandatory = $true,Position = 0)]
        [String[]]
        $FileId,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [Alias('Owner','PrimaryEmail','UserKey','Mail')]
        [string]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false)]
        [Alias('SaveFileTo')]
        [String]
        $OutFilePath,
        [parameter(Mandatory = $false,ParameterSetName = "Depth")]
        [Alias('Depth')]
        [ValidateSet("Standard","Full","Access")]
        [String]
        $Projection = "Full",
        [parameter(Mandatory = $false,ParameterSetName = "Fields")]
        [ValidateSet("appProperties","capabilities","contentHints","createdTime","description","explicitlyTrashed","fileExtension","folderColorRgb","fullFileExtension","hasThumbnail","headRevisionId","iconLink","id","imageMediaMetadata","isAppAuthorized","kind","lastModifyingUser","md5Checksum","mimeType","modifiedByMe","modifiedByMeTime","modifiedTime","name","originalFilename","ownedByMe","owners","parents","permissions","properties","quotaBytesUsed","shared","sharedWithMeTime","sharingUser","size","spaces","starred","thumbnailLink","thumbnailVersion","trashed","version","videoMediaMetadata","viewedByMe","viewedByMeTime","viewersCanCopyContent","webContentLink","webViewLink","writersCanShare")]
        [String[]]
        $Fields,
        [parameter(Mandatory = $false)]
        [Switch]
        $Force
    )
    Begin {
        if ($PSCmdlet.ParameterSetName -eq 'Depth') {
            $fs = switch ($Projection) {
                Standard {
                    @("createdTime","description","fileExtension","id","lastModifyingUser","modifiedTime","name","owners","parents","properties","version","webContentLink","webViewLink")
                }
                Access {
                    @("createdTime","description","fileExtension","id","lastModifyingUser","modifiedTime","name","ownedByMe","owners","parents","permissionIds","permissions","shared","sharedWithMeTime","sharingUser","viewedByMe","viewedByMeTime","viewersCanCopyContent","writersCanShare")
                }
                Full {
                    @("appProperties","capabilities","contentHints","createdTime","description","explicitlyTrashed","fileExtension","folderColorRgb","fullFileExtension","hasAugmentedPermissions","hasThumbnail","headRevisionId","iconLink","id","imageMediaMetadata","isAppAuthorized","kind","lastModifyingUser","md5Checksum","mimeType","modifiedByMe","modifiedByMeTime","modifiedTime","name","originalFilename","ownedByMe","owners","parents","permissionIds","permissions","properties","quotaBytesUsed","shared","sharedWithMeTime","sharingUser","size","spaces","starred","teamDriveId","thumbnailLink","thumbnailVersion","trashed","trashedTime","trashingUser","version","videoMediaMetadata","viewedByMe","viewedByMeTime","viewersCanCopyContent","webContentLink","webViewLink","writersCanShare")
                }
            }
        }
        elseif ($PSBoundParameters.ContainsKey('Fields')) {
            $fs = $Fields
        }
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
            foreach ($file in $FileId) {
                $backupPath = $null
                $request = $service.Files.Get($file)
                $request.SupportsAllDrives = $true
                if ($fs) {
                    $request.Fields = $($fs -join ",")
                }
                $res = $request.Execute() | Add-Member -MemberType NoteProperty -Name 'User' -Value $User -PassThru
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
}
