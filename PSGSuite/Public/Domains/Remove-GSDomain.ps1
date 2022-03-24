function Remove-GSDomain {
    <#
    .SYNOPSIS
    Removes a Domain

    .DESCRIPTION
    Removes a Domain

    .PARAMETER DomainName
    Name of the domain to remove.

    .EXAMPLE
    Remove-GSDDomain 'testing.com'

    Removes the 'testing.com' domain from your account.
    #>
    [CmdletBinding(SupportsShouldProcess = $true,ConfirmImpact = "High")]
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
        foreach ($domain in $DomainName) {
            try {
                if ($PSCmdlet.ShouldProcess("Removing Domain '$domain'")) {
                    Write-Verbose "Removing Domain '$domain'"
                    $request = $service.Domains.Get($Script:PSGSuite.CustomerId,$domain)
                    $request.Execute()
                    Write-Verbose "Domain '$domain' removed successfully"
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
