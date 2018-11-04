function Get-GSCourseParticipant {
    <#
    .SYNOPSIS
    Gets a course participant or list of participants (teachers/students)

    .DESCRIPTION
    Gets a course participant or list of participants (teachers/students)

    .PARAMETER CourseId
    Identifier of the course to get participants of. This identifier can be either the Classroom-assigned identifier or an alias.

    .PARAMETER Role
    The Role for which you would like to list participants for.

    Available values are:

    * Student
    * Teacher

    The default value for this parameter is @('Teacher','Student')

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

    .PARAMETER User
    The user to authenticate the request as

    .PARAMETER Fields
    The specific fields to fetch

    .EXAMPLE
    Get-GSCourseParticipant -Teacher aristotle@athens.edu
    #>
    [cmdletbinding(DefaultParameterSetName = "List")]
    Param
    (
        [parameter(Mandatory = $true,Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $CourseId,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [ValidateSet('Teacher','Student')]
        [String[]]
        $Role = @('Teacher','Student'),
        [parameter(Mandatory = $false,ParameterSetName = "Get")]
        [String[]]
        $Teacher,
        [parameter(Mandatory = $false,ParameterSetName = "Get")]
        [String[]]
        $Student,
        [parameter(Mandatory = $false)]
        [String]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false)]
        [String[]]
        $Fields = '*'
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
        switch ($PSCmdlet.ParameterSetName) {
            Get {
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
                        Write-Verbose "Getting Student '$part' for Course '$CourseId'"
                        $request = $service.Courses.Students.Get($CourseId,$part)
                        $request.Fields = "$($Fields -join ",")"
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
                        Write-Verbose "Getting Teacher '$part' for Course '$CourseId'"
                        $request = $service.Courses.Teachers.Get($CourseId,$part)
                        $request.Fields = "$($Fields -join ",")"
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
            List {
                foreach ($Ro in $Role) {
                    try {
                        Write-Verbose "Getting List of $($Ro)s for Course '$CourseId'"
                        $request = switch ($Ro) {
                            Teacher {
                                $service.Courses.Teachers.List($CourseId)
                            }
                            Student {
                                $service.Courses.Students.List($CourseId)
                            }
                        }
                        $request.Fields = "$($Fields -join ",")"
                        [int]$retrieved = 0
                        [int]$i = 1
                        do {
                            $result = $request.Execute()
                            switch ($Ro) {
                                Teacher {
                                    if ($null -ne $result.Teachers) {
                                        $result.Teachers
                                    }
                                    [int]$retrieved = ($i + $result.Teachers.Count) - 1
                                    [int]$i = $i + $result.Teachers.Count
                                }
                                Student {
                                    if ($null -ne $result.Students) {
                                        $result.Students
                                    }
                                    [int]$retrieved = ($i + $result.Students.Count) - 1
                                    [int]$i = $i + $result.Students.Count
                                }
                            }
                            $request.PageToken = $result.NextPageToken
                            Write-Verbose "Retrieved $retrieved $($Ro)s..."
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
    }
}
