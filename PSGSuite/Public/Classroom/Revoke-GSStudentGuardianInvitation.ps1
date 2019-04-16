function Revoke-GSStudentGuardianInvitation {
    <#
    .SYNOPSIS
    Revokes a student guardian invitation.

    .DESCRIPTION
    Revokes a student guardian invitation.

    This method returns the following error codes:

    * PERMISSION_DENIED if the current user does not have permission to manage guardians, if guardians are not enabled for the domain in question or for other access errors.
    * FAILED_PRECONDITION if the guardian link is not in the PENDING state.
    * INVALID_ARGUMENT if the format of the student ID provided cannot be recognized (it is not an email address, nor a user_id from this API), or if the passed GuardianInvitation has a state other than COMPLETE, or if it modifies fields other than state.
    * NOT_FOUND if the student ID provided is a valid student ID, but Classroom has no record of that student, or if the id field does not refer to a guardian invitation known to Classroom.

    .PARAMETER StudentId
    The ID of the student whose guardian invitation is to be revoked. The identifier can be one of the following:

    * the numeric identifier for the user
    * the email address of the user

    .PARAMETER InvitationId
    The id field of the GuardianInvitation to be revoked.

    .PARAMETER User
    The user to authenticate the request as

    .EXAMPLE
    Revoke-GSStudentGuardianInvitation -StudentId aristotle@athens.edu -InvitationId $invitationId

    .EXAMPLE
    Import-Csv .\Student_Guardian_List_To_Revoke.csv | Revoke-GSStudentGuardianInvitation

    Process a CSV with two columns containing headers "Student" and "Guardian" and revokes the invites accordingly, i.e.

    |      StudentId       |    InvitationId    |
    |:--------------------:|:------------------:|
    | aristotle@athens.edu | 198okj4k9827872177 |
    | plato@athens.edu     | 09120uuip21ru0ff0u |
    #>
    [OutputType('Google.Apis.Classroom.v1.Data.GuardianInvitation')]
    [cmdletbinding(SupportsShouldProcess = $true,ConfirmImpact = "High")]
    Param
    (
        [parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias('Student')]
        [String]
        $StudentId,
        [parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias('Invitation','InviteId','Invite')]
        [String[]]
        $InvitationId,
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
        if ( -not ($StudentId -as [decimal])) {
            if ($StudentId -ceq 'me') {
                $StudentId = $Script:PSGSuite.AdminEmail
            }
            elseif ($StudentId -notlike "*@*.*") {
                $StudentId = "$($StudentId)@$($Script:PSGSuite.Domain)"
            }
        }
        foreach ($invId in $InvitationId) {
            try {
                if ($PSCmdlet.ShouldProcess("Revoking Guardian Invitation '$invId' for Student '$StudentId'")) {
                    Write-Verbose "Revoking Guardian Invitation '$invId' for Student '$StudentId'"
                    $body = New-Object 'Google.Apis.Classroom.v1.Data.GuardianInvitation' -Property @{
                        State = "COMPLETE"
                    }
                    $request = $service.UserProfiles.GuardianInvitations.Patch($body,$StudentId,$invId)
                    $request.UpdateMask = "state"
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
}
