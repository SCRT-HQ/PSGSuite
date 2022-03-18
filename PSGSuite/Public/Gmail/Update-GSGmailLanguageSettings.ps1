function Update-GSGmailLanguageSettings {
    <#
    .SYNOPSIS
    Updates Gmail display language settings

    .DESCRIPTION
    Updates Gmail display language settings

    .PARAMETER User
    The user to update the Gmail display language settings for

    .PARAMETER Language
    The language to display Gmail in, formatted as an RFC 3066 Language Tag (for example en-GB, fr or ja for British English, French, or Japanese respectively).

    The set of languages supported by Gmail evolves over time, so please refer to the "Language" dropdown in the Gmail settings for all available options, as described in the language settings help article. A table of sample values is also provided in the Managing Language Settings guide

    Not all Gmail clients can display the same set of languages. In the case that a user's display language is not available for use on a particular client, said client automatically chooses to display in the closest supported variant (or a reasonable default).

    .EXAMPLE
    Update-GSGmailLanguageSettings -User me -Language fr

    Updates the Gmail display language to French for the AdminEmail user.
    #>
    [OutputType('Google.Apis.Gmail.v1.Data.LanguageSettings')]
    [cmdletbinding()]
    Param (
        [parameter(Mandatory,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $User,
        [parameter(Mandatory,Position = 1)]
        [ValidateSet('af','am','ar','az','bg','bn','ca','chr','cs','cy','da','de','el','en','en-GB','es','es-419','et','eu','fa','fi','fil','fr','fr-CA','ga','gl','gu','he','hi','hr','hu','hy','id','is','it','ja','ka','km','kn','ko','lo','lt','lv','ml','mn','mr','ms','my','ne','nl','no','pl','pt-BR','pt-PT','ro','ru','si','sk','sl','sr','sv','sw','ta','te','th','tr','uk','ur','vi','zh-CN','zh-HK','zh-TW','zu')]
        [string]
        $Language
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
                $body = New-Object 'Google.Apis.Gmail.v1.Data.LanguageSettings' -Property @{
                    DisplayLanguage = $Language
                }
                $request = $service.Users.Settings.UpdateLanguage($body,$U)
                Write-Verbose "Updating Gmail Display Language for user '$U' to '$Language'"
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
