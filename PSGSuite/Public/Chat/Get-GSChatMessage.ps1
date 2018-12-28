function Get-GSChatMessage {
    <#
    .SYNOPSIS
    Gets a Chat message

    .DESCRIPTION
    Gets a Chat message

    .PARAMETER Name
    Resource name of the message to be retrieved, in the form "spaces/messages".

    Example: spaces/AAAAMpdlehY/messages/UMxbHmzDlr4.UMxbHmzDlr4

    .EXAMPLE
    Get-GSChatMessage -Name 'spaces/AAAAMpdlehY/messages/UMxbHmzDlr4.UMxbHmzDlr4'

    Gets the Chat message specified
    #>
    [OutputType('Google.Apis.HangoutsChat.v1.Data.Message')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0)]
        [Alias('Id')]
        [string[]]
        $Name
    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/chat.bot'
            ServiceType = 'Google.Apis.HangoutsChat.v1.HangoutsChatService'
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        foreach ($msg in $Name) {
            try {
                $request = $service.Spaces.Messages.Get($msg)
                Write-Verbose "Getting Message '$msg'"
                $request.Execute()
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
