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
    if ($Delegate -notlike "*@*.*") {
        $Delegate = "$($Delegate)@$($Script:PSGSuite.Domain)"
    }
    $header = @{
        Authorization = "Bearer $(Get-GSToken -P12KeyPath $Script:PSGSuite.P12KeyPath -Scopes "https://apps-apis.google.com/a/feeds/emailsettings/2.0/" -AppEmail $Script:PSGSuite.AppEmail -AdminEmail $Script:PSGSuite.AdminEmail -Verbose:$false)"
    }
    $URI = [Uri]"https://apps-apis.google.com/a/feeds/emailsettings/2.0/$($Script:PSGSuite.Domain)/$($User -replace "@.*",'')/delegation/$($Delegate)"
    if ($PSCmdlet.ShouldProcess("Removing delegate access for '$Delegate' from user '$User's inbox")) {
        try {
            Write-Verbose "Removing delegate access for '$Delegate' from user '$User's inbox"
            $response = Invoke-RestMethod -Method Delete -Uri $URI -Headers $header -ContentType "application/atom+xml" -Verbose:$false
            if (!$response) {
                Write-Host "Successfully REMOVED delegate access for user '$User's inbox for delegate '$Delegate'"
            }
            else {
                return $response
            }
        }
        catch {
            $origError = $_.Exception.Message
            if ($group = Get-GSGroup -Group $User -Verbose:$false -ErrorAction SilentlyContinue) {
                Write-Warning "$User is a group email, not a user account. You can only manage delegate access to a user's inbox. Please remove $Delegate from the group $User instead."
            }
            elseif ((Get-GSGmailDelegates -User $User -NoGroupCheck -ErrorAction SilentlyContinue -Verbose:$false).delegationId -notcontains $Delegate) {
                Write-Warning "'$Delegate' does not currently have delegate access to user '$User's inbox. No action needed."
            }
            else {
                Write-Error $origError
            }
        }
    }
}