function New-GSUserAlias {
    <#
    .SYNOPSIS
    Creates a new alias for a G Suite user
    
    .DESCRIPTION
    Creates a new alias for a G Suite user
    
    .PARAMETER User
    The user to create the alias for
    
    .PARAMETER Alias
    The alias or list of aliases to create for the user
    
    .EXAMPLE
    New-GSUserAlias -User john.smith@domain.com -Alias 'jsmith@domain.com','johns@domain.com'

    Creates 2 new aliases for user John Smith as 'jsmith@domain.com' and 'johns@domain.com'
    #>
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail","Email")]
        [ValidateNotNullOrEmpty()]
        [String]
        $User,
        [parameter(Mandatory = $true,Position = 1)]
        [String[]]
        $Alias
    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.user'
            ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        foreach ($A in $Alias) {
            try {
                if ($User -ceq 'me') {
                    $User = $Script:PSGSuite.AdminEmail
                }
                elseif ($User -notlike "*@*.*") {
                    $User = "$($User)@$($Script:PSGSuite.Domain)"
                }
                if ($A -notlike "*@*.*") {
                    $A = "$($A)@$($Script:PSGSuite.Domain)"
                }
                Write-Verbose "Creating alias '$A' for user '$User'"
                $body = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.Alias'
                $body.AliasValue = $A
                $request = $service.Users.Aliases.Insert($body,$User)
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