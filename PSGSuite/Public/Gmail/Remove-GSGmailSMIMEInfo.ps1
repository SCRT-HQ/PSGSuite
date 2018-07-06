function Remove-GSGmailSMIMEInfo {
    <#
    .SYNOPSIS
    Removes Gmail S/MIME info
    
    .DESCRIPTION
    Removes Gmail S/MIME info
    
    .PARAMETER SendAsEmail
    The email address that appears in the "From:" header for mail sent using this alias.
    
    .PARAMETER Id
    The immutable ID for the SmimeInfo
    
    .PARAMETER User
    The user's email address

    Defaults to the AdminEmail user
    
    .EXAMPLE
    Remove-GSGmailSMIMEInfo -SendAsEmail 'joe@otherdomain.com' -Id 1008396210820120578939 -User joe@domain.com

    Rmoves the specified S/MIME info for Joe's SendAsEmail 'joe@otherdomain.com'
    #>
    [cmdletbinding(SupportsShouldProcess = $true,ConfirmImpact = "High")]
    Param
    (
        [parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true)]
        [string]
        $SendAsEmail,
        [parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true)]
        [string[]]
        $Id,
        [parameter(Mandatory = $false)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [string]
        $User = $Script:PSGSuite.AdminEmail
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
        foreach ($I in $Id) {
            try {
                if ($PSCmdlet.ShouldProcess("Removing S/MIME Id '$I' of SendAsEmail '$SendAsEmail' for user '$User'")) {
                    $request = $service.Users.Settings.SendAs.SmimeInfo.Delete($User,$SendAsEmail,$I)
                    $request.Execute()
                    Write-Verbose "Successfully removed S/MIME Id '$I' of SendAsEmail '$SendAsEmail' for user '$User'"
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
}