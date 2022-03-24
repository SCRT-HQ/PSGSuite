function Get-GSStudentGuardian {
    <#
    .SYNOPSIS
    Gets a guardian or list of guardians for a student.

    .DESCRIPTION
    Gets a guardian or list of guardians for a student.

    .PARAMETER StudentId
    The identifier of the student to get guardian info for. The identifier can be one of the following:

    * the numeric identifier for the user
    * the email address of the user
    * the string literal "me", indicating the requesting user
    * the string literal "-", indicating that results should be returned for all students that the requesting user is permitted to view guardians for. [Default]
        * **This is only allowed when excluding the `GuardianId` parameter to perform a List request!**

    .PARAMETER GuardianId
    The id field from a Guardian.

    .PARAMETER User
    The user to authenticate the request as

    .EXAMPLE
    Get-GSStudentGuardian

    Gets the list of guardians for all students.
    #>
    [OutputType('Google.Apis.Classroom.v1.Data.Guardian')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [Alias('Student')]
        [String[]]
        $StudentId = "-",
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [Alias('Guardian')]
        [String[]]
        $GuardianId,
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
            Scope       = 'https://www.googleapis.com/auth/classroom.guardianlinks.students'
            ServiceType = 'Google.Apis.Classroom.v1.ClassroomService'
            User        = $User
        }
        $service = New-GoogleService @serviceParams
        foreach ($stuId in $StudentId) {
            try {
                if ($stuId -ne '-') {
                    if ( -not ($stuId -as [decimal])) {
                        if ($stuId -ceq 'me') {
                            $stuId = $Script:PSGSuite.AdminEmail
                        }
                        elseif ($stuId -notlike "*@*.*") {
                            $stuId = "$($stuId)@$($Script:PSGSuite.Domain)"
                        }
                    }
                }
                elseif ($PSBoundParameters.Keys -contains 'GuardianId') {
                    Write-Error "You must specify a valid StudentId when including a GuardianId! Current value '$stuId'"
                }
                if ($PSBoundParameters.Keys -contains 'GuardianId') {
                    foreach ($guard in $GuardianId) {
                        try {
                            Write-Verbose "Getting Guardian '$guard' for Student '$stuId'"
                            $request = $service.UserProfiles.Guardians.Get($stuId,$guard)
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
                        if ($stuId -eq '-') {
                            Write-Verbose "Listing all Guardians"
                        }
                        else {
                            Write-Verbose "Listing Guardians for Student '$stuId'"
                        }
                        $request = $service.UserProfiles.Guardians.List($stuId)
                        [int]$i = 1
                        do {
                            $result = $request.Execute()
                            if ($null -ne $result.Guardians) {
                                $result.Guardians
                            }
                            $request.PageToken = $result.NextPageToken
                            [int]$retrieved = ($i + $result.Guardians.Count) - 1
                            Write-Verbose "Retrieved $retrieved Guardians..."
                            [int]$i = $i + $result.Guardians.Count
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
