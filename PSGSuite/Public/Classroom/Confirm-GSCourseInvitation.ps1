function Confirm-GSCourseInvitation {
    <#
    .SYNOPSIS
    Accepts an invitation, removing it and adding the invited user to the teachers or students (as appropriate) of the specified course. Only the invited user may accept an invitation.

    .DESCRIPTION
    Accepts an invitation, removing it and adding the invited user to the teachers or students (as appropriate) of the specified course. Only the invited user may accept an invitation.

    .PARAMETER Id
    Identifier of the invitation to accept.

    .PARAMETER User
    Email or email name part of the invited user.

    .EXAMPLE
    Confirm-GSCourseInvitation -Id $inviteId -User aristotle@athens.edu
    #>
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true)]
        [String]
        $Id,
        [parameter(Mandatory = $true)]
        [String]
        $User
    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/classroom.rosters'
            ServiceType = 'Google.Apis.Classroom.v1.ClassroomService'
            User        = $User
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        try {
            if ($User -ceq 'me') {
                $User = $Script:PSGSuite.AdminEmail
            }
            elseif ($User -notlike "*@*.*") {
                $User = "$($User)@$($Script:PSGSuite.Domain)"
            }
            Write-Verbose "Accepting Invitation '$Id' for user '$User'"
            $request = $service.Invitations.Accept($Id)
            $request.Execute()
            Write-Verbose "The Invitation has been successfully accepted for user '$User'"
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
