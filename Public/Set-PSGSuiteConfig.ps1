function Set-PSGSuiteConfig {
    <#
    .SYNOPSIS
        Sets PSGSuite module configuration. 
        
        Based off of the PSSlack Configuration functions found in that module:

                https://github.com/RamblingCookieMonster/PSSlack

    .DESCRIPTION
        Set PSGSuite module configuration, and $PSGSuite module variable.

        This data is used as the default info for the Get-GSToken function to get and access token.

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
        If specified, save config file to this file path.  Defaults to "$ModuleRoot\$env:USERNAME-$env:COMPUTERNAME-$env:PSGSuiteDefaultDomain-PSGSuite.xml"

    .PARAMETER Preference
        Preference of either Domain or CustomerID where either or is an option

    .FUNCTIONALITY
        Google Apps
    #>
    [cmdletbinding()]
    param(
        [string]$P12KeyPath,
        [string]$AppEmail,
        [string]$AdminEmail,
        [string]$CustomerID,
        [string]$Domain,
        [string]$Path = "$ModuleRoot\$env:USERNAME-$env:COMPUTERNAME-$env:PSGSuiteDefaultDomain-PSGSuite.xml",
        [ValidateSet("Domain","CustomerID")]
        [string]$Preference="CustomerID",
        [string]$ServiceAccountClientID
    )
    if ($env:PSGSuiteDefaultDomain -eq "Default" -and $Domain -ne "Default" -and ![string]::IsNullOrWhiteSpace($Domain))
        {
        Set-PSGSuiteDefaultDomain -Domain $Domain
        if ($Path -eq "$ModuleRoot\$env:USERNAME-$env:COMPUTERNAME-Default-PSGSuite.xml")
            {
            $Path = "$ModuleRoot\$env:USERNAME-$env:COMPUTERNAME-$env:PSGSuiteDefaultDomain-PSGSuite.xml"
            }
        Write-Verbose "Cleaning up the default config: '$ModuleRoot\$env:USERNAME-$env:COMPUTERNAME-Default-PSGSuite.xml'"
        Remove-Item "$ModuleRoot\$env:USERNAME-$env:COMPUTERNAME-Default-PSGSuite.xml" -Force
        }
    if (!$Script:PSGSuite)
        {
        $Script:PSGSuite = [pscustomobject][ordered]@{
            P12KeyPath = $null
            AppEmail = $null
            AdminEmail = $null
            CustomerID = $null
            Domain = $null
            Preference = $null
            ServiceAccountClientID = $null
            }
        }
    Switch ($PSBoundParameters.Keys)
    {
        'P12KeyPath'{$Script:PSGSuite.P12KeyPath = $P12KeyPath}
        'AppEmail'{$Script:PSGSuite.AppEmail = $AppEmail}
        'AdminEmail'{$Script:PSGSuite.AdminEmail = $AdminEmail}
        'CustomerID'{$Script:PSGSuite.CustomerID = $CustomerID}
        'Domain'{$Script:PSGSuite.Domain = $Domain}
        'Preference'{$Script:PSGSuite.Preference = $Preference}
        'ServiceAccountClientID'{$Script:PSGSuite.ServiceAccountClientID = $ServiceAccountClientID}
    }

    Function Encrypt {
        param([string]$string)
        if($String -notlike '')
        {
            ConvertTo-SecureString -String $string -AsPlainText -Force
        }
    }
    Write-Verbose "Setting PSGSuite config at: $Path"
    #Write the global variable and the xml
    $Script:PSGSuite |
        Select -Property @{N='P12KeyPath';E={Encrypt $_.P12KeyPath}},
            @{N='AppEmail';E={Encrypt $_.AppEmail}},
            @{N='AdminEmail';E={Encrypt $_.AdminEmail}},
            @{N='CustomerID';E={Encrypt $_.CustomerID}},
            @{N='Domain';E={Encrypt $_.Domain}},
            @{N='Preference';E={Encrypt $_.Preference}},
            @{N='ServiceAccountClientID';E={Encrypt $_.ServiceAccountClientID}} |
        Export-Clixml -Path $Path -Force

}