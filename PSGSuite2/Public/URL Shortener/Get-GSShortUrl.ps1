function Get-GSShortUrl {
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
                Get-GSShortUrlList
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}