function Remove-GSStudentGuardian {
    <#
    .SYNOPSIS
    Removes a guardian.

    .DESCRIPTION
    Removes a guardian.

    .PARAMETER StudentId
    The identifier of the student to get guardian info for. The identifier can be one of the following:

    * the numeric identifier for the user
    * the email address of the user
    * the string literal "me", indicating the requesting user

    .PARAMETER GuardianId
    The id field from a Guardian.

    .PARAMETER User
    The user to authenticate the request as

    .EXAMPLE
    Remove-GSStudentGuardian -StudentId aristotle@athens.edu -GuardianId $guardianId

    Removes the guardian for artistotle@athens.edu.
    #>
    [cmdletbinding(SupportsShouldProcess = $true,ConfirmImpact = "High")]
    Param
    (
        [parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias('Student')]
        [String]
        $StudentId,
        [parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias('Guardian')]
        [String]
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
        try {
            if ( -not ($StudentId -as [decimal])) {
                if ($StudentId -ceq 'me') {
                    $StudentId = $Script:PSGSuite.AdminEmail
                }
                elseif ($StudentId -notlike "*@*.*") {
                    $StudentId = "$($StudentId)@$($Script:PSGSuite.Domain)"
                }
            }
            if ($PSCmdlet.ShouldProcess("Removing Guardian '$GuardianId' from Student '$StudentId'")) {
                Write-Verbose "Removing Guardian '$GuardianId' from Student '$StudentId'"
                $request = $service.UserProfiles.Guardians.Delete($StudentId,$GuardianId)
                $request.Execute()
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
