Function Get-PSGSuiteConfig {
    <#
    .SYNOPSIS
        Gets PSGSuite module configuration.

        Based off of the PSGSuite Configuration functions found in that module:

                https://github.com/RamblingCookieMonster/PSGSuite

    .DESCRIPTION
        Get PSGSuite module configuration

    .PARAMETER Source
        Get the config data from either...
        
            PSGSuite:     the live module variable used for command defaults
            $env:USERNAME-PSGSuite.xml: the serialized PSGSuite.xml that loads when importing the module

        Defaults to PSGSuite

    .PARAMETER Path
        If specified, read config from this XML file.
        
        Defaults to '$env:USERNAME-$env:COMPUTERNAME-$env:PSGSuiteDefaultDomain-PSGSuite.xml' in the module root

    .FUNCTIONALITY
        G Suite
    #>
    [cmdletbinding(DefaultParameterSetName = 'source')]
    param(
        [parameter(ParameterSetName='source')]
        [ValidateSet("PSGSuite","PSGSuite.xml")]
        $Source = "PSGSuite",

        [parameter(ParameterSetName='path')]
        [parameter(ParameterSetName='source')]
        $Path = "$ModuleRoot\$env:USERNAME-$env:COMPUTERNAME-$env:PSGSuiteDefaultDomain-PSGSuite.xml"
    )
    


    if($PSCmdlet.ParameterSetName -eq 'source' -and $Source -eq "PSGSuite" -and -not $PSBoundParameters.ContainsKey('Path'))
        {
        $Script:PSGSuite
        }
    else
        {
        if (Test-Path $Path)
            {
            Write-Verbose "Getting PSGSuite config at: $Path"
            function Decrypt {
                param($String)
                if($String -is [System.Security.SecureString])
                {
                    [System.Runtime.InteropServices.marshal]::PtrToStringAuto(
                        [System.Runtime.InteropServices.marshal]::SecureStringToBSTR(
                            $string))
                }
            }
            Import-Clixml -Path $Path |
                Select -Property @{N='P12KeyPath';E={Decrypt $_.P12KeyPath}},
                    @{N='AppEmail';E={Decrypt $_.AppEmail}},
                    @{N='AdminEmail';E={Decrypt $_.AdminEmail}},
                    @{N='CustomerID';E={Decrypt $_.CustomerID}},
                    @{N='Domain';E={Decrypt $_.Domain}},
                    @{N='Preference';E={Decrypt $_.Preference}},
                    @{N='ServiceAccountClientID';E={Decrypt $_.ServiceAccountClientID}}
            }
        else
            {
            try
                {
                Write-Warning "Did not find config file $Path, attempting to create"
                [pscustomobject]@{
                    P12KeyPath = $null
                    AppEmail = $null
                    AdminEmail = $null
                    CustomerID = $null
                    Domain = $null
                    Preference = $null
                    ServiceAccountClientID = $null
                    } | Export-Clixml -Path $Path -Force -ErrorAction Stop
                }
            catch
                {
                    Write-Warning "Failed to create config file $Path`: $_"
                }
            }
        }
}