function Get-GSShortUrlListPrivate {
    [cmdletbinding()]
    Param
    (
      [parameter(Mandatory = $false,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
      [Alias("PrimaryEmail","UserKey","Mail","Email")]
      [ValidateNotNullOrEmpty()]
      [String[]]
      $User = $Script:PSGSuite.AdminEmail,
      [parameter(Mandatory=$false)]
      [ValidateSet("Full","Analytics_Clicks")]
      [string]
      $Projection = "Full",
      [parameter(Mandatory = $false)]
      [Alias('Profile','ProfileName')]
      [String]
      $ConfigName
    )
    Process {
        foreach ($U in $User) {
            if ($U -ceq 'me') {
                $U = $Script:PSGSuite.AdminEmail
            }
            elseif ($U -notlike "*@*.*") {
                $U = "$($U)@$($Script:PSGSuite.Domain)"
            }
            $serviceParams = @{
                Scope       = 'https://www.googleapis.com/auth/urlshortener'
                ServiceType = 'Google.Apis.Urlshortener.v1.UrlshortenerService'
                User        = "$U"
            }
            $service = New-GoogleService @serviceParams
            try {
                Write-Verbose "Getting Short Url list for User '$U'"
                $request = $service.Url.List()
                $request.Execute() | Select-Object -ExpandProperty Items | Add-Member -MemberType NoteProperty -Name 'User' -Value $U -PassThru
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
}