Function Resolve-PSGSuiteScope {
    <#
    .SYNOPSIS
    Resolves the provided OAuth scope identifiers to their OAuth scope values.

    .DESCRIPTION
    Resolves the provided OAuth scope identifiers to their OAuth scope values.

    .PARAMETER Scope
    The OAuth scope identifiers to resolve.

    Accepted values are:
    - OAuth scope - The value of a specific OAuth scope. eg 'https://www.googleapis.com/auth/admin.directory.user'
    - PSGSuite function - The name of a PSGSuite function. eg 'Get-GSUser'
    - API service - The service string for a specific Google API. eg 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'

    .PARAMETER DefaultScopes
    Resolves the default OAuth scopes from the `ClientSecretScopes` configuration parameter.

    .EXAMPLE
    PS> Resolve-PSGSuiteScope -Scope 'Get-GSUser', 'Google.Apis.Calendar.v3.CalendarService'

    https://www.googleapis.com/auth/admin.directory.user
    https://www.googleapis.com/auth/admin.directory.user.readonly
    https://www.googleapis.com/auth/calendar

    .LINK
    https://psgsuite.io/Function%20Help/Authentication/Resolve-PSGSuiteScope/

    #>
    
    [CmdletBinding()]
    Param (
        [parameter(Mandatory=$true, ParameterSetName='Scope')]
        [ValidateSet([PSGSuiteValidScopeIdentifierValues])]
        [String[]]
        $Scope,
        [parameter(Mandatory = $true, ParameterSetName = 'DefaultScopes')]
        [Switch]$DefaultScopes
    )
    Process {

        If ($PSCmdlet.ParameterSetName -eq "DefaultScopes"){
            Write-Verbose "Resolving the default OAuth scopes from the current configuration"
            $Scope = @()
            ForEach ($Value in $Script:PSGSuite.ClientSecretScopes){
                $Scope += $Value
            }
            #Add the 'unserinfo.email' and 'openid' OAuth scope so that the authenticated user's email address is included in the authentication response.
            # These scopes are mandatory and always required so that the token user can be validated.
            $Scope += "https://www.googleapis.com/auth/userinfo.email"
            $Scope += "openid"
            $Scope = $Scope | Select-Object -Unique
        }
        
        Write-Verbose "Resolving OAuth scopes from $($Scope.count) input values"
        $Output = ForEach ($Value in $Scope){
            Switch -Regex ($Value){
                "^Google\.Apis" {
                    Get-PSGSuiteScope -Service $Value -ValueOnly
                }
                "^https://" {
                    $Value
                }
                "^openid" {
                    "openid"
                }
                Default {
                    Get-PSGSuiteScope -Function $Value -ValueOnly
                }
            }
        }
        $Output = $Output | Select-Object -Unique | Sort-Object
        Write-Verbose "Resolved $($Output.count) unique OAuth scopes"
        $Output

    }

}