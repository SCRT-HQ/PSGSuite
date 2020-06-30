function Remove-GSDomainAlias {
    <#
    .SYNOPSIS
    Removes a Domain Alias

    .DESCRIPTION
    Removes a Domain Alias

    .PARAMETER DomainAliasName
    Alias of the domain to remove.

    .EXAMPLE
    Remove-GSDDomainAlias 'testingalias.com'

    Removes the 'testingalias.com' domain alias from your account.
    #>
    [CmdletBinding(SupportsShouldProcess = $true,ConfirmImpact = "High")]
    Param(
        [Parameter(Position = 0,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [Alias('DomainAlias')]
        [String[]]
        $DomainAliasName
    )
    Process {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.domain'
            ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        }
        $service = New-GoogleService @serviceParams
        foreach ($alias in $DomainAliasName) {
            try {
                if ($PSCmdlet.ShouldProcess("Removing Domain Alias '$domain'")) {
                    Write-Verbose "Removing Domain Alias '$alias'"
                    $request = $service.DomainAliases.Delete($Script:PSGSuite.CustomerId,$alias)
                    $request.Execute()
                    Write-Verbose "Domain Alias '$alias' removed successfully"
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
