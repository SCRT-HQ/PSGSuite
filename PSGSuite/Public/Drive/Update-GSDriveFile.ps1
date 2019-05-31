function Update-GSDriveFile {
    <#
    .SYNOPSIS
    Updates the metadata for a Drive file

    .DESCRIPTION
    Updates the metadata for a Drive file

    .PARAMETER FileId
    The unique Id of the Drive file to Update

    .PARAMETER Path
    The path to the local file whose content you would like to upload to Drive.

    .PARAMETER Name
    The name of the Drive file

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

    .PARAMETER AddParents
    The parent Ids to add

    .PARAMETER RemoveParents
    The parent Ids to remove

    .PARAMETER CopyRequiresWriterPermission
    Whether the options to copy, print, or download this file, should be disabled for readers and commenters.

    .PARAMETER Starred
    Whether the user has starred the file.

    .PARAMETER Trashed
    Whether the file has been trashed, either explicitly or from a trashed parent folder.

    Only the owner may trash a file, and other users cannot see files in the owner's trash.

    .PARAMETER Projection
    The defined subset of fields to be returned

    Available values are:
    * "Minimal"
    * "Standard"
    * "Full"
    * "Access"

    .PARAMETER Fields
    The specific fields to returned

    .PARAMETER User
    The email or unique Id of the Drive file owner

    .EXAMPLE
    Update-GSDriveFile -FileId '1rhsAYTOB_vrpvfwImPmWy0TcVa2sgmQa_9u976' -Name "To-Do Progress"

    Updates the Drive file with a new name, "To-Do Progress"

    .EXAMPLE
    Update-GSDriveFile -FileId '1rhsAYTOB_vrpvfwImPmWy0TcVa2sgmQa_9u976' -Path "C:\Pics\NewPic.png"

    Updates the Drive file with the content of the file at that path. In this example, the Drive file is a PNG named "Test.png". This will change the content of the file in Drive to match NewPic.png as well as rename it to "NewPic.png"
    #>
    [OutputType('Google.Apis.Drive.v3.Data.File')]
    [cmdletbinding(DefaultParameterSetName = "Depth")]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [Alias('Id')]
        [string]
        $FileId,
        [parameter(Mandatory = $false,Position = 1)]
        [ValidateScript( { Test-Path $_ })]
        [string]
        $Path,
        [parameter(Mandatory = $false)]
        [string]
        $Name,
        [parameter(Mandatory = $false)]
        [String]
        $Description,
        [parameter(Mandatory = $false)]
        [ValidateSet('ChocolateIceCream','OldBrickRed','Cardinal','WildStrawberries','MarsOrange','YellowCab','Spearmint','VernFern','Asparagus','SlimeGreen','DesertSand','Macaroni','SeaFoam','Pool','Denim','RainySky','BlueVelvet','PurpleDino','Mouse','MountainGrey','Earthworm','BubbleGum','PurpleRain','ToyEggplant')]
        [string]
        $FolderColorRgb,
        [parameter(Mandatory = $false)]
        [string[]]
        $AddParents,
        [parameter(Mandatory = $false)]
        [String[]]
        $RemoveParents,
        [parameter(Mandatory = $false)]
        [switch]
        $CopyRequiresWriterPermission,
        [parameter(Mandatory = $false)]
        [switch]
        $Starred,
        [parameter(Mandatory = $false)]
        [switch]
        $Trashed,
        [parameter(Mandatory = $false)]
        [switch]
        $WritersCanShare,
        [parameter(Mandatory = $false,ParameterSetName = "Depth")]
        [Alias('Depth')]
        [ValidateSet("Minimal","Standard","Full","Access")]
        [String]
        $Projection = "Full",
        [parameter(Mandatory = $false,ParameterSetName = "Fields")]
        [ValidateSet("appProperties","capabilities","contentHints","createdTime","description","explicitlyTrashed","fileExtension","folderColorRgb","fullFileExtension","hasThumbnail","headRevisionId","iconLink","id","imageMediaMetadata","isAppAuthorized","kind","lastModifyingUser","md5Checksum","mimeType","modifiedByMe","modifiedByMeTime","modifiedTime","name","originalFilename","ownedByMe","owners","parents","permissions","properties","quotaBytesUsed","shared","sharedWithMeTime","sharingUser","size","spaces","starred","thumbnailLink","thumbnailVersion","trashed","version","videoMediaMetadata","viewedByMe","viewedByMeTime","viewersCanCopyContent","webContentLink","webViewLink","writersCanShare")]
        [String[]]
        $Fields,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [Alias('Owner','PrimaryEmail','UserKey','Mail')]
        [string]
        $User = $Script:PSGSuite.AdminEmail
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
            $body = New-Object 'Google.Apis.Drive.v3.Data.File'
            foreach ($prop in $PSBoundParameters.Keys | Where-Object { $body.PSObject.Properties.Name -contains $_ }) {
                switch ($prop) {
                    Name {
                        $body.Name = [String]$Name
                    }
                    FolderColorRgb {
                        $body.FolderColorRgb = $ColorDictionary[$FolderColorRgb]
                    }
                    Default {
                        $body.$prop = $PSBoundParameters[$prop]
                    }
                }
            }
            if ($PSBoundParameters.Keys -contains 'Path') {
                $ioFile = Get-Item $Path
                $contentType = Get-MimeType $ioFile
                if ($PSBoundParameters.Keys -notcontains 'Name') {
                    $body.Name = $ioFile.Name
                }
                $stream = New-Object 'System.IO.FileStream' $ioFile.FullName,'Open','Read'
                $request = $service.Files.Update($body,$FileId,$stream,$contentType)
                $request.QuotaUser = $User
                $request.ChunkSize = 512KB
            }
            else {
                $request = $service.Files.Update($body,$FileId)
            }
            $request.SupportsAllDrives = $true
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
            if ($PSBoundParameters.Keys -contains 'Path') {
                $request.Upload() | Out-Null
                $stream.Close()
            }
            else {
                $request.Execute() | Add-Member -MemberType NoteProperty -Name 'User' -Value $User -PassThru
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
    }
}
