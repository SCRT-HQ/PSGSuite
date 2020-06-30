function Remove-GSAdminRoleAssignment {
    <#
    .SYNOPSIS
    Removes a specific Admin Role Assignment or the list of Admin Role Assignments

    .DESCRIPTION
    Removes a specific Admin Role Assignment or the list of Admin Role Assignments

    .PARAMETER RoleAssignmentId
    The RoleAssignmentId(s) you would like to remove

    .EXAMPLE
    Remove-GSAdminRoleAssignment -RoleAssignmentId 9191482342768644,9191482342768642

    Removes the role assignments matching the provided Ids
    #>
    [cmdletbinding(SupportsShouldProcess = $true,ConfirmImpact = "High")]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [String[]]
        $RoleAssignmentId
    )
    Process {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.rolemanagement'
            ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        }
        $service = New-GoogleService @serviceParams
        $customerId = if ($Script:PSGSuite.CustomerID) {
            $Script:PSGSuite.CustomerID
        }
        else {
            'my_customer'
        }
        foreach ($Role in $RoleAssignmentId) {
            try {
                if ($PSCmdlet.ShouldProcess("Deleting Role Assignment Id '$Role'")) {
                    Write-Verbose "Deleting Role Assignment Id '$Role'"
                    $request = $service.RoleAssignments.Delete($customerId,$Role)
                    $request.Execute()
                    Write-Verbose "Role Assignment Id '$Role' has been successfully deleted"
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
