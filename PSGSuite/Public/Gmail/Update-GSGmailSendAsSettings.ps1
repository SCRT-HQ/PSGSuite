function Update-GSGmailSendAsSettings {
    <#
    .SYNOPSIS
    Updates SendAs settings.

    .DESCRIPTION
    Updates SendAs settings.

    .PARAMETER User
    The user to update the SendAs settings for.

    .PARAMETER SendAsEmail
    The SendAs alias to be updated.

    .PARAMETER DisplayName
    A name that appears in the "From:" header for mail sent using this alias.

    For custom "from" addresses, when this is empty, Gmail will populate the "From:" header with the name that is used for the primary address associated with the account.

    If the admin has disabled the ability for users to update their name format, requests to update this field for the primary login will silently fail.

    .PARAMETER IsDefault
    Whether this address is selected as the default "From:" address in situations such as composing a new message or sending a vacation auto-reply.

    Every Gmail account has exactly one default send-as address, so the only legal value that clients may write to this field is true.

    Changing this from false to true for an address will result in this field becoming false for the other previous default address.

    .PARAMETER ReplyToAddress
    An optional email address that is included in a "Reply-To:" header for mail sent using this alias.

    If this is empty, Gmail will not generate a "Reply-To:" header.

    .PARAMETER Signature
    An optional HTML signature that is included in messages composed with this alias in the Gmail web UI.

    .PARAMETER SmtpMsa
    An optional SMTP service that will be used as an outbound relay for mail sent using this alias.

    If this is empty, outbound mail will be sent directly from Gmail's servers to the destination SMTP service. This setting only applies to custom "from" aliases.

    Use the helper function Add-GmailSmtpMsa to create the correct object for this parameter.

    .PARAMETER TreatAsAlias
    Whether Gmail should treat this address as an alias for the user's primary email address.

    This setting only applies to custom "from" aliases.

    .EXAMPLE
    $smtpMsa = Add-GSGmailSmtpMsa -Host 10.0.30.18 -Port 3770 -SecurityMode none -Username mailadmin -Password $(ConvertTo-SecureString $password -AsPlainText -Force)
    Update-GSGmailSendAsSettings -SendAsEmail joseph.wiggum@business.com -User joe@domain.com -Signature "<div>Thank you for your time,</br>Joseph Wiggum</div>" -SmtpMsa $smtpMsa

    Updates Joe's SendAs settings for his formal alias, including signature and SmtpMsa settings.
    #>
    [OutputType('Google.Apis.Gmail.v1.Data.SendAs')]
    [cmdletbinding()]
    Param (
        [parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [string]
        $User,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [string]
        $SendAsEmail,
        [parameter(Mandatory = $false)]
        [string]
        $DisplayName,
        [parameter(Mandatory = $false)]
        [switch]
        $IsDefault,
        [parameter(Mandatory = $false)]
        [string]
        $ReplyToAddress,
        [parameter(Mandatory = $false)]
        [string]
        $Signature,
        [parameter(Mandatory = $false)]
        [Google.Apis.Gmail.v1.Data.SmtpMsa]
        $SmtpMsa,
        [parameter(Mandatory = $false)]
        [switch]
        $TreatAsAlias
    )
    Process {
        if ($User -ceq 'me') {
            $User = $Script:PSGSuite.AdminEmail
        }
        elseif ($User -notlike "*@*.*") {
            $User = "$($User)@$($Script:PSGSuite.Domain)"
        }
        if (-not $PSBoundParameters.ContainsKey('SendAsEmail')) {
            $SendAsEmail = $User
        }
        elseif ($SendAsEmail -notlike "*@*.*") {
            $SendAsEmail = "$($SendAsEmail)@$($Script:PSGSuite.Domain)"
        }
        $serviceParams = @{
            Scope       = @(
                'https://www.googleapis.com/auth/gmail.settings.sharing',
                'https://www.googleapis.com/auth/gmail.settings.basic'
            )
            ServiceType = 'Google.Apis.Gmail.v1.GmailService'
            User        = $User
        }
        $service = New-GoogleService @serviceParams
        try {
            $body = New-Object 'Google.Apis.Gmail.v1.Data.SendAs'
            foreach ($prop in $PSBoundParameters.Keys | Where-Object {$body.PSObject.Properties.Name -contains $_}) {
                $body.$prop = $PSBoundParameters[$prop]
            }
            $request = $service.Users.Settings.SendAs.Patch($body,$User,$SendAsEmail)
            Write-Verbose "Updating SendAs settings of alias '$SendAsEmail' for user '$User'"
            $request.Execute() | Add-Member -MemberType NoteProperty -Name 'User' -Value $User -PassThru
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
