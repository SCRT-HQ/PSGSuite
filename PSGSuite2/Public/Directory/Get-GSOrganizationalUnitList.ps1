function Get-GSOrganizationalUnitList {
    <#
    .Synopsis
    Gets the Organizational Unit list for a given account in Google Apps
    .DESCRIPTION
    Retrieves the full Organizational Unit list for the entire account. Allows filtering by OrgUnitPath (SearchBase) and Type (SearchScope)
    .EXAMPLE
    Get-GSGSOrganizationalUnitList -OrgUnitPath "/Users" -Type Children
    .EXAMPLE
    Get-GSGSOrganizationalUnitList
    #>
    [cmdletbinding()]
    [Alias('Get-GSOrgUnitList')]
    Param
    (
      
        [parameter(Mandatory = $false,Position = 0)]
        [Alias('SearchBase','BaseOrgUnitPath')]
        [String]
        $OrgUnitPath,
        [parameter(Mandatory = $false)]
        [Alias('SearchScope')]
        [ValidateSet('All','Children')]
        [String]
        $Type = 'All'
    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.orgunit'
            ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        try {
            Write-Verbose "Getting Organizational Units"
            $request = $service.Orgunits.List($Script:PSGSuite.CustomerId)
            $request.Type = $Type
            if ($OrgUnitPath) {
                $request.OrgUnitPath = $OrgUnitPath
            }
            $request.Execute() | Select-Object -ExpandProperty OrganizationUnits
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}