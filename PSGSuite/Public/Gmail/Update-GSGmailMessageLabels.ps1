function Update-GSGmailMessageLabels {
    <#
    .SYNOPSIS
    Updates Gmail label information for the specified message

    .DESCRIPTION
    Updates Gmail label information for the specified message

    .PARAMETER MessageId
    The unique Id of the message to update.

    .PARAMETER Filter
    The Gmail query to pull the list of messages to update instead of passing the MessageId directly.

    .PARAMETER MaxToModify
    The maximum amount of emails you would like to remove. Use this with the `Filter` parameter as a safeguard.

    .PARAMETER AddLabel
    The label(s) to add to the message. This supports either the unique LabelId or the Display Name for the label

    .PARAMETER RemoveLabel
    The label(s) to remove from the message. This supports either the unique LabelId or the Display Name for the label

    .PARAMETER User
    The user to update message labels for

    Defaults to the AdminEmail user

    .EXAMPLE
    Set-GSGmailLabel -user user@domain.com -LabelId Label_798170282134616520 -

    Gets the Gmail labels of the AdminEmail user
    #>
    [cmdletbinding(DefaultParameterSetName = "MessageId")]
    Param
    (
        [parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = "MessageId")]
        [Alias("Id")]
        [string[]]
        $MessageId,
        [parameter(Mandatory = $true, ParameterSetName = "Filter")]
        [Alias('Query')]
        [string]
        $Filter,
        [parameter(Mandatory = $false,ParameterSetName = "Filter")]
        [int]
        $MaxToModify,
        [parameter(Mandatory = $false)]
        [string[]]
        $AddLabel,
        [parameter(Mandatory = $false)]
        [string[]]
        $RemoveLabel,
        [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail", "UserKey", "Mail")]
        [ValidateNotNullOrEmpty()]
        [string]
        $User = $Script:PSGSuite.AdminEmail
    )
    Process {
        if ($PSBoundParameters.Keys -notcontains 'AddLabel' -and $PSBoundParameters.Keys -notcontains 'RemoveLabel') {
            throw "You must specify a value for either AddLabel or RemoveLabel!"
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
                $MessageId
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
            $userLabels = @{}
            Get-GSGmailLabel -User $User -Verbose:$false | ForEach-Object {
                $userLabels[$_.Name] = $_.Id
            }
            $body = New-Object 'Google.Apis.Gmail.v1.Data.ModifyMessageRequest'
            if ($PSBoundParameters.Keys -contains 'AddLabel') {
                $addLs = New-Object 'System.Collections.Generic.List[System.String]'
                foreach ($label in $AddLabel) {
                    try {
                        $addLs.Add($userLabels[$label])
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
                $body.AddLabelIds = $addLs
            }
            if ($PSBoundParameters.Keys -contains 'RemoveLabel') {
                $remLs = New-Object 'System.Collections.Generic.List[System.String]'
                foreach ($label in $RemoveLabel) {
                    try {
                        $remLs.Add($userLabels[$label])
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
                $body.RemoveLabelIds = $remLs
            }
            foreach ($message in $msgId) {
                try {
                    $request = $service.Users.Messages.Modify($body, $User, $message)
                    Write-Verbose "Updating Labels on Message '$message' for user '$User'"
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
    }
}
