function Add-GSGmailSmtpMsa {
    <#
    .SYNOPSIS
    Builds a SmtpMsa object to use when creating or updating SmtpMsa settings withing the Gmail SendAs settings.

    .DESCRIPTION
    Builds a SmtpMsa object to use when creating or updating SmtpMsa settings withing the Gmail SendAs settings.

    .PARAMETER HostName
    The hostname of the SMTP service.

    .PARAMETER Port
    The port of the SMTP service.

    .PARAMETER SecurityMode
    The protocol that will be used to secure communication with the SMTP service.

    Acceptable values are:
    * "none"
    * "securityModeUnspecified"
    * "ssl"
    * "starttls"

    .PARAMETER Username
    The username that will be used for authentication with the SMTP service.

    This is a write-only field that can be specified in requests to create or update SendAs settings; it is never populated in responses.

    .PARAMETER Password
    The password that will be used for authentication with the SMTP service.

    This is a write-only field that can be specified in requests to create or update SendAs settings; it is never populated in responses.

    .PARAMETER TreatAsAlias
    Whether Gmail should treat this address as an alias for the user's primary email address. This setting only applies to custom "from" aliases.

    .PARAMETER InputObject
    Used for pipeline input of an existing UserAddress object to strip the extra attributes and prevent errors

    .EXAMPLE
    $smtpMsa = Add-GSGmailSmtpMsa -Host 10.0.30.18 -Port 3770 -SecurityMode none -Username mailadmin -Password $(ConvertTo-SecureString $password -AsPlainText -Force)
    Update-GSGmailSendAsSettings -SendAsEmail joseph.wiggum@business.com -User joe@domain.com -Signature "<div>Thank you for your time,</br>Joseph Wiggum</div>" -SmtpMsa $smtpMsa

    Updates Joe's SendAs settings for his work SendAs alias, including signature and SmtpMsa settings.
    #>
    [OutputType('Google.Apis.Gmail.v1.Data.SmtpMsa')]
    [CmdletBinding(DefaultParameterSetName = "InputObject")]
    Param
    (
        [Parameter(Mandatory = $true, ParameterSetName = "Fields")]
        [Alias('Host')]
        [string]
        $HostName,
        [Parameter(Mandatory = $true, ParameterSetName = "Fields")]
        [int]
        $Port,
        [Parameter(Mandatory = $true, ParameterSetName = "Fields")]
        [ValidateSet('none','securityModeUnspecified','ssl','starttls')]
        [String]
        $SecurityMode,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [String]
        $Username,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [SecureString]
        $Password,
        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ParameterSetName = "InputObject")]
        [Google.Apis.Gmail.v1.Data.SmtpMsa[]]
        $InputObject
    )
    Begin {
        $propsToWatch = @(
            'HostName'
            'Port'
            'SecurityMode'
            'Username'
            'Password'
            'TreatAsAlias'
        )
    }
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Gmail.v1.Data.SmtpMsa'
                    foreach ($prop in $PSBoundParameters.Keys | Where-Object {$obj.PSObject.Properties.Name -contains $_}) {
                        $obj.$prop = $PSBoundParameters[$prop]
                    }
                    $obj
                }
                InputObject {
                    foreach ($iObj in $InputObject) {
                        $obj = New-Object 'Google.Apis.Gmail.v1.Data.SmtpMsa'
                        foreach ($prop in $iObj.PSObject.Properties.Name | Where-Object {$obj.PSObject.Properties.Name -contains $_ -and $propsToWatch -contains $_}) {
                            $obj.$prop = $iObj.$prop
                        }
                        $obj
                    }
                }
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
