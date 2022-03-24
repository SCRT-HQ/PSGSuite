function Remove-GSGroupAlias {
    <#
    .SYNOPSIS
    Removes an alias from a G Suite group

    .DESCRIPTION
    Removes an alias from a G Suite group

    .PARAMETER Identity
    The group to remove the alias from

    .PARAMETER Alias
    The alias or list of aliases to remove from the group

    .EXAMPLE
    Remove-GSGroupAlias -Identity humanresources@domain.com -Alias 'hr@domain.com','hrhelp@domain.com'

    Removes 2 aliases for group Human Resources: 'hr@domain.com' and 'hrhelp@domain.com'
    #>
    [cmdletbinding(SupportsShouldProcess = $true,ConfirmImpact = "High")]
    Param (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias('GroupEmail','Group','Email')]
        [String]
        $Identity,
        [parameter(Mandatory = $true,Position = 1)]
        [String[]]
        $Alias
    )
    Process {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.group'
            ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        }
        $service = New-GoogleService @serviceParams
        Resolve-Email ([ref]$Identity) -IsGroup
        foreach ($A in $Alias) {
            try {
                Resolve-Email ([ref]$A)
                if ($PSCmdlet.ShouldProcess("Removing alias '$A' from Group '$Identity'")) {
                    Write-Verbose "Removing alias '$A' from Group '$Identity'"
                    $request = $service.Groups.Aliases.Delete($Identity,$A)
                    $request.Execute()
                    Write-Verbose "Alias '$A' has been successfully deleted from Group '$Identity'"
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
