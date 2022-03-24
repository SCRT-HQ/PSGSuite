function Add-GSGmailFilter {
    <#
    .SYNOPSIS
    Adds a new Gmail filter

    .DESCRIPTION
    Adds a new Gmail filter

    .PARAMETER User
    The email of the user you are adding the filter for

    .PARAMETER From
    The sender's display name or email address.

    .PARAMETER To
    The recipient's display name or email address. Includes recipients in the "to", "cc", and "bcc" header fields. You can use simply the local part of the email address. For example, "example" and "example@" both match "example@gmail.com". This field is case-insensitive

    .PARAMETER Subject
    Case-insensitive phrase found in the message's subject. Trailing and leading whitespace are be trimmed and adjacent spaces are collapsed

    .PARAMETER Query
    Only return messages matching the specified query. Supports the same query format as the Gmail search box. For example, "from:someuser@example.com rfc822msgid: is:unread"

    .PARAMETER NegatedQuery
    Only return messages not matching the specified query. Supports the same query format as the Gmail search box. For example, "from:someuser@example.com rfc822msgid: is:unread"

    .PARAMETER HasAttachment
    Whether the message has any attachment

    .PARAMETER ExcludeChats
    Whether the response should exclude chats

    .PARAMETER AddLabelIDs
    List of labels to add to the message

    .PARAMETER RemoveLabelIDs
    List of labels to remove from the message

    .PARAMETER Forward
    Email address that the message should be forwarded to

    .PARAMETER Size
    The size of the entire RFC822 message in bytes, including all headers and attachments

    .PARAMETER SizeComparison
    How the message size in bytes should be in relation to the size field.

    Acceptable values are:
    * "larger"
    * "smaller"
    * "unspecified"

    .PARAMETER Raw
    If $true, returns the raw response. If not passed or -Raw:$false, response is formatted as a flat object for readability

    .EXAMPLE
    Add-GSGmailFilter -To admin@domain.com -ExcludeChats -Forward "admin_directMail@domain.com"

    Adds a filter for the AdminEmail user to forward all mail sent directly to the to "admin_directMail@domain.com"
    #>
    [OutputType('Google.Apis.Gmail.v1.Data.Filter')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [string]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [string]
        $From,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [string]
        $To,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [string]
        $Subject,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [string]
        $Query,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [string]
        $NegatedQuery,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [Switch]
        $HasAttachment,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [Switch]
        $ExcludeChats,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [string[]]
        $AddLabelIDs,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [string[]]
        $RemoveLabelIDs,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [string]
        $Forward,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [int]
        $Size,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('Larger','Smaller','Unspecified')]
        [string]
        $SizeComparison,
        [parameter(Mandatory = $false)]
        [Switch]
        $Raw
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
            $body = New-Object 'Google.Apis.Gmail.v1.Data.Filter'
            $action = New-Object 'Google.Apis.Gmail.v1.Data.FilterAction'
            $criteria = New-Object 'Google.Apis.Gmail.v1.Data.FilterCriteria'
            foreach ($key in $PSBoundParameters.Keys) {
                switch ($key) {
                    AddLabelIDs {
                        $action.$key = [String[]]($PSBoundParameters[$key])
                    }
                    RemoveLabelIds {
                        $action.$key = [String[]]($PSBoundParameters[$key])
                    }
                    Forward {
                        $action.$key = $PSBoundParameters[$key]
                    }
                    Default {
                        if ($criteria.PSObject.Properties.Name -contains $key) {
                            $criteria.$key = $PSBoundParameters[$key]
                        }
                    }
                }
            }
            $body.Action = $action
            $body.Criteria = $criteria
            $request = $service.Users.Settings.Filters.Create($body,$User)
            Write-Verbose "Creating Filter for user '$User'"
            $response = $request.Execute() | Add-Member -MemberType NoteProperty -Name 'User' -Value $User -PassThru
            if (!$Raw) {
                $response = $response | Select-Object User,Id,@{N = "From";E = {$_.criteria.from}},@{N = "To";E = {$_.criteria.to}},@{N = "Subject";E = {$_.criteria.subject}},@{N = "Query";E = {$_.criteria.query}},@{N = "NegatedQuery";E = {$_.criteria.negatedQuery}},@{N = "HasAttachment";E = {$_.criteria.hasAttachment}},@{N = "ExcludeChats";E = {$_.criteria.excludeChats}},@{N = "Size";E = {$_.criteria.size}},@{N = "SizeComparison";E = {$_.criteria.sizeComparison}},@{N = "AddLabelIds";E = {$_.action.addLabelIds}},@{N = "RemoveLabelIds";E = {$_.action.removeLabelIds}},@{N = "Forward";E = {$_.action.forward}}
            }
            $response
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
