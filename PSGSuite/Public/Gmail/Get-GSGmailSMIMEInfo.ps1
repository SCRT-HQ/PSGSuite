function Get-GSGmailSMIMEInfo {
    <#
    .SYNOPSIS
    Gets Gmail S/MIME info
    
    .DESCRIPTION
    Gets Gmail S/MIME info
    
    .PARAMETER SendAsEmail
    The email address that appears in the "From:" header for mail sent using this alias.
    
    .PARAMETER Id
    The immutable ID for the SmimeInfo.

    If left blank, returns the list of S/MIME infos for the SendAsEmail and User
    
    .PARAMETER User
    The user's email address

    Defaults to the AdminEmail user
    
    .EXAMPLE
    Get-GSGmailSMIMEInfo -SendAsEmail 'joe@otherdomain.com' -User joe@domain.com

    Gets the list of S/MIME infos for Joe's SendAsEmail 'joe@otherdomain.com'
    #>
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true)]
        [string]
        $SendAsEmail,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
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
        try {
            if ($PSBoundParameters.Keys -contains 'Id') {
                foreach ($I in $Id) {
                    $request = $service.Users.Settings.SendAs.SmimeInfo.Get($User,$SendAsEmail,$I)
                    Write-Verbose "Getting S/MIME Id '$I' of SendAsEmail '$SendAsEmail' for user '$User'"
                    $request.Execute() | Add-Member -MemberType NoteProperty -Name 'User' -Value $User -PassThru
                }
            }
            else {
                $request = $service.Users.Settings.SendAs.SmimeInfo.List($User,$SendAsEmail)
                Write-Verbose "Getting list of S/MIME Id's of SendAsEmail '$SendAsEmail' for user '$User'"
                $request.Execute() | Select-Object -ExpandProperty smimeInfo | Add-Member -MemberType NoteProperty -Name 'User' -Value $User -PassThru
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