function Clear-PSGSuiteServiceCache {
    <#
    .SYNOPSIS
    Clears the dictionary of cached service objects created with New-GoogleService.

    .DESCRIPTION
    Clears the dictionary of cached service objects created with New-GoogleService.

    .EXAMPLE
    Clear-PSGSuiteServiceCache
    #>
    [CmdletBinding()]
    Param ()
    Begin{
        if (-not $script:_PSGSuiteSessions) {
            $script:_PSGSuiteSessions = @{}
        }
        $toRemove = @()
    }
    Process {
        if (-not $script:_PSGSuiteSessions.Keys.Count) {
            Write-Verbose "There are no current cached sessions to clear!"
        }
        else {
            foreach ($key in $script:_PSGSuiteSessions.Keys) {
                Write-Verbose "Clearing cached session with key: $key"
                $script:_PSGSuiteSessions[$key].Service.Dispose()
                $toRemove += $key
            }
        }
    }
    End {
        foreach ($key in $toRemove) {
            $script:_PSGSuiteSessions.Remove($key)
        }
    }
}
