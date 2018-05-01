function Get-GSGmailDelegates {
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false,Position = 0)]
        [Alias("Delegator")]
        [ValidateNotNullOrEmpty()]
        [String]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false)]
        [switch]
        $Raw,
        [parameter(Mandatory = $false)]
        [switch]
        $NoGroupCheck
    )
    if ($User -ceq 'me') {
        $User = $Script:PSGSuite.AdminEmail
    }
    elseif ($User -notlike "*@*.*") {
        $User = "$($User)@$($Script:PSGSuite.Domain)"
    }
    $header = @{
        Authorization = "Bearer $(Get-GSToken -P12KeyPath $Script:PSGSuite.P12KeyPath -Scopes "https://apps-apis.google.com/a/feeds/emailsettings/2.0/" -AppEmail $Script:PSGSuite.AppEmail -AdminEmail $Script:PSGSuite.AdminEmail -Verbose:$false)"
    }
    Write-Verbose "Getting Gmail Delegates for user '$User'"
    $URI = [Uri]"https://apps-apis.google.com/a/feeds/emailsettings/2.0/$($Script:PSGSuite.Domain)/$($User -replace "@.*",'')/delegation"
    try {
        $response = Invoke-RestMethod -Method Get -Uri $URI -Headers $header -ContentType "application/atom+xml" -Verbose:$false
        if (!$response) {
            Write-Warning "No delegates found for user '$User'"
        }
        elseif (!$Raw) {
            $result = @()
            foreach ($dele in $response) {
                $deleObj = New-Object psobject
                $deleObj | Add-Member -MemberType NoteProperty -Name delegator -Value $User
                for ($i = 0;$i -lt $dele.property.length;$i++) {
                    $deleObj | Add-Member -MemberType NoteProperty -Name $dele.property[$i].name -Value $dele.property[$i].value
                }
                $result += $deleObj
                Remove-Variable deleObj -ErrorAction SilentlyContinue
            }
            return $result
        }
        else {
            return $response
        }
    }
    catch {
        $origError = $_.Exception.Message
        if (!$NoGroupCheck -and ($group = Get-GSGroup -Group $User -Verbose:$false -ErrorAction SilentlyContinue)) {
            Write-Warning "$User is a group, not a user. You can only manage delegates for a user."
        }
        else {
            Write-Error $origError
        }
    }
}