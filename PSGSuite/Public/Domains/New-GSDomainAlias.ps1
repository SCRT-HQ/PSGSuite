function New-GSDomainAlias {
    <#
    .SYNOPSIS
    Adds a new Domain Alias

    .DESCRIPTION
    Adds a new Domain Alias

    .PARAMETER DomainAliasName
    Name of the domain alias to add.

    .PARAMETER ParentDomainName
    Name of the parent domain to add the alias for.

    .EXAMPLE
    New-GSDDomainAlias -DomainAliasName 'testingalias.com' -ParentDomainName 'testing.com'

    Adds a new domain alias named 'testingalias.com' to parent domain 'testing.com'
    #>
    [OutputType('Google.Apis.Admin.Directory.directory_v1.Data.DomainAlias')]
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory,Position = 0,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [Alias('DomainAlias')]
        [String]
        $DomainAliasName,
        [Parameter(Mandatory,Position = 1,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [String]
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
        try {
            Write-Verbose "Adding DomainAlias '$DomainAliasName' to domain '$ParentDomainName'"
            $body = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.DomainAlias' -Property @{
                DomainAliasName = $DomainAliasName
                ParentDomainName = $ParentDomainName
            }
            $request = $service.DomainAliases.Insert($body,$Script:PSGSuite.CustomerId)
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
