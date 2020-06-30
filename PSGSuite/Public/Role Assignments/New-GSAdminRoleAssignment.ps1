function New-GSAdminRoleAssignment {
    <#
    .SYNOPSIS
    Creates a new Admin Role Assignment

    .DESCRIPTION
    Creates a new Admin Role Assignment

    .PARAMETER AssignedTo
    The unique ID of the user this role is assigned to.

    .PARAMETER RoleId
    The ID of the role that is assigned.

    .PARAMETER OrgUnitId
    If the role is restricted to an organization unit, this contains the ID for the organization unit the exercise of this role is restricted to.

    .PARAMETER ScopeType
    The scope in which this role is assigned.

    Acceptable values are:
    * "CUSTOMER"
    * "ORG_UNIT"

    .EXAMPLE
    New-GSAdminRoleAssignment -AssignedTo jsmith -RoleId 9191482342768644

    Assign a new role to a given user.
    #>
    [OutputType('Google.Apis.Admin.Directory.directory_v1.Data.RoleAssignment')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true, Position = 0)]
        [String[]]
        $AssignedTo,
        [parameter(Mandatory = $true)]
        [Int64]
        $RoleId,
        [parameter(Mandatory = $false)]
        [String]
        $OrgUnitId,
        [parameter(Mandatory = $false)]
        [ValidateSet('CUSTOMER', 'ORG_UNIT')]
        [String]
        $ScopeType = 'CUSTOMER'
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
        foreach ($Assigned in $AssignedTo) {
            try {
                $uKey = try {
                    [int64]$Assigned
                }
                catch {
                    if ($Assigned -ceq 'me') {
                        $Assigned = $Script:PSGSuite.AdminEmail
                    }
                    elseif ($Assigned -notlike "*@*.*") {
                        $Assigned = "$($Assigned)@$($Script:PSGSuite.Domain)"
                    }
                    (Get-GSUser -User $Assigned -Verbose:$false).Id
                }
                $body = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.RoleAssignment'
                $body.ScopeType = $ScopeType
                foreach ($prop in $PSBoundParameters.Keys | Where-Object {$body.PSObject.Properties.Name -contains $_}) {
                    switch ($prop) {
                        AssignedTo {
                            $body.AssignedTo = $uKey
                        }
                        Default {
                            $body.$prop = $PSBoundParameters[$prop]
                        }
                    }
                }
                Write-Verbose "Creating Admin Role Assignment for user '$Assigned' for Role Id '$RoleId'"
                $request = $service.RoleAssignments.Insert($body, $customerId)
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
