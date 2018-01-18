function Update-GSDriveFile {
    [cmdletbinding(DefaultParameterSetName = "Depth")]
    Param
    (
      [parameter(Mandatory=$true,Position = 0,ValueFromPipelineByPropertyName = $true)]
      [Alias('Id')]
      [String]
      $FileId,
      [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
      [Alias('Owner','PrimaryEmail','UserKey','Mail')]
      [string]
      $User = $Script:PSGSuite.AdminEmail,
      [parameter(Mandatory=$false)]
      [String]
      $Name,
      [parameter(Mandatory=$false)]
      [String]
      $Description,
      [parameter(Mandatory=$false)]
      [String[]]
      $AddParents,
      [parameter(Mandatory=$false)]
      [String[]]
      $RemoveParents,
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
            $body = New-Object 'Google.Apis.Drive.v3.Data.File'
            if ($Name) {
                $body.Name = [String]$Name
            }
            $request = $service.Files.Update($body,$FileId)
            $request.SupportsTeamDrives = $true
            if ($fs) {
                $request.Fields = $($fs -join ",")
            }
            if ($AddParents) {
                $request.AddParents = $($AddParents -join ",")
            }
            if ($RemoveParents) {
                $request.RemoveParents = $($RemoveParents -join ",")
            }
            Write-Verbose "Updating file '$FileId' for user '$User'"
            $request.Execute() | Select-Object @{N = "User";E = {$User}},*
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}