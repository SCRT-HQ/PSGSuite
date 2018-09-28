function Remove-GSCourseAlias {
    <#
    .SYNOPSIS
    Removes a course alias.

    .DESCRIPTION
    Removes a course alias.

    .PARAMETER Alias
    Alias string

    .PARAMETER CourseId
    Identifier of the course to alias. This identifier can be either the Classroom-assigned identifier or an alias.

    .EXAMPLE
    Remove-GSCourseAlias -Alias "d:abc123" -CourseId 'architecture-101'
    #>
    [cmdletbinding(SupportsShouldProcess = $true,ConfirmImpact = "High")]
    Param
    (
        [parameter(Mandatory = $true,Position = 0)]
        [String]
        $Alias,
        [parameter(Mandatory = $true,Position = 1)]
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
            if ($PSCmdlet.ShouldProcess("Removing Alias '$Alias' for Course '$CourseId'")) {
                Write-Verbose "Removing Alias '$Alias' for Course '$CourseId'"
                $request = $service.Courses.Aliases.Delete($CourseId,$Alias)
                $request.Execute()
                Write-Verbose "Alias '$Alias' for Course '$CourseId' has been successfully removed"
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
