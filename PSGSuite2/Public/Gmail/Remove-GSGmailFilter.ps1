function Remove-GSGmailFilter {
    [cmdletbinding(SupportsShouldProcess = $true,ConfirmImpact = "High")]
    Param
    (
        [parameter(Mandatory = $false,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [string]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias("Id")]
        [string[]]
        $FilterId,
        [parameter(Mandatory = $false)]
        [switch]
        $Raw
    )
    Begin {
        if ($User -ceq 'me') {
            $User = $Script:PSGSuite.AdminEmail
        }
        elseif ($User -notlike "*@*.*") {
            $User = "$($User)@$($Script:PSGSuite.Domain)"
        }
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/gmail.settings.basic'
            ServiceType = 'Google.Apis.Gmail.v1.GmailService'
            User        = $User
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        try {
            foreach ($fil in $FilterId) {
                if ($PSCmdlet.ShouldProcess("Deleting Filter Id '$fil' from user '$User'")) {
                    Write-Verbose "Deleting Filter Id '$fil' from user '$User'"
                    $request = $service.Users.Settings.Filters.Delete($User,$fil)
                    $request.Execute()
                    Write-Verbose "Filter Id '$fil' deleted successfully from user '$User'"
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}