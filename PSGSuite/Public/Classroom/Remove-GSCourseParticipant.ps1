function Remove-GSCourseParticipant {
    <#
    .SYNOPSIS
    Removes students and/or teachers from a course

    .DESCRIPTION
    Removes students and/or teachers from a course

    .PARAMETER CourseId
    Identifier of the course to remove participants from. This identifier can be either the Classroom-assigned identifier or an alias.

    .PARAMETER Student
    Identifier of the user.

    This identifier can be one of the following:

    * the numeric identifier for the user
    * the email address of the user
    * the string literal "me", indicating the requesting user

    .PARAMETER Teacher
    Identifier of the user.

    This identifier can be one of the following:

    * the numeric identifier for the user
    * the email address of the user
    * the string literal "me", indicating the requesting user

    .PARAMETER User
    The user to authenticate the request as

    .EXAMPLE
    Remove-GSCourseParticipant -CourseId 'architecture-101' -Student plato@athens.edu,aristotle@athens.edu -Teacher zeus@athens.edu
    #>
    [cmdletbinding(SupportsShouldProcess = $true,ConfirmImpact = "High")]
    Param
    (
        [parameter(Mandatory = $true,Position = 0)]
        [String]
        $CourseId,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [Alias('PrimaryEmail','Email','Mail')]
        [String[]]
        $Student,
        [parameter(Mandatory = $false)]
        [String[]]
        $Teacher,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [String]
        $User = $Script:PSGSuite.AdminEmail
    )
    Process {
        if ($User -ceq 'me') {
            $User = $Script:PSGSuite.AdminEmail
        }
        elseif ($User -notlike "*@*.*") {
            $User = "$($User)@$($Script:PSGSuite.Domain)"
        }
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/classroom.rosters'
            ServiceType = 'Google.Apis.Classroom.v1.ClassroomService'
            User        = $User
        }
        $service = New-GoogleService @serviceParams
        foreach ($part in $Student) {
            try {
                if ( -not ($part -as [decimal])) {
                    if ($part -ceq 'me') {
                        $part = $Script:PSGSuite.AdminEmail
                    }
                    elseif ($part -notlike "*@*.*") {
                        $part = "$($part)@$($Script:PSGSuite.Domain)"
                    }
                }
                if ($PSCmdlet.ShouldProcess("Removing Student '$part' from Course '$CourseId'")) {
                    Write-Verbose "Removing Student '$part' from Course '$CourseId'"
                    $request = $service.Courses.Students.Delete($CourseId,$part)
                    $request.Execute()
                    Write-Verbose "Student '$part' has successfully been removed from Course '$CourseId'"
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
        foreach ($part in $Teacher) {
            try {
                try {
                    [decimal]$part | Out-Null
                }
                catch {
                    if ($part -ceq 'me') {
                        $part = $Script:PSGSuite.AdminEmail
                    }
                    elseif ($part -notlike "*@*.*") {
                        $part = "$($part)@$($Script:PSGSuite.Domain)"
                    }
                }
                if ($PSCmdlet.ShouldProcess("Removing Teacher '$part' from Course '$CourseId'")) {
                    Write-Verbose "Removing Teacher '$part' from Course '$CourseId'"
                    $request = $service.Courses.Teachers.Delete($CourseId,$part)
                    $request.Execute()
                    Write-Verbose "Teacher '$part' has successfully been removed from Course '$CourseId'"
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
}
