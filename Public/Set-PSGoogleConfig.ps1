function Set-PSGoogleConfig {
    <#
    .SYNOPSIS
        Sets PSGoogle module configuration. 
        
        Based off of the PSSlack Configuration functions found in that module:

                https://github.com/RamblingCookieMonster/PSSlack

    .DESCRIPTION
        Set PSGoogle module configuration, and $PSGoogle module variable.

        This data is used as the default info for the Get-GoogToken function to get and access token.

        If a command takes either a token or a uri, tokens take precedence.

        WARNING: Use this to store the token or uri on a filesystem at your own risk.
                 We use the DPAPI to store this.

    .PARAMETER P12KeyPath
        Specify the path to your service account's P12 Key

        Encrypted with the DPAPI

    .PARAMETER Scopes
        Specify the default scopes to use

    .PARAMETER AppEmail
        The service account's email address

        Encrypted with the DPAPI

    .PARAMETER AdminEmail
        The admin being impersonated's email address

        Encrypted with the DPAPI

    .PARAMETER CustomerID
        The CustomerID for the account. Used where applicable.

        Encrypted with the DPAPI

    .PARAMETER Domain
        The domain name for the account. Used where applicable.

        Encrypted with the DPAPI

    .PARAMETER Path
        If specified, save config file to this file path.  Defaults to "$env:USERNAME-PSGoogle.xml" in the module root.

    .PARAMETER Preference
        Preference of either Domain or CustomerID where either or is an option

    .FUNCTIONALITY
        Google Apps
    #>
    [cmdletbinding()]
    param(
        [string]$P12KeyPath,
        [string[]]$Scopes,
        [string]$AppEmail,
        [string]$AdminEmail,
        [string]$CustomerID,
        [string]$Domain,
        [string]$Path = "$ModuleRoot\$env:USERNAME-$env:COMPUTERNAME-PSGoogle.xml",
        [ValidateSet("Domain","CustomerID")]
        [string]$Preference="CustomerID"
    )

    Switch ($PSBoundParameters.Keys)
    {
        'P12KeyPath'{$Script:PSGoogle.P12KeyPath = $P12KeyPath}
        'Scopes'{$Script:PSGoogle.Scopes = $Scopes -join ","}
        'AppEmail'{$Script:PSGoogle.AppEmail = $AppEmail}
        'AdminEmail'{$Script:PSGoogle.AdminEmail = $AdminEmail}
        'CustomerID'{$Script:PSGoogle.CustomerID = $CustomerID}
        'Domain'{$Script:PSGoogle.Domain = $Domain}
        'Preference'{$Script:PSGoogle.Preference = $Preference}
    }

    Function Encrypt {
        param([string]$string)
        if($String -notlike '')
        {
            ConvertTo-SecureString -String $string -AsPlainText -Force
        }
    }

    #Write the global variable and the xml
    $Script:PSGoogle |
        Select -Property @{N='P12KeyPath';E={Encrypt $_.P12KeyPath}},
            @{N='Scopes';E={Encrypt $_.Scopes}},
            @{N='AppEmail';E={Encrypt $_.AppEmail}},
            @{N='AdminEmail';E={Encrypt $_.AdminEmail}},
            @{N='CustomerID';E={Encrypt $_.CustomerID}},
            @{N='Domain';E={Encrypt $_.Domain}},
            @{N='Preference';E={Encrypt $_.Preference}} |
        Export-Clixml -Path $Path -Force

}