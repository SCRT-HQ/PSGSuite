function New-GSAdminRoleAssignment {
    <#
    .SYNOPSIS
    Creates a new Admin Role Assignment

    .DESCRIPTION
    Creates a new Admin Role Assignment

    .PARAMETER RoleName
    The name of the new role

    .PARAMETER RolePrivileges
    The set of privileges that are granted to this role.

    .PARAMETER RoleDescription
    A short description of the role.

    .EXAMPLE
    Get-GSAdminRole

    Gets the list of Admin Roles

    .EXAMPLE
    Get-GSAdminRole -RoleId '9191482342768644','9191482342768642'

    Gets the admin roles matching the provided Ids
    #>
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
    Begin {
        if ($PSCmdlet.ParameterSetName -eq 'Get') {
            $serviceParams = @{
                Scope       = 'https://www.googleapis.com/auth/admin.directory.rolemanagement'
                ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
            }
            $service = New-GoogleService @serviceParams
        }
        $customerId = if ($Script:PSGSuite.CustomerID) {
            $Script:PSGSuite.CustomerID
        }
        else {
            'my_customer'
        }
    }
    Process {
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