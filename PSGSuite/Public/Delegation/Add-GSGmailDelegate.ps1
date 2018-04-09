function Add-GSGmailDelegate {
    [cmdletbinding()]
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
    $URI = [Uri]"https://apps-apis.google.com/a/feeds/emailsettings/2.0/$($Script:PSGSuite.Domain)/$($User -replace "@$($Script:PSGSuite.Domain)",'')/delegation"
    $body = @"
<?xml version="1.0" encoding="utf-8"?>
<atom:entry xmlns:atom="http://www.w3.org/2005/Atom" xmlns:apps="http://schemas.google.com/apps/2006">
<apps:property name="address" value="$Delegate" />
</atom:entry>
"@
    try {
        $response = Invoke-RestMethod -Method Post -Uri $URI -Headers $header -Body $body -ContentType "application/atom+xml"
        if ($response) {
            Write-Verbose "Delegate access for $User's inbox added for $Delegate"
        }
        else {
            return $response
        }
    }
    catch {
        Write-Error $_.Exception.Message
    }
}