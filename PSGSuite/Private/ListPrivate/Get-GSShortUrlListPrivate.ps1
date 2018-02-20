function Get-GSShortUrlListPrivate {
    [cmdletbinding()]
    Param
    (
      [parameter(Mandatory = $false,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
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
        if ($User -ceq 'me') {
            $User = $Script:PSGSuite.AdminEmail
        }
        elseif ($User -notlike "*@*.*") {
            $User = "$($User)@$($Script:PSGSuite.Domain)"
        }
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/urlshortener'
            ServiceType = 'Google.Apis.Urlshortener.v1.UrlshortenerService'
            User        = "$User"
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        try {
            Write-Verbose "Getting Short Url list for User '$User'"
            $request = $service.Url.List()
            $request.Execute() | Select-Object -ExpandProperty Items | Select-Object @{N = "User";E = {$User}},*
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