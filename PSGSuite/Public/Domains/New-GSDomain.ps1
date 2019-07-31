function New-GSDomain {
    <#
    .SYNOPSIS
    Adds a new Domain

    .DESCRIPTION
    Adds a new Domain

    .PARAMETER DomainName
    Name of the domain to add.

    .EXAMPLE
    New-GSDDomain -DomainName 'testing.com'

    Adds a new domain named 'testing.com'
    #>
    [OutputType('Google.Apis.Admin.Directory.directory_v1.Data.Domains')]
    [CmdletBinding()]
    Param(
        [Parameter(Position = 0,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [Alias('Domain')]
        [String]
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
        try {
            Write-Verbose "Adding Domain '$DomainName'"
            $body = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.Domains' -Property @{
                DomainName = $DomainName
            }
            $request = $service.Domains.Insert($body,$Script:PSGSuite.CustomerId)
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
