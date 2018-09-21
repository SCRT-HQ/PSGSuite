function Add-GSCourseMaterialYouTubeVideo {
    <#
    .SYNOPSIS
    YouTube video item

    .DESCRIPTION
    YouTube video item

    .PARAMETER Id
    YouTube API resource ID.

    .EXAMPLE
    Add-GSCourseMaterialYouTubeVideo -Id sZDPth5zf1Q
    #>
    Param (
        [parameter(Mandatory = $true)]
        [String]
        $Id
    )
    New-Object 'Google.Apis.Classroom.v1.Data.CourseMaterial' -Property @{
        YouTubeVideo = New-Object 'Google.Apis.Classroom.v1.Data.YouTubeVideo' -Property @{
            Id = $Id
        }
    }
}
