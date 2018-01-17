function Get-GSDriveFile {
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
        [ValidateScript({Test-Path $_})]
        [String]
        $OutFilePath,
        [parameter(Mandatory = $false,ParameterSetName = "Depth")]
        [ValidateSet("Minimal","Standard","Full","Access")]
        [String]
        $Depth = "Full",
        [parameter(Mandatory = $false,ParameterSetName = "Fields")]
        [ValidateSet("appProperties","capabilities","contentHints","createdTime","description","explicitlyTrashed","fileExtension","folderColorRgb","fullFileExtension","hasThumbnail","headRevisionId","iconLink","id","imageMediaMetadata","isAppAuthorized","kind","lastModifyingUser","md5Checksum","mimeType","modifiedByMe","modifiedByMeTime","modifiedTime","name","originalFilename","ownedByMe","owners","parents","permissions","properties","quotaBytesUsed","shared","sharedWithMeTime","sharingUser","size","spaces","starred","thumbnailLink","thumbnailVersion","trashed","version","videoMediaMetadata","viewedByMe","viewedByMeTime","viewersCanCopyContent","webContentLink","webViewLink","writersCanShare")]
        [String[]]
        $Fields
    )
    Begin {
        if ($Depth) {
            if ($Depth -eq "Standard") {
                $fs = @("createdTime","description","fileExtension","id","lastModifyingUser","modifiedTime","name","owners","parents","properties","version","webContentLink","webViewLink")
            }
            elseif ($Depth -eq "Access") {
                $fs = @("createdTime","description","fileExtension","id","lastModifyingUser","modifiedTime","name","ownedByMe","owners","parents","permissionIds","permissions","shared","sharedWithMeTime","sharingUser","viewedByMe","viewedByMeTime","viewersCanCopyContent","writersCanShare")
            }
            elseif ($Depth -eq "Full") {
                $fs = @("appProperties","capabilities","contentHints","createdTime","description","explicitlyTrashed","fileExtension","folderColorRgb","fullFileExtension","hasAugmentedPermissions","hasThumbnail","headRevisionId","iconLink","id","imageMediaMetadata","isAppAuthorized","kind","lastModifyingUser","md5Checksum","mimeType","modifiedByMe","modifiedByMeTime","modifiedTime","name","originalFilename","ownedByMe","owners","parents","permissionIds","permissions","properties","quotaBytesUsed","shared","sharedWithMeTime","sharingUser","size","spaces","starred","teamDriveId","thumbnailLink","thumbnailVersion","trashed","trashedTime","trashingUser","version","videoMediaMetadata","viewedByMe","viewedByMeTime","viewersCanCopyContent","webContentLink","webViewLink","writersCanShare")
            }
        }
        elseif ($Fields) {
            $fs = $Fields
        }
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
    }
    Process {
        foreach ($file in $FileId) {
            $request = $service.Files.Get($file)
            $request.SupportsTeamDrives = $true
            if ($fs) {
                $request.Fields = $($fs -join ",")
            }
            $res = $request.Execute() | Select-Object @{N = "User";E = {$User}},*
            if ($OutFilePath -and $res.FileExtension) {
                $resPath = Resolve-Path $OutFilePath
                $filePath = Join-Path $resPath "$($res.Name).$($res.FileExtension)"
                Write-Verbose "Saving file to path '$filePath'"
                $stream = [System.IO.File]::Create($filePath)
                $request.Download($stream)
                $stream.Close()
            }
            $res
        }
    }
}