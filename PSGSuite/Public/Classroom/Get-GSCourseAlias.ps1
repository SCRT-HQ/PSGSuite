function Get-GSCourseAlias {
    <#
    .SYNOPSIS
    Gets the list of aliases for a course.

    .DESCRIPTION
    Gets the list of aliases for a course.

    .PARAMETER CourseId
    Identifier of the course to alias. This identifier can be either the Classroom-assigned identifier or an alias.

    .EXAMPLE
    Get-GSCourseAlias -CourseId 'architecture-101'
    #>
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0)]
        [String]
        $CourseId
    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/classroom.courses'
            ServiceType = 'Google.Apis.Classroom.v1.ClassroomService'
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        try {
            Write-Verbose "Getting Alias list for Course '$CourseId'"
            $request = $service.Courses.Aliases.List($CourseId)
            $request.Execute()
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
