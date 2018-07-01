function Remove-GSAdminRole {
    <#
    .SYNOPSIS
    Removes a specific Admin Role or a list of Admin Roles
    
    .DESCRIPTION
    Removes a specific Admin Role or a list of Admin Roles
    
    .PARAMETER RoleId
    The RoleId(s) you would like to remove
    
    .EXAMPLE
    Remove-GSAdminRole -RoleId 9191482342768644,9191482342768642

    Removes the admin roles matching the provided Ids
    #>
    [cmdletbinding(SupportsShouldProcess = $true,ConfirmImpact = "High")]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [int64[]]
        $RoleId
    )
    Begin {
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
    }
    Process {
        foreach ($Role in $RoleId) {
            try {
                if ($PSCmdlet.ShouldProcess("Deleting Role Id '$Role'")) {
                    Write-Verbose "Deleting Role Id '$Role'"
                    $request = $service.Roles.Delete($customerId,$Role)
                    $request.Execute()
                    Write-Verbose "Role Id '$Role' has been successfully deleted"
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