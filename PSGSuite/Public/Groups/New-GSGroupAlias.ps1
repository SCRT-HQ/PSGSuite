function New-GSGroupAlias {
    <#
    .SYNOPSIS
    Creates a new alias for a G Suite group

    .DESCRIPTION
    Creates a new alias for a G Suite group

    .PARAMETER Group
    The group to create the alias for

    .PARAMETER Alias
    The alias or list of aliases to create for the group

    .EXAMPLE
    New-GSGroupAlias -Group humanresources@domain.com -Alias 'hr@domain.com','hrhelp@domain.com'

    Creates 2 new aliases for group Human Resources as 'hr@domain.com' and 'hrhelp@domain.com'
    #>
    [OutputType('Google.Apis.Admin.Directory.directory_v1.Data.Alias')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias("Email")]
        [ValidateNotNullOrEmpty()]
        [String]
        $Group,
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
        foreach ($A in $Alias) {
            try {
                if ($Group -notlike "*@*.*") {
                    $Group = "$($Group)@$($Script:PSGSuite.Domain)"
                }
                if ($A -notlike "*@*.*") {
                    $A = "$($A)@$($Script:PSGSuite.Domain)"
                }
                Write-Verbose "Creating alias '$A' for Group '$Group'"
                $body = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.Alias'
                $body.AliasValue = $A
                $request = $service.Groups.Aliases.Insert($body,$Group)
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
