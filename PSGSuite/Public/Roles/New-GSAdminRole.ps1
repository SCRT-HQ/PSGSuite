function New-GSAdminRole {
    <#
    .SYNOPSIS
    Creates a new Admin Role
    
    .DESCRIPTION
    Creates a new Admin Role
    
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
        [parameter(Mandatory = $true,Position = 0)]
        [String]
        $RoleName,
        [parameter(Mandatory = $true,Position = 1,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [Google.Apis.Admin.Directory.directory_v1.Data.Role+RolePrivilegesData[]]
        $RolePrivileges,
        [parameter(Mandatory = $false)]
        [String]
        $RoleDescription
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
        $privArray = New-Object 'System.Collections.Generic.List[Google.Apis.Admin.Directory.directory_v1.Data.Role+RolePrivilegesData]'
    }
    Process {
        foreach ($Privilege in $RolePrivileges) {
            $privArray.Add($Privilege)
        }
    }
    End {
        try {
            $body = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.Role'
            foreach ($prop in $PSBoundParameters.Keys | Where-Object {$body.PSObject.Properties.Name -contains $_}) {
                switch ($prop) {
                    RolePrivileges {
                        $body.RolePrivileges = $privArray
                    }
                    Default {
                        $body.$prop = $PSBoundParameters[$prop]
                    }
                }
            }
            Write-Verbose "Creating Admin Role '$RoleName' with the following privileges:`n`t- $($privArray.PrivilegeName -join "`n`t- ")"
            $request = $service.Roles.Insert($body,$customerId)
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