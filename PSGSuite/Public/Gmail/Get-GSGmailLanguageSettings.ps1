function Get-GSGmailLanguageSettings {
    <#
    .SYNOPSIS
    Gets Gmail display language settings

    .DESCRIPTION
    Gets Gmail display language settings

    .PARAMETER User
    The user to get the Gmail display language settings for.

    Defaults to the AdminEmail user.

    .EXAMPLE
    Get-GSGmailLanguageSettings -User me

    Gets the Gmail display language for the AdminEmail user.
    #>
    [OutputType('Google.Apis.Gmail.v1.Data.LanguageSettings')]
    [cmdletbinding()]
    Param (
        [parameter(Position = 0,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $User = $Script:PSGSuite.AdminEmail
    )
    Process {
        foreach ($U in $User) {
            if ($U -ceq 'me') {
                $U = $Script:PSGSuite.AdminEmail
            }
            elseif ($U -notlike "*@*.*") {
                $U = "$($U)@$($Script:PSGSuite.Domain)"
            }
            $serviceParams = @{
                Scope       = 'https://www.googleapis.com/auth/gmail.settings.basic'
                ServiceType = 'Google.Apis.Gmail.v1.GmailService'
                User        = $U
            }
            $service = New-GoogleService @serviceParams
            try {
                $request = $service.Users.Settings.GetLanguage($U)
                Write-Verbose "Getting Gmail Display Language for user '$U'"
                $request.Execute() | Add-Member -MemberType NoteProperty -Name 'User' -Value $U -PassThru
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
