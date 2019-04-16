function Update-GSGmailSignature {
    <#
    .SYNOPSIS
    Updates the Gmail signature for a user's SendAs alias.

    .DESCRIPTION
    Updates the Gmail signature for a user's SendAs alias.

    .PARAMETER User
    The user to update the SendAs signature for.

    .PARAMETER SendAsEmail
    The SendAs alias to be updated. Defaults to the User specified if this parameter is excluded.

    .PARAMETER Signature
    An HTML signature that is included in messages composed with this alias in the Gmail web UI.

    .PARAMETER SignatureFile
    A file containing the HTML signature that is included in messages composed with this alias in the Gmail web UI.

    The file will be read in with Get-Content $SignatureFile -Raw.

    .PARAMETER AsPlainText
    If $true, this wraps your Signature or SignatureFile contents in standard HTML that Google would normally add (div wrappers around each line with font-size:small on all and empty lines replaced with <br>).

    .EXAMPLE
    Update-GSGmailSignature -SendAsEmail joseph.wiggum@business.com -User joe@domain.com -Signature "<div>Thank you for your time,</br>Joseph Wiggum</div>"

    Updates Joe's SendAs signature for his formal alias.
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
        [parameter(Mandatory = $true,ValueFromPipeline = $true,ParameterSetName = "Signature")]
        [string]
        $Signature,
        [parameter(Mandatory = $true,ParameterSetName = "SignatureFile")]
        [ValidateScript({
            try {
                Test-Path $_ -ErrorAction Stop
                $true
            }
            catch {
                throw $_
            }
        })]
        [string]
        $SignatureFile,
        [parameter(Mandatory = $false)]
        [switch]
        $AsPlainText
    )
    Begin {
        $finalSignature = if ($AsPlainText) {
            $baseSignature = if ($PSCmdlet.ParameterSetName -eq 'SignatureFile') {
                Get-Content $SignatureFile
            }
            else {
                $Signature -split "[\r\n]" | Where-Object {$_}
            }
            $fmtSignature = @('<div dir="ltr"><br><div>')
            foreach ($line in $baseSignature) {
                if ([String]::IsNullOrEmpty(($line -replace "\s"))) {
                    $fmtSignature += '<div style="font-size:small"><br></div>'
                }
                else {
                    $fmtSignature += "<div style=`"font-size:small`">$line</div>"
                }
            }
            $fmtSignature += '</div></div>'
            $fmtSignature -join ""
        }
        elseif ($PSCmdlet.ParameterSetName -eq 'SignatureFile') {
            Get-Content $SignatureFile -Raw
        }
        else {
            $Signature
        }
    }
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
        try {
            Write-Verbose "Setting the following signature on SendAs alias '$SendAsEmail' for user '$User':`n`n$finalSignature`n"
            Update-GSGmailSendAsAlias -SendAsEmail $SendAsEmail -User $User -Signature $finalSignature
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
