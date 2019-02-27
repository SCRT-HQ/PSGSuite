function Get-GSGmailSendAsSettings {
    <#
    .SYNOPSIS
    Gets Gmail SendAs Settings.

    .DESCRIPTION
    Gets Gmail SendAs Settings.

    .PARAMETER SendAsEmail
    The SendAs alias to be retrieved.

    If excluded, gets the list of SendAs aliases.

    .PARAMETER User
    The email of the user you are getting the information for

    .EXAMPLE
    Get-GSGmailSendAsSettings -User joe@domain.com

    Gets the list of SendAs Settings for Joe
    #>
    [OutputType('Google.Apis.Gmail.v1.Data.SendAs')]
    [cmdletbinding()]
    Param (
        [parameter(Mandatory = $false,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [Alias("SendAs")]
        [string[]]
        $SendAsEmail,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [string]
        $User = $Script:PSGSuite.AdminEmail
    )
    Process {
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
        if ($PSBoundParameters.ContainsKey('SendAsEmail')) {
            foreach ($sendAs in $SendAsEmail) {
                try {
                    if ($sendAs -notlike "*@*.*") {
                        $sendAs = "$($sendAs)@$($Script:PSGSuite.Domain)"
                    }
                    $request = $service.Users.Settings.SendAs.Get($User,$sendAs)
                    Write-Verbose "Getting SendAs settings for alias '$sendAs', user '$User'"
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
        else {
            try {
                $request = $service.Users.Settings.SendAs.List($User)
                Write-Verbose "Getting SendAs List for user '$User'"
                $request.Execute() | Select-Object -ExpandProperty SendAs | Add-Member -MemberType NoteProperty -Name 'User' -Value $User -PassThru
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
