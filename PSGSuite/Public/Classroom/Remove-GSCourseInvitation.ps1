function Remove-GSCourseInvitation {
    <#
    .SYNOPSIS
    Deletes an invitation.

    .DESCRIPTION
    Deletes an invitation.

    .PARAMETER Id
    Identifier of the invitation to delete.

    .EXAMPLE
    Remove-GSCourseInvitation -Id $inviteId -Confirm:$false
    #>
    [cmdletbinding(SupportsShouldProcess = $true,ConfirmImpact = "High")]
    Param
    (
        [parameter(Mandatory = $true,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [String[]]
        $Id
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
        foreach ($I in $Id) {
            try {
                if ($PSCmdlet.ShouldProcess("Removing Invitation '$I'")) {
                    Write-Verbose "Removing Invitation '$I'"
                    $request = $service.Invitations.Delete($I)
                    $request.Execute()
                    Write-Verbose "Invitation '$I' has been successfully removed"
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
