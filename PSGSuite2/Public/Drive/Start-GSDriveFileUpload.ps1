function Start-GSDriveFileUpload {
    [cmdletbinding(DefaultParameterSetName = "Depth")]
    Param
    (
        [parameter(Mandatory = $true,Position = 0)]
        [ValidateScript({Test-Path $_})]
        [String[]]
        $Path,
        [parameter(Mandatory = $false)]
        [Switch]
        $UploadAsync,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [Alias('Owner','PrimaryEmail','UserKey','Mail')]
        [string]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false)]
        [String]
        $Name,
        [parameter(Mandatory = $false)]
        [String]
        $Description,
        [parameter(Mandatory = $false)]
        [String[]]
        $Parents,
        [parameter(Mandatory = $false,ParameterSetName = "Depth")]
        [Alias('Depth')]
        [ValidateSet("Minimal","Standard","Full","Access")]
        [String]
        $Projection = "Full",
        [parameter(Mandatory = $false,ParameterSetName = "Fields")]
        [ValidateSet("appProperties","capabilities","contentHints","createdTime","description","explicitlyTrashed","fileExtension","folderColorRgb","fullFileExtension","hasThumbnail","headRevisionId","iconLink","id","imageMediaMetadata","isAppAuthorized","kind","lastModifyingUser","md5Checksum","mimeType","modifiedByMe","modifiedByMeTime","modifiedTime","name","originalFilename","ownedByMe","owners","parents","permissions","properties","quotaBytesUsed","shared","sharedWithMeTime","sharingUser","size","spaces","starred","thumbnailLink","thumbnailVersion","trashed","version","videoMediaMetadata","viewedByMe","viewedByMeTime","viewersCanCopyContent","webContentLink","webViewLink","writersCanShare")]
        [String[]]
        $Fields
    )
    Begin {
        if ($Projection) {
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
                if ($fs) {
                    $request.Fields = $($fs -join ",")
                }
                if ($UploadAsync) {
                    Write-Verbose "Uploading file '$($details.FullName)' asynchronously for user '$User'"
                    $upload = $request.UploadAsync() #| Select-Object @{N = "User";E = {$User}},@{N = "Source";E = {$details.FullName}},*
                    $task = $upload.ContinueWith([System.Action[System.Threading.Tasks.Task]]{$stream.Close()})
                    Write-Verbose "Upload started, use 'Get-GSDriveFileUploadStatus to check on completion status'"
                    if (!$Script:DriveUploadTasks) {
                        $Script:DriveUploadTasks = [System.Collections.ArrayList]@()
                    }
                    $script:DriveUploadTasks += [PSCustomObject]@{
                        Id = $upload.Id
                        File = $details.FullName
                        Upload = $upload
                        User = $User
                    }
                }
                else {
                    Write-Verbose "Uploading file '$($details.FullName)' for user '$User'"
                    $request.Upload() | Select-Object @{N = "User";E = {$User}},@{N = "Source";E = {$details.FullName}},*
                    $stream.Close()
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}