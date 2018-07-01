function Update-GSAdminRole {
    <#
    .SYNOPSIS
    Update an Admin Role
    
    .DESCRIPTION
    Update an Admin Role

    .PARAMETER RoleId
    The Id of the role to update
    
    .PARAMETER RoleName
    The name of the role
    
    .PARAMETER RolePrivileges
    The set of privileges that are granted to this role.

    .PARAMETER RoleDescription
    A short description of the role.
    
    .EXAMPLE
    Update-GSAdminRole -RoleId 9191482342768644 -RoleName 'Help_Desk_Level2' -RoleDescription 'Help Desk Level 2'

    Updates the specified Admin Role with a new name and description
    
    .EXAMPLE
    Get-GSAdminRole | Where-Object {$_.RoleDescription -like "*Help*Desk*"} | Update-GSAdminRole -RoleId 9191482342768644 -RoleName 'Help_Desk_Level2' -RoleDescription 'Help Desk Level 2'

    Updates the specified Admin Role's RolePrivileges to match every other Admin Role with Help Desk in the description. Useful for basing a new role off another to add additional permissions on there
    #>
    [cmdletbinding()]
    Param
    (
        
        [parameter(Mandatory = $true,Position = 0)]
        [int64]
        $RoleId,
        [parameter(Mandatory = $false)]
        [String]
        $RoleName,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
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
            foreach ($prop in $PSBoundParameters.Keys | Where-Object {$_ -ne 'RoleId' -and $body.PSObject.Properties.Name -contains $_}) {
                switch ($prop) {
                    RolePrivileges {
                        $body.RolePrivileges = $privArray
                    }
                    Default {
                        $body.$prop = $PSBoundParameters[$prop]
                    }
                }
            }
            Write-Verbose "Updating Admin Role '$RoleId'"
            $request = $service.Roles.Insert($body,$customerId,$RoleId)
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