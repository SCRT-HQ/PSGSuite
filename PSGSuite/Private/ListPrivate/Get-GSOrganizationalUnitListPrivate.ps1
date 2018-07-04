function Get-GSOrganizationalUnitListPrivate {
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false,Position = 0)]
        [Alias('OrgUnitPath','BaseOrgUnitPath')]
        [String]
        $SearchBase,
        [parameter(Mandatory = $false)]
        [Alias('Type')]
        [ValidateSet('Subtree','OneLevel','All','Children')]
        [String]
        $SearchScope = 'All',
        [parameter(Mandatory = $false)]
        [Alias('Profile','ProfileName')]
        [String]
        $ConfigName
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
            Write-Verbose "Getting all Organizational Units"
            $request = $service.Orgunits.List($Script:PSGSuite.CustomerId)
            $request.Type = switch ($SearchScope) {
                Subtree {
                    'All'
                }
                OneLevel {
                    'Children'
                }
                default {
                    $SearchScope
                }
            }
            if ($SearchBase) {
                $request.OrgUnitPath = $SearchBase
            }
            $request.Execute() | Select-Object -ExpandProperty OrganizationUnits
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