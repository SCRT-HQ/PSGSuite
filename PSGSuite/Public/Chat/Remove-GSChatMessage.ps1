function Remove-GSChatMessage {
    <#
    .SYNOPSIS
    Removes a Chat message

    .DESCRIPTION
    Removes a Chat message

    .PARAMETER Name
    Resource name of the message to be removed, in the form "spaces/messages".

    Example: spaces/AAAAMpdlehY/messages/UMxbHmzDlr4.UMxbHmzDlr4

    .EXAMPLE
    Remove-GSChatMessage -Name 'spaces/AAAAMpdlehY/messages/UMxbHmzDlr4.UMxbHmzDlr4'

    Removes the Chat message specified after confirmation
    #>
    [cmdletbinding(SupportsShouldProcess = $true,ConfirmImpact = "High")]
    Param
    (
        [parameter(Mandatory = $true,Position = 0)]
        [Alias('Id')]
        [string[]]
        $Name
    )
    Process {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/chat.bot'
            ServiceType = 'Google.Apis.HangoutsChat.v1.HangoutsChatService'
        }
        $service = New-GoogleService @serviceParams
        foreach ($msg in $Name) {
            try {
                if ($PSCmdlet.ShouldProcess("Removing Message '$msg'")) {
                    $request = $service.Spaces.Messages.Delete($msg)
                    $request.Execute()
                    Write-Verbose "Successfully removed Message '$msg'"
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
