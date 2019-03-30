function Get-GSGmailAutoForwardingSettings {
    <#
    .SYNOPSIS
    Gets AutoForwarding settings

    .DESCRIPTION
    Gets AutoForwarding settings

    .PARAMETER User
    The user to get the AutoForwarding settings for

    Defaults to the AdminEmail user

    .EXAMPLE
    Get-GSGmailAutoForwardingSettings

    Gets the AutoForwarding settings for the AdminEmail user
    #>
    [OutputType('Google.Apis.Gmail.v1.Data.AutoForwarding')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false,Position = 0,ValueFromPipelineByPropertyName = $true)]
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
        try {
            $request = $service.Users.Settings.GetAutoForwarding($User)
            Write-Verbose "Getting AutoForwarding settings for user '$User'"
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
