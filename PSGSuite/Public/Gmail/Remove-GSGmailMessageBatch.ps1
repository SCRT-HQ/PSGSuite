function Remove-GSGmailMessageBatch {
    <#
    .SYNOPSIS
    Removes a Gmail message from the user

    .DESCRIPTION
    Removes a Gmail message from the user

    .PARAMETER Id
    The Id of the message to remove

    .PARAMETER Filter
    The Gmail query to pull the list of messages to remove instead of passing the MessageId directly

    .PARAMETER MaxToModify
    The maximum amount of emails you would like to remove. Use this with the `Filter` parameter as a safeguard.

    .PARAMETER Method
    The method used to delete the message

    Available values are:
    * "Trash": moves the message to the TRASH label (Default - preferred method, as this is recoverable)
    * "Delete": permanently deletes the message (NON-RECOVERABLE!)

    Default value is 'Trash'

    .PARAMETER User
    The primary email of the user to remove the message from

    Defaults to the AdminEmail user

    .EXAMPLE
    Remove-GSGmailMessageBatch -User joe -Id 161622d7b76b7e1e,1616227c34d435f2

    Moves the 2 message Id's from Joe's inbox into their TRASH after confirmation
    #>
    [cmdletbinding(SupportsShouldProcess = $true,ConfirmImpact = "High",DefaultParameterSetName = "MessageId")]
    Param
    (
        [parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true,ParameterSetName = "MessageId")]
        [Alias('MessageId')]
        [String[]]
        $Id,
        [parameter(Mandatory = $true, ParameterSetName = "Filter")]
        [Alias('Query')]
        [string]
        $Filter,
        [parameter(Mandatory = $false,ParameterSetName = "Filter")]
        [int]
        $MaxToModify,
        [parameter(Mandatory = $false)]
        [ValidateSet('Trash','Delete')]
        [String]
        $Method = 'Trash',
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [string]
        $User = $Script:PSGSuite.AdminEmail
    )
    Process {
        if ($MyInvocation.InvocationName -eq 'Move-GSGmailMessageToTrash') {
            $Method = 'Trash'
        }
        if ($User -ceq 'me') {
            $User = $Script:PSGSuite.AdminEmail
        }
        elseif ($User -notlike "*@*.*") {
            $User = "$($User)@$($Script:PSGSuite.Domain)"
        }
        $serviceParams = @{
            Scope       = 'https://mail.google.com'
            ServiceType = 'Google.Apis.Gmail.v1.GmailService'
            User        = $User
        }
        $msgId = switch ($PSCmdlet.ParameterSetName) {
            MessageId {
                $Id
            }
            Filter {
                (Get-GSGmailMessageList -Filter $Filter -User $User).Id
            }
        }
        if ($PSBoundParameters.Keys -contains 'MaxToModify' -and $msgId.Count -gt $MaxToModify) {
            Write-Error "MaxToModify is set to $MaxToModify but total modifications are $($msgId.Count). No action taken."
        }
        else {
            $service = New-GoogleService @serviceParams
            try {
                if ($PSCmdlet.ShouldProcess("Removing $($msgId.Count) messages for user '$User'")) {
                    $body = New-Object 'Google.Apis.Gmail.v1.Data.BatchDeleteMessagesRequest' -Property @{
                        Ids = [System.Collections.Generic.List[string]]$msgId
                    }
                    $request = $service.Users.Messages.BatchDelete($body,$User)
                    Write-Verbose "Removing $($msgId.Count) messages for user '$User'"
                    $res = $request.Execute()
                    if ($res) {
                        $res | Add-Member -MemberType NoteProperty -Name 'User' -Value $U -PassThru
                    }
                    Write-Verbose "Successfully removed $($msgId.Count) messages for user '$User'"
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
