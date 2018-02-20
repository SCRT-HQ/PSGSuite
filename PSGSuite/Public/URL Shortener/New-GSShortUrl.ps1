function New-GSShortUrl {
    <#
    .SYNOPSIS
    Creates a new Short Url
    
    .DESCRIPTION
    Creates a new Short Url
    
    .PARAMETER LongUrl
    The full Url to shorten
    
    .PARAMETER User
    The user to create the Short Url for

    Defaults to the AdminEmail user
    
    .EXAMPLE
    New-GSShortUrl "http://ferrell.io"

    Creates a new Short Url pointing at http://ferrell.io/
    #>
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true)]
        [String[]]
        $LongUrl,
        [parameter(Mandatory = $false,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [String]
        $User = $Script:PSGSuite.AdminEmail
    )
    Begin {
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
    Process {
        try {
            foreach ($L in $LongUrl) {
                Write-Verbose "Creating short Url for '$L'"
                $body = New-Object 'Google.Apis.Urlshortener.v1.Data.Url' -Property @{
                    LongUrl = $L
                }
                $request = $service.Url.Insert($body)
                $request.Execute() | Select-Object @{N = "User";E = {$User}},*
            }
        }
        catch {
            if ($ErrorActionPreference -eq 'Stop') {
                $PSCmdlet.ThrowTerminatingError($_)
            }
            else {
                Write-Error $_
            }
        }
    }
}