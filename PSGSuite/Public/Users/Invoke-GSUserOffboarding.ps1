function Invoke-GSUserOffboarding {
    <#
    .SYNOPSIS
    Wraps some common offboarding tasks such as random password setting, OAuth token revocation, mobile device removal, and more.

    .DESCRIPTION
    Wraps some common offboarding tasks such as random password setting, OAuth token revocation, mobile device removal, and more.

    This function outputs in a log-style, timestamped format that is intended for auditability.

    .PARAMETER User
    The User to offboard

    .PARAMETER Options
    The tasks you would like to perform on the User. Defaults to the following: 'ClearASPs','ClearOAuthTokens','RemoveMobileDevices','Suspend','SetRandomPassword'

    Available options:
    * 'Full' - Performs all of the below tasks
    * 'ClearASPs' - Clears Application Specific Passwords
    * 'ClearOAuthTokens' - Clears OAuth tokens
    * 'RemoveMobileDevices' - Removes Mobile Devices
    * 'Suspend' - Suspends the user account
    * 'SetRandomPassword' - Sets the user's account to a random password
    * 'MoveToOrgUnit' - Moves the user to the DestinationOrgUnit specified
    * 'SetLicense' - Sets the user to a different license

    .PARAMETER DestinationOrgUnit
    If Options include Full or MoveToOrgUnit, this is the OrgUnit that the user will be moved to.

    .PARAMETER License
    The License to set the user to.

    .EXAMPLE
    Invoke-GSUserOffboarding -User tom.fields@domain.com -Options Full -DestinationOrgUnit '/Former Employees'

    Performs all of the listed tasks against user Tom Fields, including moving them to the '/Former Employees' OrgUnit and setting them to a VFE license.

    .NOTES
    Pull requests welcome for functionality enhancements!
    #>
    [CmdletBinding(SupportsShouldProcess,ConfirmImpact = "High")]
    Param(
        [Parameter(Mandatory,Position = 0,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [Alias('PrimaryEmail','Mail')]
        [string[]]
        $User,
        [Parameter()]
        [ValidateSet('Full','ClearASPs','ClearOAuthTokens','RemoveMobileDevices','Suspend','SetRandomPassword','MoveToOrgUnit','SetLicense')]
        [String[]]
        $Options = @('ClearASPs','ClearOAuthTokens','RemoveMobileDevices','Suspend','SetRandomPassword'),
        [Parameter()]
        [string]
        $DestinationOrgUnit,
        [Parameter()]
        [ValidateSet("G-Suite-Enterprise","Google-Apps-Unlimited","Google-Apps-For-Business","Google-Apps-For-Postini","Google-Apps-Lite","Google-Drive-storage-20GB","Google-Drive-storage-50GB","Google-Drive-storage-200GB","Google-Drive-storage-400GB","Google-Drive-storage-1TB","Google-Drive-storage-2TB","Google-Drive-storage-4TB","Google-Drive-storage-8TB","Google-Drive-storage-16TB","Google-Vault","Google-Vault-Former-Employee","1010020020")]
        [string]
        $License = "Google-Vault-Former-Employee"
    )
    Begin {
        function New-RandomPassword {
            Param (
                [parameter(Mandatory = $false)]
                [int]
                $Length = 15
            )
            $ascii = $null
            for ($a = 33;$a –le 126;$a++) {
                $ascii += ,[char][byte]$a
            }
            for ($loop = 1; $loop –le $length; $loop++) {
                $randomPassword += ($ascii | Get-Random)
            }
            return ([String]$randomPassword)
        }
    }
    Process {
        foreach ($U in $User) {
            Resolve-Email ([ref]$U)
            if ($PSCmdlet.ShouldProcess("Offboarding user: $U")) {
                Write-Verbose "Offboarding user: $U"
                "[$(Get-Date -Format o)] Starting offboard of user: $U"
                $_user = @{User = $U}
                $updateParams = @{Confirm = $false}
                foreach ($opt in $options) {
                    switch -RegEx ($opt) {
                        '(Full|Suspend)' {
                            $updateParams['Suspended'] = $true
                        }
                        '(Full|SetRandomPassword)' {
                            $updateParams['Password'] = ConvertTo-SecureString (New-RandomPassword) -AsPlainText -Force
                            $updateParams['ChangePasswordAtNextLogin'] = $true
                        }
                        '(Full|MoveToOrgUnit)' {
                            if ($PSBoundParameters.ContainsKey('DestinationOrgUnit')) {
                                $updateParams['OrgUnitPath'] = $PSBoundParameters['DestinationOrgUnit']
                            }
                            else {
                                throw "No DestinationOrgUnit provided!! Stopping further processing"
                                exit 1
                            }
                        }
                    }
                }
                "[$(Get-Date -Format o)] [$U] Updating user"
                Update-GSUser @_user @updateParams | Format-List PrimaryEmail,@{N = "FullName";E = {$_.name.fullName}},Suspended,ChangePasswordAtNextLogin,OrgUnitPath
                if ($Options -contains 'Full' -or $Options -contains 'ClearASPs') {
                    "[$(Get-Date -Format o)] [$U] Retrieving App Specific Passwords to remove"
                    $ASPs = Get-GSUserASPList @_user
                    if ($ASPs) {
                        foreach ($ASP in $ASPs) {
                            "[$(Get-Date -Format o)] [$U] Revoking ASP for '$($ASP.name)'"
                            Remove-GSUserASP @_user -CodeID $ASP.codeId -Confirm:$false
                        }
                        Remove-Variable ASPs -ErrorAction SilentlyContinue
                    }
                    else {
                        "[$(Get-Date -Format o)] [$U] User has no ASP's to remove!"
                    }
                }
                if ($Options -contains 'Full' -or $Options -contains 'ClearOAuthTokens') {
                    "[$(Get-Date -Format o)] [$U] Retrieving OAuth Tokens to remove"
                    $Tokens = Get-GSUserTokenList @user
                    if ($Tokens.clientId) {
                        foreach ($Token in $Tokens) {
                            "[$(Get-Date -Format o)] [$U] Revoking OAuth Token for '$($Token.displayText)'"
                            Remove-GSUserToken @user -ClientID $Token.clientId -Confirm:$false
                        }
                        Remove-Variable Tokens -ErrorAction SilentlyContinue
                    }
                    else {
                        "[$(Get-Date -Format o)] [$U] User has no OAuth Tokens to remove!"
                    }
                }
                if ($Options -contains 'Full' -or $Options -contains 'RemoveMobileDevices') {
                    "[$(Get-Date -Format o)] [$U] Retrieving Mobile Devices to remove"
                    $Mobiles = Get-GSMobileDeviceList @user -Projection BASIC
                    if ($Mobiles) {
                        foreach ($Mobile in $Mobiles) {
                            "[$(Get-Date -Format o)] [$U] Removing Mobile Device '$($Mobile.model)'"
                            Remove-GSMobileDevice -ResourceID $Mobile.resourceId -Confirm:$false
                        }
                        Remove-Variable Mobiles -ErrorAction SilentlyContinue
                    }
                    else {
                        "[$(Get-Date -Format o)] [$U] User has no Mobile Devices to remove!"
                    }
                }
                if ($Options -contains 'Full' -or $Options -contains 'SetLicense') {
                    if ($null -ne $License) {
                        "[$(Get-Date -Format o)] [$U] Setting user license to: $License"
                        Set-GSUserLicense @user -License $License | Format-List UserId,ProductId,SkuId
                    }
                }
            }
        }
    }
}
