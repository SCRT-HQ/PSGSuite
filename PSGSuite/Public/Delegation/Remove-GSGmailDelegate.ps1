function Remove-GSGmailDelegate {
    [cmdletbinding(SupportsShouldProcess = $true,ConfirmImpact = "High")]
    Param
    (
        [parameter(Mandatory = $true,Position = 0)]
        [Alias("From","Delegator")]
        [ValidateNotNullOrEmpty()]
        [String]
        $User,
        [parameter(Mandatory = $true,Position = 1)]
        [Alias("To")]
        [ValidateNotNullOrEmpty()]
        [String]
        $Delegate
    )
    if ($User -ceq 'me') {
        $User = $Script:PSGSuite.AdminEmail
    }
    elseif ($User -notlike "*@*.*") {
        $User = "$($User)@$($Script:PSGSuite.Domain)"
    }
    $header = @{
        Authorization = "Bearer $(Get-GSToken -P12KeyPath $Script:PSGSuite.P12KeyPath -Scopes "https://apps-apis.google.com/a/feeds/emailsettings/2.0/" -AppEmail $Script:PSGSuite.AppEmail -AdminEmail $Script:PSGSuite.AdminEmail)"
    }
    $URI = [URI]"https://apps-apis.google.com/a/feeds/emailsettings/2.0/$($Script:PSGSuite.Domain)/$($User -replace "@$($Script:PSGSuite.Domain)",'')/delegation/$Delegate"
    if ($PSCmdlet.ShouldProcess($Delegate)) {
        try {
            $response = Invoke-RestMethod -Method Delete -Uri $URI -Headers $header -ContentType "application/atom+xml"
            if (!$response) {
                Write-Verbose "Delegate access for $User's inbox removed for $Delegate"
            }
            else {
                return $response
            }
        }
        catch {
            Write-Error $_.Exception.Message
        }
    }
}