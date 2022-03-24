function Get-GSDomain {
    <#
    .SYNOPSIS
    Retrieves a Domain

    .DESCRIPTION
    Retrieves a Domain

    .PARAMETER DomainName
    Name of the domain to retrieve.

    If excluded, returns the list of domains.

    .EXAMPLE
    Get-GSDDomain

    Returns the list of domains.
    #>
    [OutputType('Google.Apis.Admin.Directory.directory_v1.Data.Domains')]
    [CmdletBinding()]
    Param(
        [Parameter(Position = 0,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [Alias('Domain')]
        [String[]]
        $DomainName
    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.domain'
            ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        if ($PSBoundParameters.ContainsKey('DomainName')) {
            foreach ($domain in $DomainName) {
                try {
                    Write-Verbose "Getting Domain '$domain'"
                    $request = $service.Domains.Get($Script:PSGSuite.CustomerId,$domain)
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
                Write-Verbose "Getting the list of Domains"
                $request = $service.Domains.List($Script:PSGSuite.CustomerId)
                $request.Execute().Domains
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
