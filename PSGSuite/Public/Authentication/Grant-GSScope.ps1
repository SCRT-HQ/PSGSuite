Function Grant-GSScope {
    <#
    .SYNOPSIS
    Invokes interactive authorisation for the given user and requests authorisation for the specified OAuth scopes.

    .DESCRIPTION
    Invokes interactive authorisation for the given user and requests authorisation for the specified OAuth scopes.
    
    This is only supported when the PSGSuite authentication method is set to Client-Secrets-OAuth.

    .OUTPUTS
    The list of authorised OAuth scopes for the specified user.

    .PARAMETER User
    The primary email of the user whose authorized OAuth scopes are to be updated. You can exclude the '@domain.com' to insert the Domain in the config or use the special 'me' to indicate the AdminEmail in the config.

    Defaults to the AdminEmail in the config.

    .PARAMETER Scope
    The OAuth scopes to authorise.

    Accepted values are:
    * OAuth scope - The value of a specific OAuth scope. eg 'https://www.googleapis.com/auth/admin.directory.user'
    * PSGSuite function - The name of a PSGSuite function. eg 'Get-GSUser'
    * API service - The service string for a specific Google API. eg 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'

    When an API service or PSGSuite function is specified the values will be resolved to their respective OAuth scopes.
    
    See PSGSuite help or use `Get-PSGSuiteScope` to see the list of OAuth scopes, functions and API services.

    All default OAuth scopes will always be authorised regardless if they are included with the `-scope` parameter or not.

    .PARAMETER ExcludeSupplementalScopes
    Excludes and revokes authorisation for all supplemental OAuth scopes that were not included with the `-scope` parameter.

    .EXAMPLE
    Invokes the interactive authorisation workflow prompting the user to authorise the OAuth scopes:
      - All supplemental OAuth scopes with an existing authorisation
      - All default OAuth scopes
      - OAuth scope 'https://www.googleapis.com/auth/admin.directory.user'

    PS > Get-GSScope -User 'user@email.com' -Scope 'https://www.googleapis.com/auth/admin.directory.user'

    .EXAMPLE
    Invokes the interactive authorisation workflow prompting the user to authorise the OAuth scopes:
      - Default OAuth scopes found in the `ClientSecretsScopes` configuration parameter
      - OAuth scope 'https://www.googleapis.com/auth/admin.directory.user'

    Any other supplemental OAuth scopes will have their authorisation revoked.

    PS > Get-GSScope -User 'user@email.com' -ExcludeSupplementalScopes -Scope 'https://www.googleapis.com/auth/admin.directory.user'

    .NOTES
    It is only possible to change the authorized OAuth scopes when using the Client-Secrets-OAuth authentication method. All other authentication methods will return an error.

    The default OAuth scopes are configured via the PSGSuite `ClientSecretsScopes` configuration parameter. See `Set-PSGSuiteConfig` for further details.

    A supplemental OAuth scope is any OAuth scope that is not configured as a default OAuth scope.

    .LINK
    https://psgsuite.io/Function%20Help/Authentication/Grant-GSScope/
    #>
    [OutputType([String[]])]
    [cmdletbinding(SupportsShouldProcess, ConfirmImpact='High')]
    Param(
        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false)]
        [ValidateSet([PSGSuiteValidScopeIdentifierValues])]
        [String[]]$Scope = @(),
        [parameter(Mandatory = $false)]
        [Switch]$ExcludeSupplementalScopes
    )

    Process {
        
        $AuthMethod = Get-PSGSuiteAuthenticationMethod
        If ($AuthMethod -ne 'Client-Secrets-OAuth'){
            $PSCmdlet.ThrowTerminatingError((ThrowTerm "It is only possible to change the authorized OAuth scopes when the PSGSuite authentication method is Client-Secrets-OAuth. The currrent PSGSuite authentication method is '$AuthMethod'."))
        }

        Resolve-Email ([ref]$User)
        
        If ($Scope.Count){
            $ResolvedScopes = Resolve-PSGSuiteScope -scope $Scope
        } else {
            Write-Verbose "No Oauth scopes were specified. The default OAuth scopes will be granted instead."
            $ResolvedScopes = Resolve-PSGSuiteScope -scope $Script:PSGSuite.ClientSecretScopes
        }

        If ((-not $ExcludeSupplementalScopes) -or $PSCmdlet.ShouldProcess($User, "Grant $($ResolvedScopes.count) OAuth scopes and revoke all supplemental OAuth scopes")){
            Write-Verbose "Requesting grant of $($ResolvedScopes.count) OAuth scopes for user '$User'"
            Try {
                $Credential = New-GoogleUserCredential -Scope $ResolvedScopes -User $User -ExcludeSupplementalScopes:$ExcludeSupplementalScopes -confirm:$false
            } Catch {
                $PSCmdlet.ThrowTerminatingError($_)
            }
            $Credential.Token.Scope -split ' ' | Sort-Object
        } else {
            # Return the currently authorised scopes without making any changes
            Write-Verbose "User confirmation was not provided. No OAuth scopes were granted."
            Get-GSScope -User $User
        }

    }

}