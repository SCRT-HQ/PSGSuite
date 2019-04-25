function Get-PSGSuiteServiceCache {
    <#
    .SYNOPSIS
    Returns the dictionary of cached service objects created with New-GoogleService for inspection.

    .DESCRIPTION
    Returns the dictionary of cached service objects created with New-GoogleService for inspection.

    The keys in the session cache dictionary are comprised of the following values which are added to the cache whenever a new session is created:

        $SessionKey = @($User,$ServiceType,$(($Scope | Sort-Object) -join ";")) -join ";"

    .PARAMETER IncludeKeys
    If $true, returns the full service cache dictionary including keys.

    Defaults to $false.

    .EXAMPLE
    Get-PSGSuiteServiceCache
    #>
    [CmdletBinding()]
    Param (
        [parameter(Mandatory = $false,Position = 0)]
        [Switch]
        $IncludeKeys
    )
    Begin{
        if (-not $script:_PSGSuiteSessions) {
            $script:_PSGSuiteSessions = @{}
        }
    }
    Process {
        Write-Verbose "Getting cached session list"
        if ($IncludeKeys) {
            $script:_PSGSuiteSessions
        }
        else {
            $script:_PSGSuiteSessions.Values
        }
    }
}
