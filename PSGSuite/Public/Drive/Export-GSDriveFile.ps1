function Export-GSDriveFile {
    <#
    .SYNOPSIS
    Exports a Drive file as if you chose "Export" from the File menu when viewing the file

    .DESCRIPTION
    Exports a Drive file as if you chose "Export" from the File menu when viewing the file

    .PARAMETER FileID
    The unique Id of the file to export

    .PARAMETER User
    The email or unique Id of the owner of the Drive file

    Defaults to the AdminEmail user

    .PARAMETER Type
    The type of local file you would like to export the Drive file as

    Available values are:
    * "CSV"
    * "HTML"
    * "JPEG"
    * "JSON"
    * "MSExcel"
    * "MSPowerPoint"
    * "MSWordDoc"
    * "OpenOfficeDoc"
    * "OpenOfficeSheet"
    * "PDF"
    * "PlainText"
    * "PNG"
    * "RichText"
    * "SVG"

    .PARAMETER OutFilePath
    The directory path that you would like to export the Drive file to

    Defaults to the current working directory

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
    Export-GSDriveFile -FileId '1rhsAYTOB_vrpvfwImPmWy0TcVa2sgmQa_9u976' -Type CSV -OutFilePath .\SheetExport.csv

    Exports the Drive file as a CSV to the current working directory
    #>
    [CmdLetBinding(DefaultParameterSetName = "Depth")]
    Param
    (
        [parameter(Mandatory = $true,Position = 0)]
        [String]
        $FileID,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [Alias('Owner','PrimaryEmail','UserKey','Mail')]
        [string]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $true)]
        [ValidateSet("CSV","EPUB","HTML","HTMLZipped","JPEG","JSON","MSExcel","MSPowerPoint","MSWordDoc","OpenOfficeDoc","OpenOfficePresentation","OpenOfficeSheet","PDF","PlainText","PNG","RichText","SVG","TSV")]
        [String]
        $Type,
        [parameter(Mandatory = $false)]
        [String]
        $OutFilePath,
        [parameter(Mandatory = $false,ParameterSetName = "Depth")]
        [Alias('Depth')]
        [ValidateSet("Minimal","Standard","Full","Access")]
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
        $mimeHash = @{
            CSV                    = "text/csv"
            EPUB                   = "application/epub+zip"
            HTML                   = "text/html"
            HTMLZipped             = "application/zip"
            JPEG                   = "image/jpeg"
            JSON                   = "application/vnd.google-apps.script+json"
            MSExcel                = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
            MSPowerPoint           = "application/vnd.openxmlformats-officedocument.presentationml.presentation"
            MSWordDoc              = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
            OpenOfficeDoc          = "application/vnd.oasis.opendocument.text"
            OpenOfficePresentation = "application/vnd.oasis.opendocument.presentation"
            OpenOfficeSheet        = "application/x-vnd.oasis.opendocument.spreadsheet"
            PDF                    = "application/pdf"
            PlainText              = "text/plain"
            PNG                    = "image/png"
            RichText               = "application/rtf"
            SVG                    = "image/svg+xml"
            TSV                    = "text/tab-separated-values"
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
            $request = $service.Files.Export($FileID,($mimeHash[$Type]))
            if ($fs) {
                $request.Fields = $($fs -join ",")
            }
            if ($OutFilePath) {
                if ((Test-Path $OutFilePath) -and !$Force) {
                    throw "File '$OutFilePath' already exists. If you would like to overwrite it, use the -Force parameter."
                }
                else {
                    Write-Verbose "Saving file to path '$OutFilePath'"
                    $stream = [System.IO.File]::Create($OutFilePath)
                    $request.Download($stream)
                    $stream.Close()
                }
            }
            else {
                Write-Verbose "Getting content of File '$FileID' as Type '$Type'"
                $request.Execute()
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
