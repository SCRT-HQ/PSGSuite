function Get-PSGSuiteConfigNames {
    <#
    .SYNOPSIS
    Gets the current config names for tab completion on Switch-PSGSuiteConfig.

    .DESCRIPTION
    Gets the current config names for tab completion on Switch-PSGSuiteConfig.
    #>
    [cmdletbinding()]
    Param ()
    $fullConf = Import-SpecificConfiguration -CompanyName 'SCRT HQ' -Name 'PSGSuite' -Scope $Script:ConfigScope
    $fullConf.Keys | Where-Object {$_ -ne 'DefaultConfig'}
}
