function Get-GSShortUrl {
    <#
    .SYNOPSIS
    Gets information about a user's Short Url's created at https://goo.gl/
    
    .DESCRIPTION
    Gets information about a user's Short Url's created at https://goo.gl/
    
    .PARAMETER ShortUrl
    The Short Url to return information for. If excluded, returns the list of the user's Short Url's
    
    .PARAMETER User
    The primary email of the user you would like to retrieve Short Url information for

    Defaults to the AdminEmail user
    
    .PARAMETER Projection
    	Additional information to return. 

    Acceptable values are:
    * "ANALYTICS_CLICKS" - Returns short URL click counts.
    * "FULL" - Returns short URL click counts.
    
    .EXAMPLE
    Get-GSShortUrl

    Gets the Short Url list of the AdminEmail user
    #>
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [Alias('Id')]
        [String[]]
        $ShortUrl,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory=$false)]
        [ValidateSet("Full","Analytics_Clicks")]
        [string]
        $Projection = "Full"
    )
    Begin {
        if ($ShortUrl) {
            if ($User -ceq 'me') {
                $User = $Script:PSGSuite.AdminEmail
            }
            elseif ($User -notlike "*@*.*") {
                $User = "$($U)@$($Script:PSGSuite.Domain)"
            }
            $serviceParams = @{
                Scope       = 'https://www.googleapis.com/auth/urlshortener'
                ServiceType = 'Google.Apis.Urlshortener.v1.UrlshortenerService'
                User        = $User
            }
            $service = New-GoogleService @serviceParams
        }
    }
    Process {
        try {
            if ($ShortUrl) {
                foreach ($S in $ShortUrl) {
                    Write-Verbose "Getting short Url '$S'"
                    $request = $service.Url.Get($S)
                    $request.Execute() | Select-Object @{N = "User";E = {$User}},*
                }
            }
            else {
                Get-GSShortUrlListPrivate @PSBoundParameters
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}