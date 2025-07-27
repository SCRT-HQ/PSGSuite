Function Revoke-GSToken {
    <#
    .SYNOPSIS
    Revokes the OAuth authorization token that was granted to PSGSuite for the specified user.

    .DESCRIPTION
    Revokes the OAuth authorization token that was granted to PSGSuite for the specified user.

    No output is produced by this function. If the operation fails an exception will be thrown.

    .PARAMETER User
    The user who is to have their OAuth authorization revoked.

    .PARAMETER UserCredential
    The userCredential containing the OAuth authorization token that is to be revoked.

    .PARAMETER NoDelete
    Prevents the token being deleted from the disk cache after it has been revoked.

    .NOTES
    It is only possible to revoke OAuth tokens that were generated using the Client-Secrets-OAuth authenication method.

    .EXAMPLE
    PS > Revoke-GSToken -User 'user@email.com'

    .LINK
    https://psgsuite.io/Function%20Help/Authentication/Revoke-GSToken/

    #>
    [cmdletbinding(SupportsShouldProcess, ConfirmImpact='High')]
    Param(
        [parameter(Mandatory = $false, ParameterSetName = "RevokeUser")]
        [ValidateNotNullOrEmpty()]
        [String]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $true, ParameterSetName = "RevokeUserCredential")]
        [Google.Apis.Auth.OAuth2.UserCredential]
        $UserCredential,
        [parameter(Mandatory = $false, ParameterSetName = "RevokeUser")]
        [parameter(Mandatory = $false, ParameterSetName = "RevokeUserCredential")]
        [Switch]
        $NoDelete
        
    )

    Process {

        # Get the user's UserCredential
        If ($PSCmdlet.ParameterSetName -eq "RevokeUser"){
            $UserCredential = New-GoogleUserCredential -User $User -SkipUserValidation -Offline
            If ($UserCredential){
                Write-Verbose "Revoking cached UserCredential for user '$User'."
            } else {
                Write-Warning "Nothing to revoke! No UserCredential was found for user '$User'."
                Return
            }
        }

        If ($PSCmdlet.ShouldProcess($UserCredential.UserId)){
            
            Try {
                If ($NoDelete){
                    # To prevent deleting the token from the disk cache we will call revoke with a non-existent UserID (key) that will silently fail on deletion
                    # Ideally we would call $UserCredential.Flow.RevokeTokenAsync('NonexistentKey', $AccessToken, ...) but Flow is not Common Language Specification (CLS) compliant and errors out.
                    # So instead we will repackage the token into a new UserCredential located in memory referencing a non-existent userID (key), and trigger revocation from there.
                    # The userId property of the credential is used to build the path to the credential in the FileDataStore, it is not used for issuing any API commands.
                    $repackagedCredential = [Google.Apis.Auth.OAuth2.UserCredential]::new($UserCredential.Flow, 'NonexistentKey', $UserCredential.Token)
                    $repackagedCredential.RevokeTokenAsync([System.Threading.CancellationToken]::None).GetAwaiter().GetResult() | Out-Null
                    Write-Verbose "Successfully revoked UserCredential '$($UserCredential.UserId)' and persisted on disk."
                } else {
                    $UserCredential.RevokeTokenAsync([System.Threading.CancellationToken]::None).GetAwaiter().GetResult() | Out-Null
                    Write-Verbose "Successfully revoked UserCredential '$($UserCredential.UserId)' and deleted from disk."
                }
            } Catch {
                $PSCmdlet.ThrowTerminatingError($_.Exception)
            }
            
            # Clear the Service Cache so that all future commands will require a new token
            Clear-PSGSuiteServiceCache

            # Clear the User Credential from memory
            if ($script:_PSGSuiteUserCredentials -and $script:_PSGSuiteUserCredentials.ContainsKey($UserCredential.UserId)) {
                Write-Verbose "Removing UserCredential '$($UserCredential.UserID)' from memory."
                $script:_PSGSuiteUserCredentials.Remove($UserCredential.UserId)
            }

        } else {
            Write-Verbose "Confirmation was not provided. No attempt was made to revoke the UserCredential."
        }
            
    }
}