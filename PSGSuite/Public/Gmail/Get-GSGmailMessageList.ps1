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
    Only return messages matching the specified query. Supports the same query format as the Gmail search box. For example, "from:someuser@example.com rfc822msgid:<lkj123l4jj1lj@gmail.com> is:unread"

    More info on Gmail search operators here: https://support.google.com/mail/answer/7190?hl=en

    .PARAMETER Rfc822MsgId
    The RFC822 Message ID to add to your filter.

    .PARAMETER LabelIds
    Only return messages with labels that match all of the specified label IDs

    .PARAMETER ExcludeChats
    Exclude chats from the message list

    .PARAMETER IncludeSpamTrash
    Include messages from SPAM and TRASH in the results

    .PARAMETER PageSize
    The page size of the result set

    .PARAMETER Limit
    The maximum amount of results you want returned. Exclude or set to 0 to return all results

    .EXAMPLE
    Get-GSGmailMessageList -Filter "to:me","after:2017/12/25" -ExcludeChats

    Gets the list of messages sent directly to the user after 2017/12/25 excluding chats
    #>
    [OutputType('Google.Apis.Gmail.v1.Data.Message')]
    [cmdletbinding(DefaultParameterSetName = "Filter")]
    Param
    (
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [String]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false,ParameterSetName = "Filter")]
        [Alias('Query')]
        [String[]]
        $Filter,
        [parameter(Mandatory = $false,ParameterSetName = "Rfc822MsgId")]
        [Alias('MessageId','MsgId')]
        [String]
        $Rfc822MsgId,
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
        $PageSize = 500,
        [parameter(Mandatory = $false)]
        [Alias('First')]
        [Int]
        $Limit = 0
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
                        Rfc822MsgId {
                            $request.Q = "rfc822msgid:$($Rfc822MsgId.Trim())"
                        }
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
                if ($Limit -gt 0 -and $PageSize -gt $Limit) {
                    Write-Verbose ("Reducing PageSize from {0} to {1} to meet limit with first page" -f $PageSize,$Limit)
                    $PageSize = $Limit
                }
                $request.MaxResults = $PageSize
                if ($request.Q) {
                    Write-Verbose "Getting all Messages matching filter '$($request.Q)' for user '$U'"
                }
                else {
                    Write-Verbose "Getting all Messages for user '$U'"
                }
                [int]$i = 1
                $overLimit = $false
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
                    if ($Limit -gt 0 -and $retrieved -eq $Limit) {
                        Write-Verbose "Limit reached: $Limit"
                        $overLimit = $true
                    }
                    elseif ($Limit -gt 0 -and ($retrieved + $PageSize) -gt $Limit) {
                        $newPS = $Limit - $retrieved
                        Write-Verbose ("Reducing PageSize from {0} to {1} to meet limit with next page" -f $PageSize,$newPS)
                        $request.MaxResults = $newPS
                    }
                    [int]$i = $i + $result.Messages.Count
                }
                until ($overLimit -or !$result.NextPageToken)
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
