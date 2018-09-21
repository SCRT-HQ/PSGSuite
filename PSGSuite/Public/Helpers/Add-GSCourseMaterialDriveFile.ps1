function Add-GSCourseMaterialDriveFile {
    <#
    .SYNOPSIS
    Representation of a Google Drive file.

    .DESCRIPTION
    Representation of a Google Drive file.

    .PARAMETER Id
    Drive API resource ID.

    .EXAMPLE
    Add-GSCourseMaterialDriveFile -Id $driveFileId
    #>
    Param (
        [parameter(Mandatory = $true)]
        [String]
        $Id
    )
    New-Object 'Google.Apis.Classroom.v1.Data.CourseMaterial' -Property @{
        DriveFile = New-Object 'Google.Apis.Classroom.v1.Data.DriveFile' -Property @{
            Id = $Id
        }
    }
}
