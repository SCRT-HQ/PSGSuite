function Get-GSDomainAlias {
    <#
    .SYNOPSIS
    Retrieves a Domain Alias

    .DESCRIPTION
    Retrieves a Domain Alias

    .PARAMETER DomainAliasName
    Name of the domain alias to retrieve.

    If excluded, returns the list of domain aliases.

    .PARAMETER ParentDomainName
    Name of the parent domain to list aliases for.

    If excluded, lists all aliases for all domains.

    .EXAMPLE
    Get-GSDDomainAlias

    Returns the list of domain aliases for all domains.
    #>
    [OutputType('Google.Apis.Admin.Directory.directory_v1.Data.DomainAlias')]
    [CmdletBinding(DefaultParameterSetName = "List")]
    Param(
        [Parameter(Position = 0,ValueFromPipeline,ValueFromPipelineByPropertyName,ParameterSetName = "Get")]
        [Alias('DomainAlias')]
        [String[]]
        $DomainAliasName,
        [Parameter(Position = 0,ValueFromPipeline,ValueFromPipelineByPropertyName,ParameterSetName = "List")]
        [String[]]
        $ParentDomainName
    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.domain'
            ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        if ($PSBoundParameters.ContainsKey('DomainAliasName')) {
            foreach ($alias in $DomainAliasName) {
                try {
                    Write-Verbose "Getting DomainAlias '$alias'"
                    $request = $service.DomainAliases.Get($Script:PSGSuite.CustomerId,$alias)
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
        else {
            try {
                $request = $service.DomainAliases.List($Script:PSGSuite.CustomerId)
                if ($PSBoundParameters.ContainsKey('ParentDomainName')) {
                    foreach ($pDom in $ParentDomainName) {
                        Write-Verbose "Getting the list of all DomainAliases under parent domain '$pDom'"
                        $request.ParentDomainName = $pDom
                        $request.Execute().DomainAliasesValue
                    }
                }
                else {
                    Write-Verbose "Getting the list of all DomainAliases"
                    $request.Execute().DomainAliasesValue
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
