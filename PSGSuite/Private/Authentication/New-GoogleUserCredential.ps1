function New-GoogleUserCredential {
    <#
    .SYNOPSIS
    Creates a new Google UserCredential object for use with the Client-Secrets-OAuth authentication method. The credential object is used to authenticate PSGSuite to Google.

    .DESCRIPTION
    Creates a new Google UserCredential object for use with the Client-Secrets-OAuth authentication method. The credential object is used to authenticate PSGSuite to Google.

    The Client-Secrets-OAuth authentication method requires interactive input from an end-user whenever the authorised OAuth scopes are changing. See the Notes section for further details.

    By default the generated UserCredential will include all OAuth scopes from the following sources:
    - `-scopes` parameter
    - All supplemental OAuth scopes with an existing authorisation
    - All default OAuth scopes

    .NOTES
    UserCredentials are only valid for the Client-Secrets-OAuth authentication method.

    An interactive authorisation workflow is used to delegate user credentials to PSGSuite. When required, the system web browser will be automatically launched and the user will be prompted to complete the Google OAuth authorisation workflow. Commands will be unable to be processed until OAuth authorisation has been completed.

    It is expected that the interactive authorisation workflow will only be required when:
    - It is the first time an authorisation token is being requested for a given user.
    - Additional OAuth scopes are being authorised.
    - Authorisation is being revoked for specific OAuth scopes.
    - The existing OAuth authorisation token is expired and cannot be renewed.

    The default OAuth scopes are configured via the PSGSuite `ClientSecretsScopes` configuration parameter. See `Set-PSGSuiteConfig` for further details.

    A supplemental OAuth scope is any OAuth scope that is not configured as a default OAuth scope.

    .PARAMETER Scope
    The OAuth scope or scopes that will be authorised and added to the UserCredential, e.g. https://www.googleapis.com/auth/admin.reports.audit.readonly

    It is possible for a user to decline an OAuth scope during the interactive authorisation workflow. If any of the OAuth scopes specified with the `-scope` parameter are declined a terminating error will be thrown.

    By dafault all authorised supplemental OAuth scopes and all default OAuth scopes will be included even if they were not provided to the `-scope` parameter.

    .PARAMETER User
    The user to be authenticated. The generated UserCredential will be validated against this user. If a different user account is attached to the credential a terminating error will be thrown and the credential will be revoked. Validation of the user can be skipped by specifying the `-SkipUserValidation` switch.

    .PARAMETER ExcludeScope
    Exclues and revokes authorisation for the provided supplemental OAuth scopes that were not included with the `-scope` parameter.

    .PARAMETER ExcludeSupplementalScopes
    Excludes and revokes authorisation for all supplemental OAuth scopes that were not included with the `-scope` parameter.

    .PARAMETER SkipUserValidation
    Skips validation of the user account attached to the UserCredential.

    .PARAMETER Offline
    The UserCredential will be generated in offline mode without prompting the user to complete the interactive authorisation workflow. This is only possible when a previously auithorised UserCrednetial exists in the disk cache.

    All OAuth scopes from the cached UserCredential with an existing authorisation will be added to the new UserCredential. If any default OAuth scopes do not have an existing authorisation they will be excluded from the new UserCredential.

    .EXAMPLE
    This will return a UserCredential for 'user@email.com' that includes the following OAuth scopes:
    - https://www.googleapis.com/auth/admin.reports.audit.readonly
    - All default OAuth scopes
    - All authorised supplemental OAuth scopes

    Interactive authorisation will be prompted if any of the following is true:
    - OAuth scope 'https://www.googleapis.com/auth/admin.reports.audit.readonly' does not have an existing authorisation
    - Any of the default OAuth scopes do not have an existing authorisation

    $CredentialParams = @{
        Scope   = 'https://www.googleapis.com/auth/admin.reports.audit.readonly'
        User    = 'user@email.com'
    }
    $Credential = New-GoogleUserCredential @CredentialParams

    .EXAMPLE
    This will return a UserCredential for 'user@email.com' that includes the following OAuth scopes:
    - https://www.googleapis.com/auth/admin.reports.audit.readonly
    - All default OAuth scopes

    All supplemental OAuth scopes will be excluded except for 'https://www.googleapis.com/auth/admin.reports.audit.readonly'.
    
    Interactive authorisation will be prompted if any of the following is true:
    - OAuth scope 'https://www.googleapis.com/auth/admin.reports.audit.readonly' does not have an existing authorisation
    - Any of the default OAuth scopes do not have an existing authorisation
    - Any authorised supplemental OAuth scopes have been excluded
    
    $CredentialParams = @{
        Scope   = 'https://www.googleapis.com/auth/admin.reports.audit.readonly'
        User    = 'user@email.com'
    }
    $Credential = New-GoogleUserCredential @CredentialParams -ExcludeSupplementalScopes

    .EXAMPLE
    This will return a UserCredential for 'user@email.com' that includes the following OAuth scopes:
    - https://www.googleapis.com/auth/admin.reports.audit.readonly
    - All default OAuth scopes
    - All authorised supplemental OAuth scopes except 'https://www.googleapis.com/auth/calendar'
    
    Interactive authorisation will be prompted if any of the following is true:
    - OAuth scope 'https://www.googleapis.com/auth/admin.reports.audit.readonly' does not have an existing authorisation
    - Any of the default OAuth scopes do not have an existing authorisation
    - Supplemental OAuth scope 'https://www.googleapis.com/auth/calendar' has an existing authorisation
    
    $CredentialParams = @{
        Scope   = 'https://www.googleapis.com/auth/admin.reports.audit.readonly'
        User    = 'user@email.com'
        ExcludeScope = 'https://www.googleapis.com/auth/calendar'
    }
    $Credential = New-GoogleUserCredential @CredentialParams

    .EXAMPLE
    This will return a UserCredential for 'user@email.com' that includes the following OAuth scopes:
    - All OAuth scopes with an existing authorisation
    
    Interactive authorisation will not be prompted.

    A UserCredential will only be returned if an existing UserCredential is found in the disk cache.
    
    $CredentialParams = @{
        User    = 'user@email.com'
    }
    $Credential = New-GoogleUserCredential @CredentialParams -Offline

    #>
    [OutputType('Google.Apis.Auth.OAuth2.UserCredential')]
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    Param(
        [Parameter(Mandatory = $true, ParameterSetName = "grant")]
        [String[]]
        $Scope,
        [Parameter(Mandatory = $true, ParameterSetName = "revoke")]
        [String[]]
        $ExcludeScope,
        [Parameter(Mandatory = $true, ParameterSetName = "grant")]
        [Parameter(Mandatory = $true, ParameterSetName = "revoke")]
        [Parameter(Mandatory = $true, ParameterSetName = "Offline")]
        [Parameter(Mandatory = $true, ParameterSetName = "grantDefault")]
        [String]
        $User,
        [Parameter(Mandatory = $false, ParameterSetName = "grant")]
        [Parameter(Mandatory = $false, ParameterSetName = "grantDefault")]
        [Switch]
        $ExcludeSupplementalScopes,
        [Parameter(Mandatory = $false, ParameterSetName = "grant")]
        [Parameter(Mandatory = $false, ParameterSetName = "revoke")]
        [Parameter(Mandatory = $false, ParameterSetName = "Offline")]
        [Parameter(Mandatory = $false, ParameterSetName = "grantDefault")]
        [Switch]
        $SkipUserValidation,
        [Parameter(Mandatory = $true, ParameterSetName = "Offline")]
        [Switch]
        $Offline
    )
    Begin {
        
        # Get the default OAuth scopes from the config
        if (-not $script:_PSGSuiteClientSecretScopes) {
            Write-Verbose 'Building the default OAuth scope cache'
            # Stores the resolved list of default OAuth scopes for re-use
            $script:_PSGSuiteClientSecretScopes = [System.Collections.Generic.HashSet[String]]::new([System.StringComparer]::OrdinalIgnoreCase)
            Resolve-PSGSuiteScope -DefaultScopes | ForEach-Object {
                $script:_PSGSuiteClientSecretScopes.add($_) | Out-Null
            }
        }

        # Load the client secrets file
        if (-not $script:PSGSuite.ClientSecrets) {
            Write-Verbose "Updating the current PSGSuite configuration with the ClientSecrets values."
            $script:PSGSuite.ClientSecrets = ([System.IO.File]::ReadAllText($script:PSGSuite.ClientSecretsPath))
            Set-PSGSuiteConfig -ConfigName $script:PSGSuite.ConfigName -ClientSecrets $script:PSGSuite.ClientSecrets -Verbose:$false
        }
        if (-not $script:_PSGSuiteClientSecrets){
            Write-Verbose "Loading the ClientSecrets into memory."
            $stream = New-Object System.IO.MemoryStream $([System.Text.Encoding]::ASCII.GetBytes(($script:PSGSuite.ClientSecrets))),$null
            # Stores the loaded Client Secrets file for re-use
            $script:_PSGSuiteClientSecrets = [Google.Apis.Auth.OAuth2.GoogleClientSecrets]::Load($stream).Secrets
            $stream.close()
        }

        # Initialize the in-memory user credential cache
        if (-not $script:_PSGSuiteUserCredentials) {
            # Stores the instantiated user credentials in memory for re-use.
            # To avoid conflicts when tokens are automatically refreshed we will ensure that only one instance of a credential is
            # instantiated and used at any given time.
            $script:_PSGSuiteUserCredentials = @{}
        }

        # Initialize the FileDataStore used for storing and retrieving cached OAuth tokens.
        $Datastore = New-Object 'Google.Apis.Util.Store.FileDataStore' -ArgumentList $Script:_PSGSuiteCredPath,$true

    }

    Process {
        
        Write-Verbose "Generating UserCredential for user '$user' in '$($PSCmdlet.ParameterSetName)' mode."

        $TokenName = [Google.Apis.Util.Store.FileDataStore]::GenerateStoredKey($User, [Google.Apis.Auth.OAuth2.Responses.TokenResponse])
        $TokenPath = Join-Path $Datastore.FolderPath $TokenName



        # Build the list of scopes to request
        #
        # The following OAuth scopes will be included in each UserCredential/auhtorisation request:
        # GRANT (Online):
        # - $scope parameter
        # - Default OAuth scopes
        # - All authorised supplemental OAuth scopes if $ExcludeSupplementalScopes parameter is $false
        #
        # REVOKE (Online):
        # - Default OAuth scopes
        # - All authorised supplemental OAuth scopes except the scopes from the $ExcludeScope parameter
        #
        # OFFLINE:
        # - All existing authorised OAuth scopes
        #
        # GrantDefault (Online):
        # - Default OAuth scopes


        # All scopes to be requested - May include: default, existing and required scopes
        $ScopesToRequest = @()
        # All scopes that were passed to the $scope parameter
        $ScopesRequired = [System.Collections.Generic.HashSet[String]]::new([System.StringComparer]::OrdinalIgnoreCase)
        # All scopes that will be revoked
        $ScopesToRevoke = @()
        # Existing scopes that will be kept
        $ScopesToKeep = @()
        # All requested scopes without an existing authorisation
        $ScopesToGrant = @()
        # All existing scopes for the user
        $ExistingScopes = @()
        # All scopes that are to be safely excluded
        $ScopesToExclude = [System.Collections.Generic.HashSet[String]]::new([System.StringComparer]::OrdinalIgnoreCase)



        # Find the existing credential if one exists
        #
        # Search in memory first. Otherwise try the disk datastore.
        $ExistingCredential = If ($script:_PSGSuiteUserCredentials.containsKey($User)){
            
            Write-Verbose "Getting existing UserCredential for '$User' from memory"
            $script:_PSGSuiteUserCredentials[$User]

        } else {

            If ((Test-Path $TokenPath)){
                # Online flows - Load the existing credential
                If ($PSCmdlet.ParameterSetName -ne "Offline"){
                    Write-Verbose "Invoking the offline flow to get existing UserCredential for '$User' from disk"
                    New-GoogleUserCredential -User $User -Offline
                }
            } else {
                # Terminate Offline flow - Offline avoids prompting for user input.
                # Terminate Revoke flows - Can't revoke scopes that don't exist.
                If (($PSCmdlet.ParameterSetName -eq "Offline") -or ($PSCmdlet.ParameterSetName -eq "Revoke")){
                    Write-Verbose "Unable to continue in '$($PSCmdlet.ParameterSetName)' mode. No existing UserCredential was found for user '$user'"
                    Return
                }
            }
            

        }


        
        # Offline flow - Terminate if credential was found in memory
        # If it is in memory, we will assume that it was validated already and terminate the flow here.
        If ($PSCmdlet.ParameterSetName -eq "Offline"){
            If ($ExistingCredential){
                Write-Verbose "Returning existing UserCredential with $($ExistingCredential.Token.Scope.split(' ').count) OAuth scopes for user '$user'"
                Return $ExistingCredential
            }
        }



        # Online Flows - Parse the existing credential
        If ($PSCmdlet.ParameterSetName -ne 'Offline'){
            If ($ExistingCredential){
                Write-Verbose "The existing OAuth scopes for '$user' are:"
                ForEach ($ExistingScope in $ExistingCredential.Token.Scope.split(' ')){
                    $ExistingScopes += $ExistingScope
                    If ($script:_PSGSuiteClientSecretScopes.contains($ExistingScope)){
                        Write-Verbose "  $ExistingScope [default]"
                    } else {
                        Write-Verbose "  $ExistingScope"
                    }
                }
            } else {
                Write-Verbose "Existing UserCredential for '$User' not found."
            }
        }


        # Online Flows - Determine the scopes required for the UserCredential
        If ($PSCmdlet.ParameterSetName -ne "Offline"){
            Switch ($PSCmdlet.ParameterSetName){
                
                "Grant" {
                    # Required scopes
                    Write-Verbose "The required OAuth scopes to request are:"
                    ForEach ($RequiredScope in $Scope){
                        If (-not $script:_PSGSuiteClientSecretScopes.contains($RequiredScope)){
                            Write-Verbose "  $RequiredScope"
                            $ScopesToRequest += $RequiredScope
                            $ScopesRequired.add($RequiredScope) | Out-Null
                        } else {
                            Write-Verbose "  $RequiredScope"
                        }
                    }

                    # Default Scopes
                    Write-Verbose "The default OAuth scopes to request are:"
                    ForEach ($DefaultScope in $script:_PSGSuiteClientSecretScopes){
                        Write-Verbose "  $DefaultScope"
                        $ScopesToRequest += $DefaultScope
                    }
                }

                "GrantDefault" {
                    # Default Scopes
                    Write-Verbose "The required OAuth scopes to request are:"
                    ForEach ($DefaultScope in $script:_PSGSuiteClientSecretScopes){
                        Write-Verbose "  $DefaultScope"
                        $ScopesToRequest += $DefaultScope
                    }
                }

                "Revoke" {
                    # Default Scopes
                    Write-Verbose "The default OAuth scopes to request are:"
                    ForEach ($DefaultScope in $script:_PSGSuiteClientSecretScopes){
                        Write-Verbose "  $DefaultScope"
                        $ScopesToRequest += $DefaultScope
                    }

                    # Exclude scopes
                    Write-Verbose "The OAuth scopes to exclude are:"
                    ForEach ($RequiredScope in $ExcludeScope){
                        If (-not $script:_PSGSuiteClientSecretScopes.contains($RequiredScope)){
                            Write-Verbose "  $RequiredScope"
                            $ScopesToExclude.add($RequiredScope) | Out-Null
                        } else {
                            Write-Verbose "  [skipped] $RequiredScope"
                        }
                    }
                }

            }
        }



        # Online Flows - Check the scopes and determine the changes
        If ($PSCmdlet.ParameterSetName -ne "Offline"){
            Write-Verbose "Checking scopes:"
            Compare-Object -ReferenceObject $ExistingScopes -DifferenceObject $ScopesToRequest -IncludeEqual | ForEach-Object {
                
                # Mark the verbose output with the default and required status of each scope.
                If ($script:_PSGSuiteClientSecretScopes.contains($_.InputObject)){
                    $DefaultTag = "[default]"
                } else {
                    $DefaultTag = ""
                }
                If ($ScopesRequired.contains($_.InputObject)){
                    $Required = "[required]"
                } else {
                    $Required = ""
                }

                If ($_.SideIndicator -eq '=>'){
                    Write-Verbose "  [grant]  $($_.InputObject) $Required$DefaultTag"
                    $ScopesToGrant += $_.InputObject
                } elseif ($_.SideIndicator -eq '<=') {
                    If ($ExcludeSupplementalScopes){
                        Write-Verbose "  [revoke] $($_.InputObject) $Required$DefaultTag"
                        $ScopesToRevoke += $_.InputObject
                    } else {
                        If ($ScopesToExclude.Contains($_.InputObject)){
                            Write-Verbose "  [revoke] $($_.InputObject) $Required$DefaultTag"
                            $ScopesToRevoke += $_.InputObject
                        } else {
                            Write-Verbose "  [keep]   $($_.InputObject) $Required$DefaultTag"
                            $ScopesToRequest += $_.InputObject
                            $ScopesToKeep += $_.InputObject
                        }
                    }
                } else {
                    Write-Verbose "  [keep]   $($_.InputObject) $Required$DefaultTag"
                    $ScopesToKeep += $_.InputObject
                }

            }


            # If scopes aren't changed and there is an existing credential, use the existing UserCredential.
            # This will allow all cached service objects to use the same UserCredential object and receive updated tokens when it automatically refreshes.
            If ($ExistingCredential -and ($ScopesToGrant.count -eq 0) -and ($ScopesToRevoke.count -eq 0)){
                Write-Verbose "No OAuth scope changes are required. Returning the existing UserCredential for user '$user'."
                Return $ExistingCredential
            }
            Write-Verbose "Requesting a new UserCredential for OAuth scopes:  $($ScopesToGrant.count) new, $($ScopesToKeep.count) unchanged, $($ScopesToRevoke.count) revoked"
        }



        # Online Flows - Get user confirmation
        #
        # We will only get confirmation for explicit revocation of scopes
        # If a new credential with additional scopes is being created, we will silently revoke the existing credential once it has become superseded.
        If ($PSCmdlet.ParameterSetName -ne "Offline"){
            If (-not (($ScopesToRevoke.count -eq 0) -or $PSCmdlet.ShouldProcess($User, "Authorise $($ScopesToGrant.Count) new OAuth scopes and revoke $($ScopesToRevoke.count) existing OAuth scopes"))){
                Write-Verbose "Confirmation to revoke OAuth scopes was not provided. The existing UserCredential will be returned without modification."
                Return $ExistingCredential
            }
        }



        # Online flows - Revoke existing OAuth Token
        #
        # If the token scopes are changing a new token will be generated.
        # When creating a UserCredential the GoogleWebAuthorizationBroker loads the existing credential from disk without verifying if all scopes exist.
        # To force fetching a new UserCredential from Google we need to make sure no entry in the diskDatastore exists for $User.
        if ($ExistingCredential){
            Write-Verbose "Revoking the existing UserCredential."
            Revoke-GSToken -UserCredential $ExistingCredential -confirm:$False
        }



        # Online flows - Request the new OAuth Token
        # Offline flow - Load the existing OAuth token from disk
        Try {
            Write-Verbose "Building UserCredential for '$User' from ClientSecrets and prompting for authorization if necessary."
            $Initializer = [Google.Apis.Auth.OAuth2.Flows.GoogleAuthorizationCodeFlow+Initializer]::new()
            $Initializer.ClientSecrets = $script:_PSGSuiteClientSecrets
            $Initializer.LoginHint = $User
            # Incremental Authorization is not permitted for installed apps. https://developers.google.com/identity/protocols/oauth2/native-app
            $Initializer.IncludeGrantedScopes = $False

            $CodeReceiver = [Google.Apis.Auth.OAuth2.LocalServerCodeReceiver]::new()

            $credential = [Google.Apis.Auth.OAuth2.GoogleWebAuthorizationBroker]::AuthorizeAsync(
                $Initializer,
                [string[]]@($ScopesToRequest),
                $User,
                [System.Threading.CancellationToken]::None,
                $Datastore,
                $CodeReceiver
            ).GetAwaiter().GetResult()

        } Catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }

        If ($null -eq $Credential){
            $PSCmdlet.ThrowTerminatingError((ThrowTerm "Failed to create UserCredential. The authorisation prompt was likely cancelled, please try the request again."))
        }
        Write-Verbose "UserCredential for '$User' has been created"



        #
        # Validation - The emphasis is on security, if any validation steps fail the new token will be revoked and the user will need to complete the authorisation workflow again.
        #


        # Online flows - Validate the token user
        # Offline flows - Validate the token user
        #
        # During interactive authorization the user account that authorizes the API access is controlled by the end user. This makes it possible that an unexpected user
        # authorises the request. Proceeding with the unexpected user may cause incorrect resources to be modified, or other unintended consequences to arise.
        # To prevent this we will check that the user attached to the authentication token (ID Token), is the user that was requested by the current command.
        #
        # In theory any tokens found on disk via the offline flow should be valid but we will re-validate the token again anyway to ensure it's validity.
        If (-not $SkipUserValidation){
                        
            # If the token is stale we should refresh it first.
            If ($credential.Token.IsStale){
                Write-Verbose "The UserCredential is stale and will be refreshed"
                Try {
                    $Credential.RefreshTokenAsync([System.Threading.CancellationToken]::None).GetAwaiter().GetResult() | Out-Null
                } Catch {
                    Write-Verbose "An error occured while refreshing the UserCredential's token. The token will be revoked!"
                    Revoke-GSToken -UserCredential $credential -confirm:$False
                    $PSCmdlet.ThrowTerminatingError($_)
                }
            }
            
            # Confirm that an IdToken was produced
            If ($null -eq $credential.Token.IdToken){
                Write-Verbose "The UserCredential does not contain an ID token!"
                Revoke-GSToken -UserCredential $credential -confirm:$False
                $PSCmdlet.ThrowTerminatingError((ThrowTerm "Unable to validate the UserCredential's owner, an ID token was not found. It is mandatory that the OpenID scope be authorised during the interactive authorisation."))
            }

            # Parse and validate the ID token
            Try {
                $IDToken = [Google.Apis.Auth.GoogleJsonWebSignature]::ValidateAsync($credential.Token.IdToken, [Google.Apis.Auth.GoogleJsonWebSignature+ValidationSettings]::new()).GetAwaiter().GetResult()
            } Catch {
                Write-Verbose "The UserCredential's ID token failed validation. The token will be revoked!"
                Revoke-GSToken -UserCredential $credential -confirm:$False
                $PSCmdlet.ThrowTerminatingError($_)
            }
            
            # Check the user who authorised the credential
            If ($IDToken.Email -ne $User){
                Write-Verbose "A UserCredential was requested for '$User' but a UserCredential for '$($IDToken.Email)' was created."
                Revoke-GSToken -UserCredential $Credential -Confirm:$False
                $PSCmdlet.ThrowTerminatingError((ThrowTerm "A UserCredential was requested for '$User' but a UserCredential for '$($IDToken.Email)' was created. The token has been revoked."))
            } else {
                Write-Verbose "The UserCredential was successfully validated for user '$User'"
            }

        } else {
            Write-Verbose "Skipping user validation. The -SkipUserValidation switch is present."
        }





        # Online flows - Validate the token scopes
        #
        # During interactive authorization the user may deny one or more of the requested scopes while approving all others.
        # We will check that the scopes included in the authorization token contain the minimum scopes that are needed to execute the current command.
        # If any other scopes are missing, they will be re-requested the next time they are required for a command.
        $TokenScopes = $Credential.Token.Scope.Split(' ')
        If ($PSCmdlet.ParameterSetName -ne 'Offline'){
            If ($ScopesRequired.count){
                $MissingScopes = @()
                ForEach ($RequiredScope in $ScopesRequired){
                    If (-not $TokenScopes.Contains($RequiredScope)){
                        Write-Verbose "The required OAuth scope '$RequiredScope' is not authorised."
                        $MissingScopes += $RequiredScope
                    }
                }
                If ($MissingScopes.count){
                    $PSCmdlet.ThrowTerminatingError((ThrowTerm "The following scopes are required but they have not been authorised for use:`n$($MissingScopes -join "`n")"))
                }
            }
        }
        
        # Save the newly created credential in memory for later use
        $script:_PSGSuiteUserCredentials[$User] = $credential
        
        Write-Verbose "UserCredential for user '$user' was successfully created and includes $($TokenScopes.count) authorised OAuth scopes."
        Return $Credential

    }

}