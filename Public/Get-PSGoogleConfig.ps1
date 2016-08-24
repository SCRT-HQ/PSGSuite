Function Get-PSGoogleConfig {
    <#
    .SYNOPSIS
        Gets PSGoogle module configuration.

        Based off of the PSGoogle Configuration functions found in that module:

                https://github.com/RamblingCookieMonster/PSGoogle

    .DESCRIPTION
        Get PSGoogle module configuration

    .PARAMETER Source
        Get the config data from either...
        
            PSGoogle:     the live module variable used for command defaults
            $env:USERNAME-PSGoogle.xml: the serialized PSGoogle.xml that loads when importing the module

        Defaults to PSGoogle

    .PARAMETER Path
        If specified, read config from this XML file.
        
        Defaults to $env:USERNAME-PSGoogle.xml in the module root

    .FUNCTIONALITY
        Google Apps
    #>
    [cmdletbinding(DefaultParameterSetName = 'source')]
    param(
        [parameter(ParameterSetName='source')]
        [ValidateSet("PSGoogle","PSGoogle.xml")]
        $Source = "PSGoogle",

        [parameter(ParameterSetName='path')]
        [parameter(ParameterSetName='source')]
        $Path = "$ModuleRoot\$env:USERNAME-PSGoogle.xml"
    )
    
    if($PSCmdlet.ParameterSetName -eq 'source' -and $Source -eq "PSGoogle" -and -not $PSBoundParameters.ContainsKey('Path'))
    {
        $Script:PSGoogle
    }
    else
    {
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
                @{N='Scopes';E={@((Decrypt $_.Scopes) -split ",")}},
                @{N='AppEmail';E={Decrypt $_.AppEmail}},
                @{N='AdminEmail';E={Decrypt $_.AdminEmail}},
                @{N='CustomerID';E={Decrypt $_.CustomerID}},
                @{N='Domain';E={Decrypt $_.Domain}},
                @{N='Preference';E={Encrypt $_.Preference}}
    }

}