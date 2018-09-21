function Add-GSCourseMaterialForm {
    <#
    .SYNOPSIS
    Google Forms item.

    .DESCRIPTION
    Google Forms item.

    .PARAMETER FormUrl
    URL of the form.

    .EXAMPLE
    Add-GSCourseMaterialForm -FormUrl $formUrl
    #>
    Param (
        [parameter(Mandatory = $true)]
        [String]
        $FormUrl
    )
    New-Object 'Google.Apis.Classroom.v1.Data.CourseMaterial' -Property @{
        Form = New-Object 'Google.Apis.Classroom.v1.Data.Form' -Property @{
            FormUrl = $FormUrl
        }
    }
}
