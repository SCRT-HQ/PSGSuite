function Add-GSCourseMaterialLink {
    <#
    .SYNOPSIS
    URL item.

    .DESCRIPTION
    URL item.

    .PARAMETER Url
    URL to link to. This must be a valid UTF-8 string containing between 1 and 2024 characters.

    .EXAMPLE
    Add-GSCourseMaterialLink -Url 'https://google.com'
    #>
    Param (
        [parameter(Mandatory = $true)]
        [ValidateLength(1,2024)]
        [String]
        $Url
    )
    New-Object 'Google.Apis.Classroom.v1.Data.CourseMaterial' -Property @{
        Link = New-Object 'Google.Apis.Classroom.v1.Data.Link' -Property @{
            Url = $Url
        }
    }
}
