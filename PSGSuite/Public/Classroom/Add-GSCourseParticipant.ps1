function Add-GSCourseParticipant {
    <#
    .SYNOPSIS
    Adds students and/or teachers to a course

    .DESCRIPTION
    Adds students and/or teachers to a course

    .PARAMETER CourseId
    Identifier of the course to add participants to. This identifier can be either the Classroom-assigned identifier or an alias.

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
    Add-GSCourseParticipant -CourseId 'architecture-101' -Student plato@athens.edu,aristotle@athens.edu -Teacher zeus@athens.edu
    #>
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [String]
        $CourseId,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [Alias('PrimaryEmail','Email','Mail')]
        [String[]]
        $Student,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [String[]]
        $Teacher,
        [parameter(Mandatory = $false)]
        [String]
        $User = $Script:PSGSuite.AdminEmail
    )
    Begin {
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
    }
    Process {
        foreach ($part in $Student | Where-Object {-not [String]::IsNullOrEmpty($_)}) {
            try {
                $body = New-Object 'Google.Apis.Classroom.v1.Data.Student'
                if ( -not ($part -as [decimal])) {
                    if ($part -ceq 'me') {
                        $part = $Script:PSGSuite.AdminEmail
                    }
                    elseif ($part -notlike "*@*.*") {
                        $part = "$($part)@$($Script:PSGSuite.Domain)"
                    }
                }
                $body.UserId = $part
                Write-Verbose "Adding Student '$part' to Course '$CourseId'"
                $request = $service.Courses.Students.Create($part,$CourseId)
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
        foreach ($part in $Teacher | Where-Object {-not [String]::IsNullOrEmpty($_)}) {
            try {
                $body = New-Object 'Google.Apis.Classroom.v1.Data.Teacher'
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
                $body.UserId = $part
                Write-Verbose "Adding Teacher '$part' to Course '$CourseId'"
                $request = $service.Courses.Teachers.Create($part,$CourseId)
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
}
