function Show-PSGSuiteConfig {
    <#
    .SYNOPSIS
    Returns the currently loaded config
    
    .DESCRIPTION
    Returns the currently loaded config
    
    .EXAMPLE
    Show-PSGSuiteConfig
    #>
    [CmdletBinding()]
    Param()
    Write-Verbose "Showing current PSGSuite config"
    $script:PSGSuite
}