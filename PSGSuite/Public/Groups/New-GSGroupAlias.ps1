function New-GSGroupAlias {
    <#
    .SYNOPSIS
    Creates a new alias for a G Suite group

    .DESCRIPTION
    Creates a new alias for a G Suite group

    .PARAMETER Identity
    The group to create the alias for

    .PARAMETER Alias
    The alias or list of aliases to create for the group

    .EXAMPLE
    New-GSGroupAlias -Identity humanresources@domain.com -Alias 'hr@domain.com','hrhelp@domain.com'

    Creates 2 new aliases for group Human Resources as 'hr@domain.com' and 'hrhelp@domain.com'
    #>
    [OutputType('Google.Apis.Admin.Directory.directory_v1.Data.Alias')]
    [cmdletbinding()]
    Param (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias('GroupEmail','Group','Email')]
        [String]
        $Identity,
        [parameter(Mandatory = $true,Position = 1)]
        [String[]]
        $Alias
    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.group'
            ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        Resolve-Email ([ref]$Identity) -IsGroup
        foreach ($A in $Alias) {
            try {
                Resolve-Email ([ref]$A)
                Write-Verbose "Creating alias '$A' for Group '$Identity'"
                $body = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.Alias'
                $body.AliasValue = $A
                $request = $service.Groups.Aliases.Insert($body,$Identity)
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
}
