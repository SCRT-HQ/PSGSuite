function Sync-GSUserCache {
    <#
    .SYNOPSIS
    Syncs your GS Users to a hashtable contained in the global scoped variable $global:GSUserCache for fast lookups in scripts.

    .DESCRIPTION
    Syncs your GS Users to a hashtable contained in the global scoped variable $global:GSUserCache for fast lookups in scripts.

    .PARAMETER Filter
    The filter to use with Get-GSUser to populate your UserCache with.

    Defaults to * (all users).

    If you'd like to limit to just Active (not suspended) users, use the following filter:

        "IsSuspended -eq '$false'"

    .PARAMETER Keys
    The user properties to use as keys in the Cache hash.

    Available values are:
    * PrimaryEmail
    * Id
    * Alias

    Defaults to all 3.

    .PARAMETER PassThru
    If $true, returns the hashtable as output

    .EXAMPLE
    Sync-GSUserCache -Filter 'IsSuspended=False'

    Fills the $global:GSUserCache hashtable with all active users using the default Keys.
    #>
    [CmdLetBinding()]
    Param (
        [parameter(Mandatory = $false, Position = 0)]
        [String[]]
        $Filter = @('*'),
        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('PrimaryEmail','Id','Alias')]
        [String[]]
        $Keys = @('PrimaryEmail','Id','Alias'),
        [parameter(Mandatory = $false)]
        [Switch]
        $PassThru
    )
    Begin {
        $global:GSUserCache = @{}
    }
    Process {
        Get-GSUser -Filter $Filter | ForEach-Object {
            if ($Keys -contains 'Id') {
                $global:GSUserCache[$_.Id] = $_
            }
            if ($Keys -contains 'PrimaryEmail') {
                $global:GSUserCache[$_.PrimaryEmail] = $_
            }
            if ($Keys -contains 'Alias') {
                foreach ($email in $_.Emails.Address) {
                    if (-not ($global:GSUserCache.ContainsKey($email))) {
                        $global:GSUserCache[$email] = $_
                    }
                }
            }
        }
    }
    End {
        if ($PassThru) {
            return $global:GSUserCache
        }
    }
}
