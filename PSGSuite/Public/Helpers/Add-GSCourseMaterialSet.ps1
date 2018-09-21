function Add-GSCourseMaterialSet {
    <#
    .SYNOPSIS
    Adds a Course Material Set for use when creating new Classroom Courses

    .DESCRIPTION
    Adds a Course Material Set for use when creating new Classroom Courses

    .PARAMETER Title
    Title for this set.

    .PARAMETER Materials
    Materials attached to this set.

    Use one of the following functions to create the appropriate types for this parameter:
    * Add-GSCourseMaterialDriveFile
    * Add-GSCourseMaterialForm
    * Add-GSCourseMaterialLink
    * Add-GSCourseMaterialYouTubeVideo

    .PARAMETER InputObject
    Used for pipeline input of an existing CourseMaterialSet objects to strip the extra attributes and prevent errors

    .EXAMPLE
    $youTube = Add-GSCourseMaterialYouTubeVideo -Id sZDPth5zf1Q
    Add-GSCourseMaterialSet -Title "YouTube Video" -Materials $youTube
    #>
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $false,ParameterSetName = "Fields")]
        [String]
        $Title,
        [Parameter(Mandatory = $false,ParameterSetName = "Fields")]
        [Google.Apis.Classroom.v1.Data.CourseMaterial[]]
        $Materials,
        [Parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Admin.Directory.directory_v1.Data.UserAddress[]]
        $InputObject
    )
    Begin {
        $propsToWatch = @(
            'Title'
            'Materials'
        )
    }
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Classroom.v1.Data.CourseMaterialSet'
                    foreach ($prop in $PSBoundParameters.Keys | Where-Object {$obj.PSObject.Properties.Name -contains $_}) {
                        switch ($prop) {
                            Materials {
                                $list = New-Object 'System.Collections.Generic.List[Google.Apis.Classroom.v1.Data.CourseMaterial]'
                                foreach ($item in $Materials) {
                                    $list.Add($item)
                                }
                                $obj.$prop = $list
                            }
                            default {
                                $obj.$prop = $PSBoundParameters[$prop]
                            }
                        }
                    }
                    $obj
                }
                InputObject {
                    foreach ($iObj in $InputObject) {
                        $obj = New-Object 'Google.Apis.Classroom.v1.Data.CourseMaterialSet'
                        foreach ($prop in $iObj.PSObject.Properties.Name | Where-Object {$obj.PSObject.Properties.Name -contains $_ -and $propsToWatch -contains $_}) {
                            $obj.$prop = $iObj.$prop
                        }
                        $obj
                    }
                }
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
