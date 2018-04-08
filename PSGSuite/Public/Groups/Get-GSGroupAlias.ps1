function Get-GSGroupAlias {
    <#
    .SYNOPSIS
    Gets the specified G SUite Group's aliases
    
    .DESCRIPTION
    Gets the specified G SUite Group's aliases
    
    .PARAMETER Group
    The primary email or ID of the group who you are trying to get aliases for. You can exclude the '@domain.com' to insert the Domain in the config or use the special 'me' to indicate the AdminEmail in the config.
    
    .EXAMPLE
    Get-GSGroupAlias -Group hr

    Gets the list of aliases for the group hr@domain.com
    #>
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias("Email")]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Group
    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.group'
            ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        foreach ($G in $Group) {
            try {
                if ($G -notlike "*@*.*") {
                    $G = "$($G)@$($Script:PSGSuite.Domain)"
                }
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