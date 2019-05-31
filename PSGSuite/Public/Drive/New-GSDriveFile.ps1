function New-GSDriveFile {
    <#
    .SYNOPSIS
    Creates a blank Drive file

    .DESCRIPTION
    Creates a blank Drive file

    .PARAMETER User
    The email or unique Id of the user who you are creating the Drive file for

    Defaults to the AdminEmail user

    .PARAMETER Name
    The name of the new Drive file

    .PARAMETER Description
    The description of the Drive file

    .PARAMETER FolderColorRgb
    The color for a folder as an RGB hex string.

    Available values are:
    * "ChocolateIceCream"
    * "OldBrickRed"
    * "Cardinal"
    * "WildStrawberries"
    * "MarsOrange"
    * "YellowCab"
    * "Spearmint"
    * "VernFern"
    * "Asparagus"
    * "SlimeGreen"
    * "DesertSand"
    * "Macaroni"
    * "SeaFoam"
    * "Pool"
    * "Denim"
    * "RainySky"
    * "BlueVelvet"
    * "PurpleDino"
    * "Mouse"
    * "MountainGrey"
    * "Earthworm"
    * "BubbleGum"
    * "PurpleRain"
    * "ToyEggplant"

    .PARAMETER Parents
    The parent folder Id of the new Drive file

    .PARAMETER MimeType
    The Google Mime Type of the new Drive file

    Available values are:
    * "Audio"
	* "Docs"
	* "Drawing"
	* "DriveFile"
	* "DriveFolder"
	* "Form"
	* "FusionTables"
	* "Map"
	* "Photo"
	* "Slides"
	* "AppsScript"
	* "Sites"
	* "Sheets"
	* "Unknown"
	* "Video"

    .PARAMETER CustomMimeType
    The custom Mime Type of the new Drive file

    .PARAMETER Projection
    The defined subset of fields to be returned

    Available values are:
    * "Minimal"
    * "Standard"
    * "Full"
    * "Access"

    .PARAMETER Fields
    The specific fields to returned

    .EXAMPLE
    New-GSDriveFile -Name "Training Docs" -MimeType DriveFolder

    Creates a new folder in Drive named "Training Docs" in the root OrgUnit for the AdminEmail user
    #>
    [OutputType('Google.Apis.Drive.v3.Data.File')]
    [cmdletbinding(DefaultParameterSetName = "BuiltIn")]
    Param
    (
        [parameter(Mandatory = $false,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [Alias('Owner','PrimaryEmail','UserKey','Mail')]
        [string]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $true)]
        [String]
        $Name,
        [parameter(Mandatory = $false)]
        [String]
        $Description,
        [parameter(Mandatory = $false)]
        [ValidateSet('ChocolateIceCream','OldBrickRed','Cardinal','WildStrawberries','MarsOrange','YellowCab','Spearmint','VernFern','Asparagus','SlimeGreen','DesertSand','Macaroni','SeaFoam','Pool','Denim','RainySky','BlueVelvet','PurpleDino','Mouse','MountainGrey','Earthworm','BubbleGum','PurpleRain','ToyEggplant')]
        [string]
        $FolderColorRgb,
        [parameter(Mandatory = $false)]
        [Alias('ParentId')]
        [String[]]
        $Parents,
        [parameter(Mandatory = $true,ParameterSetName = "BuiltIn")]
        [Alias('Type')]
        [ValidateSet("Audio","Docs","Drawing","DriveFile","DriveFolder","Form","FusionTables","Map","Photo","Slides","AppsScript","Sites","Sheets","Unknown","Video")]
        [String]
        $MimeType,
        [parameter(Mandatory = $true,ParameterSetName = "Custom")]
        [String]
        $CustomMimeType,
        [parameter(Mandatory = $false)]
        [Alias('Depth')]
        [ValidateSet("Minimal","Standard","Full","Access")]
        [String]
        $Projection = "Full",
        [parameter(Mandatory = $false)]
        [ValidateSet("appProperties","capabilities","contentHints","createdTime","description","explicitlyTrashed","fileExtension","folderColorRgb","fullFileExtension","hasThumbnail","headRevisionId","iconLink","id","imageMediaMetadata","isAppAuthorized","kind","lastModifyingUser","md5Checksum","mimeType","modifiedByMe","modifiedByMeTime","modifiedTime","name","originalFilename","ownedByMe","owners","parents","permissions","properties","quotaBytesUsed","shared","sharedWithMeTime","sharingUser","size","spaces","starred","thumbnailLink","thumbnailVersion","trashed","version","videoMediaMetadata","viewedByMe","viewedByMeTime","viewersCanCopyContent","webContentLink","webViewLink","writersCanShare")]
        [String[]]
        $Fields
    )
    Begin {
        $colorDictionary = @{
            ChocolateIceCream = '#ac725e'
            OldBrickRed       = '#d06b64'
            Cardinal          = '#f83a22'
            WildStrawberries  = '#fa573c'
            MarsOrange        = '#ff7537'
            YellowCab         = '#ffad46'
            Spearmint         = '#42d692'
            VernFern          = '#16a765'
            Asparagus         = '#7bd148'
            SlimeGreen        = '#b3dc6c'
            DesertSand        = '#fbe983'
            Macaroni          = '#fad165'
            SeaFoam           = '#92e1c0'
            Pool              = '#9fe1e7'
            Denim             = '#9fc6e7'
            RainySky          = '#4986e7'
            BlueVelvet        = '#9a9cff'
            PurpleDino        = '#b99aff'
            Mouse             = '#8f8f8f'
            MountainGrey      = '#cabdbf'
            Earthworm         = '#cca6ac'
            BubbleGum         = '#f691b2'
            PurpleRain        = '#cd74e6'
            ToyEggplant       = '#a47ae2'
        }
        $mimeHash = @{
            Audio        = "application/vnd.google-apps.audio"
            Docs         = "application/vnd.google-apps.document"
            Drawing      = "application/vnd.google-apps.drawing"
            DriveFile    = "application/vnd.google-apps.file"
            DriveFolder  = "application/vnd.google-apps.folder"
            Form         = "application/vnd.google-apps.form"
            FusionTables = "application/vnd.google-apps.fusiontable"
            Map          = "application/vnd.google-apps.map"
            Photo        = "application/vnd.google-apps.photo"
            Slides       = "application/vnd.google-apps.presentation"
            AppsScript   = "application/vnd.google-apps.script"
            Sites        = "application/vnd.google-apps.sites"
            Sheets       = "application/vnd.google-apps.spreadsheet"
            Unknown      = "application/vnd.google-apps.unknown"
            Video        = "application/vnd.google-apps.video"
        }
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
            $body = New-Object 'Google.Apis.Drive.v3.Data.File'
            if ($MimeType) {
                $body.MimeType = $mimeHash[$MimeType]
            }
            elseif ($CustomMimeType) {
                $body.MimeType = $CustomMimeType
            }
            if ($Description) {
                $body.Description = $Description
            }
            if ($FolderColorRgb) {
                $body.FolderColorRgb = $ColorDictionary[$FolderColorRgb]
            }
            if ($Name) {
                $body.Name = [String]$Name
            }
            if ($Parents) {
                $body.Parents = [String[]]$Parents
            }
            $request = $service.Files.Create($body)
            $request.SupportsAllDrives = $true
            if ($fs) {
                $request.Fields = $($fs -join ",")
            }
            Write-Verbose "Creating file '$Name' for user '$User'"
            $request.Execute() | Add-Member -MemberType NoteProperty -Name 'User' -Value $User -PassThru
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
