function Get-GSGmailLabel {
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [string]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [Alias("Id")]
        [string[]]
        $LabelId
    )
    Begin {
        if ($User -ceq 'me') {
            $User = $Script:PSGSuite.AdminEmail
        }
        elseif ($User -notlike "*@*.*") {
            $User = "$($User)@$($Script:PSGSuite.Domain)"
        }
        $serviceParams = @{
            Scope       = 'https://mail.google.com'
            ServiceType = 'Google.Apis.Gmail.v1.GmailService'
            User        = $User
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        try {
            if ($LabelId) {
                foreach ($label in $LabelId) {
                    $request = $service.Users.Labels.Get($User,$label)
                    Write-Verbose "Getting Label Id '$label' for user '$User'"
                    $request.Execute() | Select-Object @{N = 'User';E = {$User}},*
                }
            }
            else {
                $request = $service.Users.Labels.List($User)
                Write-Verbose "Getting Label List for user '$User'"
                $request.Execute() | Select-Object -ExpandProperty Labels | Select-Object @{N = 'User';E = {$User}},*
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}