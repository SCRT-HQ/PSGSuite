function Get-PSGSuiteConfigNames {
    <#
    .SYNOPSIS
    Gets the current config names for tab completion on Switch-PSGSuiteConfig.

    .DESCRIPTION
    Gets the current config names for tab completion on Switch-PSGSuiteConfig.
    #>
    [cmdletbinding()]
    Param ()
    $script:ConfigScope = $Scope
    $fullConf = Import-SpecificConfiguration -CompanyName 'SCRT HQ' -Name 'PSGSuite' -Scope $Script:ConfigScope
    $fullConf.Keys | Where-Object {$_ -ne 'DefaultConfig'}
}
