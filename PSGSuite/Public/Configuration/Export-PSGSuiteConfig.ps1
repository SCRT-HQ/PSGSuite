function Export-PSGSuiteConfig {
    <#
    .SYNOPSIS
    Allows you to export an unecrypted PSGSuite config in a portable JSON string format. Useful for moving a config to a new machine or storing the full as an encrypted string in your CI/CD / Automation tools.

    .DESCRIPTION
    Allows you to export an unecrypted PSGSuite config in a portable JSON string format. Useful for moving a config to a new machine or storing the full as an encrypted string in your CI/CD / Automation tools.

    .PARAMETER Path
    The path you would like to save the JSON file to. Defaults to a named path in the current directory.

    .PARAMETER ConfigName
    The config that you would like to export. Defaults to the currently loaded config.

    .EXAMPLE
    Export-PSGSuiteConfig -ConfigName Personal -Path ".\PSGSuite_personal_config.json"

    Exports the config named 'Personal' to the path specified.
    #>
    [CmdletBinding()]
    Param (
        [parameter(Mandatory = $false,Position = 0)]
        [Alias('OutPath','OutFile','JsonPath')]
        [String]
        $Path,
        [parameter(Mandatory = $false)]
        [String]
        $ConfigName = $script:PSGSuite.ConfigName
    )
    Begin {
        $baseConf = if ($PSBoundParameters.Keys -contains 'ConfigName'){
            Get-PSGSuiteConfig -ConfigName $ConfigName -NoImport -PassThru -Verbose:$false
        }
        else {
            Show-PSGSuiteConfig -Verbose:$false
        }
        if ($PSBoundParameters.Keys -notcontains 'Path') {
            $Path = (Join-Path $PWD.Path "PSGSuite_$($baseConf.AdminEmail)_$($baseConf.ConfigName).json")
        }
    }
    Process {
        try {
            Write-Verbose "Exporting config '$ConfigName' to path: $Path"
            $baseConf | Select-Object ConfigName,P12Key,ClientSecrets,AppEmail,AdminEmail,CustomerId,Domain,Preference | ConvertTo-Json -Depth 5 -Compress -Verbose:$false | Set-Content -Path $Path -Verbose:$false
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}
