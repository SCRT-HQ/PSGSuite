Function Get-GSScope {
    <#
    .SYNOPSIS
    Returns the OAuth scopes that PSGSuite has been authorized to access for the specified user.

    .DESCRIPTION
    Returns the OAuth scopes that PSGSuite has been authorized to access for the specified user.
    
    This is only supported when the PSGSuite authentication method is set to Client-Secrets-OAuth.

    .OUTPUTS
    The list of authorised OAuth scopes for the specified user.

    .PARAMETER User
    The primary email of the user whose authorized OAuth scopes are to be returned. You can exclude the '@domain.com' to insert the Domain in the config or use the special 'me' to indicate the AdminEmail in the config.

    Defaults to the AdminEmail in the config

    .EXAMPLE
    Returns the list of authorized OAuth scopes for the specified user.

    PS > Get-GSScope -User $User

    .NOTES
    It is only possible to get the OAuth scopes that have been authorized when using the Client-Secrets-OAuth authentication method. All other authentication methods will return no results.

    .LINK
    https://psgsuite.io/Function%20Help/Authentication/Get-GSScope/
    #>
    [OutputType([String[]])]
    [cmdletbinding()]
    Param(
        [parameter(Mandatory = $false,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $User = $Script:PSGSuite.AdminEmail
    )

    Process {
        
        $AuthMethod = Get-PSGSuiteAuthenticationMethod
        If ($AuthMethod -ne 'Client-Secrets-OAuth'){
            Write-Warning "It is only possible to get the authorized OAuth scopes when the PSGSuite authentication method is Client-Secrets-OAuth. The currrent PSGSuite authentication method is '$AuthMethod'."
            Return
        }

        Resolve-Email ([ref]$User)

        Write-Verbose "Getting the authorized OAuth scopes for user '$user'"

        # Try the memory cache first before fetching from disk
        $AuthorizedToken = If ($script:_PSGSuiteUserCredentials){
            If ($script:_PSGSuiteUserCredentials.ContainsKey($User)){
                Write-Verbose "UserCredential for '$User' was found in memory"
                $script:_PSGSuiteUserCredentials[$User].Token
            }
        }

        # Fallback to the disk cache
        If (-not $AuthorizedToken){
            # Initialize the FileDataStore used for storing and retrieving cached OAuth tokens.
            $Datastore = New-Object 'Google.Apis.Util.Store.FileDataStore' -ArgumentList $Script:_PSGSuiteCredPath,$true
            # Search the datastore
            $AuthorizedToken = $Datastore.getAsync[Google.Apis.Auth.OAuth2.Responses.TokenResponse]($User).GetAwaiter().GetResult()
            If ($AuthorizedToken){
                Write-Verbose "UserCredential for '$User' was found on disk"
            }
        }

        # Get the scopes from the token
        If ($AuthorizedToken){
            
            [string[]]$AuthorizedScopes = $AuthorizedToken.Scope -Split " " | Sort-Object
            Write-Verbose "$($AuthorizedScopes.count) authorized OAuth scopes were found for user '$User'"
            
            If ($AuthorizedScopes){
                Return $AuthorizedScopes
            }

        } else {
            Write-Verbose "UserCredential for '$User' does not exist"
        }

    }

}