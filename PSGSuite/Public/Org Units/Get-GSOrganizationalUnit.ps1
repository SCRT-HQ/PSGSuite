function Get-GSOrganizationalUnit {
    <#
    .SYNOPSIS
    Gets Organizational Unit information

    .DESCRIPTION
    Gets Organizational Unit information

    .PARAMETER SearchBase
    The OrgUnitPath you would like to search for. This can be the single OrgUnit to return or the top level of which to return children of

    .PARAMETER SearchScope
    The depth at which to return the list of OrgUnits children

    Available values are:
    * "Base": only return the OrgUnit specified in the SearchBase
    * "Subtree": return the full list of OrgUnits underneath the specified SearchBase
    * "OneLevel": return the SearchBase and the OrgUnit's directly underneath it
    * "All": same as Subtree
    * "Children": same as OneLevel

    Defaults to 'All'

    .EXAMPLE
    Get-GSOrganizationalUnit -SearchBase "/" -SearchScope Base

    Gets the top level Organizational Unit information
    #>
    [OutputType('Google.Apis.Admin.Directory.directory_v1.Data.OrgUnit')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false,Position = 0)]
        [Alias('OrgUnitPath','BaseOrgUnitPath')]
        [String]
        $SearchBase,
        [parameter(Mandatory = $false)]
        [Alias('Type')]
        [ValidateSet('Base','Subtree','OneLevel','All','Children')]
        [String]
        $SearchScope = 'All'
    )
    Process {
        if ($PSBoundParameters.Keys -contains 'SearchBase' -and $SearchBase -ne "/" -and $SearchScope -eq 'Base') {
            $serviceParams = @{
                Scope       = 'https://www.googleapis.com/auth/admin.directory.orgunit'
                ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
            }
            $service = New-GoogleService @serviceParams
        }
        try {
            if ($PSBoundParameters.Keys -contains 'SearchBase' -and $SearchBase -ne "/" -and $SearchScope -eq 'Base') {
                foreach ($O in $SearchBase) {
                    Write-Verbose "Getting Organizational Unit '$O'"
                    $O = $O.TrimStart('/')
                    $request = $service.Orgunits.Get($Script:PSGSuite.CustomerId,([Google.Apis.Util.Repeatable[String]]::new([String[]]$O)))
                    $request.Execute()
                }
            }
            elseif ($SearchBase -eq "/" -and $SearchScope -eq 'Base') {
                $topId = Get-GSOrganizationalUnitListPrivate -SearchBase "/" -Type Children -Verbose:$false | Where-Object {$_.ParentOrgUnitPath -eq "/"} | Select-Object -ExpandProperty ParentOrgUnitId -Unique
                Get-GSOrganizationalUnit -OrgUnitPath $topId -SearchScope Base
            }
            else {
                Get-GSOrganizationalUnitListPrivate @PSBoundParameters
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
