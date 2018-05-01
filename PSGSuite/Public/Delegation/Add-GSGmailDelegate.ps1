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
    if ($Delegate -notlike "*@*.*") {
        $Delegate = "$($Delegate)@$($Script:PSGSuite.Domain)"
    }
    $header = @{
        Authorization = "Bearer $(Get-GSToken -P12KeyPath $Script:PSGSuite.P12KeyPath -Scopes "https://apps-apis.google.com/a/feeds/emailsettings/2.0/" -AppEmail $Script:PSGSuite.AppEmail -AdminEmail $Script:PSGSuite.AdminEmail -Verbose:$false)"
    }
    $URI = [Uri]"https://apps-apis.google.com/a/feeds/emailsettings/2.0/$($Script:PSGSuite.Domain)/$($User -replace "@.*",'')/delegation"
    $body = @"
<?xml version="1.0" encoding="utf-8"?>
<atom:entry xmlns:atom="http://www.w3.org/2005/Atom" xmlns:apps="http://schemas.google.com/apps/2006">
<apps:property name="address" value="$Delegate" />
</atom:entry>
"@
    try {
        $response = Invoke-RestMethod -Method Post -Uri $URI -Headers $header -Body $body -ContentType "application/atom+xml" -Verbose:$false
        Write-Host "Successfully ADDED delegate access for user '$User's inbox for delegate '$Delegate'"
    }
    catch {
        $origError = $_.Exception.Message
        if ($group = Get-GSGroup -Group $User -Verbose:$false -ErrorAction SilentlyContinue) {
            Write-Warning "$User is a group email, not a user account. You can only manage delegate access for a user's inbox. Please add $Delegate to the group $User instead."
        }
        elseif ((Get-GSGmailDelegates -User $User -NoGroupCheck -ErrorAction SilentlyContinue -Verbose:$false).delegationId -contains $Delegate) {
            Write-Warning "'$Delegate' already has delegate access to user '$User's inbox. No action needed."
        }
        else {
            Write-Error $origError
        }
    }
}