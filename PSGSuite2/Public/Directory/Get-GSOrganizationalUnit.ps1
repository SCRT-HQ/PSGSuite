function Get-GSOrganizationalUnit {

    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false,Position = 0,ParameterSetName = "Get")]
        [Alias('OrgUnitPath','BaseOrgUnitPath')]
        [String]
        $SearchBase,
        [parameter(Mandatory = $false,ParameterSetName)]
        [Alias('SearchScope','Type')]
        [ValidateSet('Base','Subtree','OneLevel','All','Children')]
        [String]
        $SearchScope = 'All'
    )
    Begin {
        if ($PSBoundParameters.Keys -contains 'SearchBase' -and $SearchBase -ne "/" -and $SearchScope -eq 'Base') {
            $serviceParams = @{
                Scope       = 'https://www.googleapis.com/auth/admin.directory.orgunit'
                ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
            }
            $service = New-GoogleService @serviceParams
        }
    }
    Process {
        try {
            if ($PSBoundParameters.Keys -contains 'SearchBase' -and $SearchBase -ne "/" -and $SearchScope -eq 'Base') {
                foreach ($O in $SearchBase) {
                    Write-Verbose "Getting Organizational Unit '$O'"
                    $O = $O.TrimStart('/')
                    $request = $service.Orgunits.Get($Script:PSGSuite.CustomerId,([Google.Apis.Util.Repeatable[String]]::new([String[]]$O)))
                    $request.Execute()
                }
            }
            else {
                if ($SearchBase -eq "/" -and $SearchScope -eq 'Base') {
                    $topId = Get-GSOrganizationalUnitListPrivate -SearchBase "/" -Type Children -Verbose:$false | Where-Object {$_.ParentOrgUnitPath -eq "/"} | Select-Object -ExpandProperty ParentOrgUnitId -Unique
                    Get-GSOrganizationalUnit -OrgUnitPath $topId -SearchScope Base
                }
                else {
                    Get-GSOrganizationalUnitListPrivate @PSBoundParameters
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}