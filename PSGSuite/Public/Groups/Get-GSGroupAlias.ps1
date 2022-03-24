function Get-GSGroupAlias {
    <#
    .SYNOPSIS
    Gets the specified G SUite Group's aliases

    .DESCRIPTION
    Gets the specified G SUite Group's aliases

    .PARAMETER Identity
    The primary email or ID of the group who you are trying to get aliases for. You can exclude the '@domain.com' to insert the Domain in the config or use the special 'me' to indicate the AdminEmail in the config.

    .EXAMPLE
    Get-GSGroupAlias -Identity hr

    Gets the list of aliases for the group hr@domain.com
    #>
    [OutputType('Google.Apis.Admin.Directory.directory_v1.Data.Alias')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias('GroupEmail','Group','Email')]
        [String[]]
        $Identity
    )
    Process {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.group'
            ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        }
        $service = New-GoogleService @serviceParams
        foreach ($G in $Identity) {
            try {
                Resolve-Email ([ref]$G) -IsGroup
                Write-Verbose "Getting Alias list for Group '$G'"
                $request = $service.Groups.Aliases.List($G)
                $request.Execute() | Select-Object -ExpandProperty AliasesValue
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
