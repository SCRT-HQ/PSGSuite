function Get-GSGmailMessageList {
    <#
    .SYNOPSIS
    Gets a list of messages

    .DESCRIPTION
    Gets a list of messages

    .PARAMETER User
    The primary email of the user to list messages for

    Defaults to the AdminEmail user

    .PARAMETER Filter
    Only return messages matching the specified query. Supports the same query format as the Gmail search box. For example, "from:someuser@example.com rfc822msgid: is:unread"

    More info on Gmail search operators here: https://support.google.com/mail/answer/7190?hl=en

    .PARAMETER LabelIds
    Only return messages with labels that match all of the specified label IDs

    .PARAMETER ExcludeChats
    Exclude chats from the message list

    .PARAMETER IncludeSpamTrash
    Include messages from SPAM and TRASH in the results

    .PARAMETER PageSize
    The page size of the result set

    .EXAMPLE
    Get-GSGmailMessageList -Filter "to:me","after:2017/12/25" -ExcludeChats

    Gets the list of messages sent directly to the user after 2017/12/25 excluding chats
    #>
    [OutputType('Google.Apis.Gmail.v1.Data.Message')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [String]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false)]
        [Alias('Query')]
        [String[]]
        $Filter,
        [parameter(Mandatory = $false)]
        [Alias('LabelId')]
        [String[]]
        $LabelIds,
        [parameter(Mandatory = $false)]
        [switch]
        $ExcludeChats,
        [parameter(Mandatory = $false)]
        [switch]
        $IncludeSpamTrash,
        [parameter(Mandatory = $false)]
        [ValidateRange(1,500)]
        [Int]
        $PageSize = "500"
    )
    Process {
        try {
            foreach ($U in $User) {
                if ($U -ceq 'me') {
                    $U = $Script:PSGSuite.AdminEmail
                }
                elseif ($U -notlike "*@*.*") {
                    $U = "$($U)@$($Script:PSGSuite.Domain)"
                }
                $serviceParams = @{
                    Scope       = 'https://mail.google.com'
                    ServiceType = 'Google.Apis.Gmail.v1.GmailService'
                    User        = $U
                }
                if ($ExcludeChats) {
                    if ($Filter) {
                        $Filter += "-in:chats"
                    }
                    else {
                        $Filter = "-in:chats"
                    }
                }
                $service = New-GoogleService @serviceParams
                $request = $service.Users.Messages.List($U)
                foreach ($key in $PSBoundParameters.Keys) {
                    switch ($key) {
                        Filter {
                            $request.Q = $($Filter -join " ")
                        }
                        LabelIds {
                            $request.LabelIds = [String[]]$LabelIds
                        }
                        Default {
                            if ($request.PSObject.Properties.Name -contains $key) {
                                $request.$key = $PSBoundParameters[$key]
                            }
                        }
                    }
                }
                if ($PageSize) {
                    $request.MaxResults = $PageSize
                }
                if ($Filter) {
                    Write-Verbose "Getting all Messages matching filter '$Filter' for user '$U'"
                }
                else {
                    Write-Verbose "Getting all Messages for user '$U'"
                }
                [int]$i = 1
                do {
                    $result = $request.Execute()
                    if ($result.Messages) {
                        $result.Messages | Add-Member -MemberType NoteProperty -Name 'User' -Value $U -PassThru | Add-Member -MemberType NoteProperty -Name 'Filter' -Value $Filter -PassThru
                    }
                    if ($result.NextPageToken) {
                        $request.PageToken = $result.NextPageToken
                    }
                    [int]$retrieved = ($i + $result.Messages.Count) - 1
                    Write-Verbose "Retrieved $retrieved Messages..."
                    [int]$i = $i + $result.Messages.Count
                }
                until (!$result.NextPageToken)
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
