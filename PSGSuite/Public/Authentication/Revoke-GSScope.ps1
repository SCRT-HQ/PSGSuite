Function Revoke-GSScope {
    <#
    .SYNOPSIS
    Invokes interactive authorisation for the given user and revokes authorisation for the specified OAuth scopes.

    .DESCRIPTION
    Invokes interactive authorisation for the given user and revokes authorisation for the specified OAuth scopes.
    
    This is only supported when the PSGSuite authentication method is set to Client-Secrets-OAuth.

    .OUTPUTS
    The list of authorised OAuth scopes for the specified user.

    .PARAMETER User
    The primary email of the user whose authorized OAuth scopes are to be updated. You can exclude the '@domain.com' to insert the Domain in the config or use the special 'me' to indicate the AdminEmail in the config.

    Defaults to the AdminEmail in the config.

    .PARAMETER Scope
    The OAuth scopes to revoke.

    Accepted values are:
    * OAuth scope - The value of a specific OAuth scope. eg 'https://www.googleapis.com/auth/admin.directory.user'
    * PSGSuite function - The name of a PSGSuite function. eg 'Get-GSUser'
    * API service - The service string for a specific Google API. eg 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'

    When an API service or PSGSuite function is specified the values will be resolved to their respective OAuth scopes.
    
    See PSGSuite help or use `Get-PSGSuiteScope` to see the list of OAuth scopes, functions and API services.

    The default OAuth scopes will always be authorised regardless if they are included with the `-scope` parameter or not.

    .PARAMETER SupplementalScopes
    Revokes authorisation for all supplemental OAuth scopes and requests authorisation for all default OAuth scopes.

    .PARAMETER AllScopes
    Revokes authorisation for all supplemental and default OAuth scopes.

    .EXAMPLE
    Invokes the interactive authorisation workflow and revokes authorisation for the 'https://www.googleapis.com/auth/admin.directory.user' OAuth scope.

    PS > Revoke-GSScope -User 'user@email.com' -Scope 'https://www.googleapis.com/auth/admin.directory.user'

    .EXAMPLE
    Invokes the interactive authorisation workflow revokes authorisation for all supplemental OAuth scopes.

    PS > Get-GSScope -User 'user@email.com' -AllSupplementalScopes

    .EXAMPLE
    Revokes authorisation for all supplemental and default OAuth scopes.

    PS > Get-GSScope -User 'user@email.com' -AllScopes

    .NOTES
    It is only possible to change the authorized OAuth scopes when using the Client-Secrets-OAuth authentication method. All other authentication methods will return an error.

    The default OAuth scopes are configured via the PSGSuite `ClientSecretsScopes` configuration parameter. See `Set-PSGSuiteConfig` for further details.

    A supplemental OAuth scope is any OAuth scope that is not configured as a default OAuth scope.

    .LINK
    https://psgsuite.io/Function%20Help/Authentication/Revoke-GSScope/
    #>
    [OutputType([String[]])]
    [cmdletbinding(SupportsShouldProcess, ConfirmImpact='High')]
    Param(
        [parameter(Mandatory = $false, ParameterSetName = 'Scope')]
        [parameter(Mandatory = $false, ParameterSetName = 'Reset')]
        [parameter(Mandatory = $false, ParameterSetName = 'Revoke')]
        [ValidateNotNullOrEmpty()]
        [String]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $true, ParameterSetName = 'Scope')]
        [ValidateSet([PSGSuiteValidScopeIdentifierValues])]
        [String[]]$Scope,
        [parameter(Mandatory = $true, ParameterSetName = 'Reset')]
        [Switch]$SupplementalScopes,
        [parameter(Mandatory = $true, ParameterSetName = 'Revoke')]
        [Switch]$AllScopes

    )

    Process {
        
        $AuthMethod = Get-PSGSuiteAuthenticationMethod
        If ($AuthMethod -ne 'Client-Secrets-OAuth'){
            $PSCmdlet.ThrowTerminatingError((ThrowTerm "It is only possible to change the authorized OAuth scopes when the PSGSuite authentication method is Client-Secrets-OAuth. The currrent PSGSuite authentication method is '$AuthMethod'."))
        }

        Resolve-Email ([ref]$User)

        If ($PSCmdlet.ParameterSetName -eq 'Revoke'){
            
            write-verbose "Attempting to revoke all authorization for user '$User'"
            If ($PSCmdlet.ShouldProcess($User, "Revoke all OAuth scopes")){
                Revoke-GSToken -User $User -confirm:$false
            } else {
                Write-Warninge "Confirmation was not provided. No OAuth scopes were revoked."
            }

        } else {

            $Params = @{}
            If ($PSCmdlet.ParameterSetName -eq 'Scope'){
                $ResolvedScopes = Resolve-PSGSuiteScope -scope $Scope
                $Message = "Revoke $($ResolvedScopes.count) OAuth Scopes"
                $Params['ExcludeScope'] = $ResolvedScopes
            } else {
                $Message = "Revoke all supplemental OAuth scopes"
                $Params['ExcludeSupplementalScopes'] = $True
            }

            write-verbose "Attempting to $Message for user '$User'"
            If ($PSCmdlet.ShouldProcess($User, $Message)){
                Try {
                    $Credential = New-GoogleUserCredential -User $User @Params -confirm:$false
                } Catch {
                    $PSCmdlet.ThrowTerminatingError($_)
                }
                $Credential.Token.Scope -split ' ' | Sort-Object
            } else {
                # Return the currently authorised scopes without making any changes
                Write-Warning "User confirmation was not provided. No OAuth scopes were revoked."
                Get-GSScope -User $User
            }
            
        }

    }

}