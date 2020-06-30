function Get-GSCourse {
    <#
    .SYNOPSIS
    Gets a classroom course or list of courses

    .DESCRIPTION
    Gets a classroom course or list of courses

    .PARAMETER Id
    Identifier of the course to return. This identifier can be either the Classroom-assigned identifier or an alias.

    If excluded, returns the list of courses.

    .PARAMETER Teacher
    Restricts returned courses to those having a teacher with the specified identifier. The identifier can be one of the following:

    * the numeric identifier for the user
    * the email address of the user
    * the string literal "me", indicating the requesting user

    .PARAMETER Student
    Restricts returned courses to those having a student with the specified identifier. The identifier can be one of the following:

    * the numeric identifier for the user
    * the email address of the user
    * the string literal "me", indicating the requesting user

    .PARAMETER CourseStates
    Restricts returned courses to those in one of the specified states.

    .PARAMETER User
    The user to authenticate the request as

    .EXAMPLE
    Get-GSCourse -Teacher aristotle@athens.edu
    #>
    [OutputType('Google.Apis.Classroom.v1.Data.Course')]
    [cmdletbinding(DefaultParameterSetName = "List")]
    Param
    (
        [parameter(Mandatory = $false,Position = 0,ParameterSetName = "Get")]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Id,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [String]
        $Teacher,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [String]
        $Student,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [Google.Apis.Classroom.v1.CoursesResource+ListRequest+CourseStatesEnum[]]
        $CourseStates,
        [parameter(Mandatory = $false)]
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
            Scope       = 'https://www.googleapis.com/auth/classroom.courses'
            ServiceType = 'Google.Apis.Classroom.v1.ClassroomService'
            User        = $User
        }
        $service = New-GoogleService @serviceParams
        if ($PSBoundParameters.Keys -contains 'Id') {
            foreach ($I in $Id) {
                try {
                    Write-Verbose "Getting Course '$Id'"
                    $request = $service.Courses.Get($Id)
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
        else {
            try {
                Write-Verbose "Getting Course List"
                $request = $service.Courses.List()
                foreach ($s in $CourseStates) {
                    $request.CourseStates += $s
                }
                if ($PSBoundParameters.Keys -contains 'Student') {
                    $request.StudentId = $PSBoundParameters['Student']
                }
                if ($PSBoundParameters.Keys -contains 'Teacher') {
                    $request.TeacherId = $PSBoundParameters['Teacher']
                }
                [int]$i = 1
                do {
                    $result = $request.Execute()
                    if ($null -ne $result.Courses) {
                        $result.Courses
                    }
                    $request.PageToken = $result.NextPageToken
                    [int]$retrieved = ($i + $result.Courses.Count) - 1
                    Write-Verbose "Retrieved $retrieved Courses..."
                    [int]$i = $i + $result.Courses.Count
                }
                until (!$result.NextPageToken)
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
