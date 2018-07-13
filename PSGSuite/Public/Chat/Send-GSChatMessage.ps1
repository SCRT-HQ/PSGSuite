function Send-GSChatMessage {
    <#
    .SYNOPSIS
    Sends a Chat message
    
    .DESCRIPTION
    Sends a Chat message

    .PARAMETER Text
    Plain-text body of the message.

    .PARAMETER Thread
    The thread the message belongs to, in the form "spaces/threads".

    Example: spaces/AAAA3dnRkmI/threads/_EyIp5BthJk

    .PARAMETER FallbackText
    A plain-text description of the message's cards, used when the actual cards cannot be displayed (e.g. mobile notifications).

    .PARAMETER PreviewText
    Text for generating preview chips. This text will not be displayed to the user, but any links to images, web pages, videos, etc. included here will generate preview chips.

    .PARAMETER ActionResponseType
    Part of the ActionResponse. Parameters that a bot can use to configure how its response is posted.

    The ActionResponseType is the type of bot response.

    Available values are:
    * NEW_MESSAGE: Post as a new message in the topic.
    * UPDATE_MESSAGE: Update the bot's own message. (Only after CARD_CLICKED events.)
    * REQUEST_CONFIG: Privately ask the user for additional auth or config.

    .PARAMETER ActionResponseUrl
    Part of the ActionResponse. Parameters that a bot can use to configure how its response is posted.

    The ActionResponseUrl is the URL for users to auth or config. (Only for REQUEST_CONFIG response types.)
    
    .PARAMETER Parent
    The resource name of the space to send the message to, in the form "spaces".

    Example: spaces/AAAAMpdlehY

    .PARAMETER ThreadKey
    Opaque thread identifier string that can be specified to group messages into a single thread. If this is the first message with a given thread identifier, a new thread is created. Subsequent messages with the same thread identifier will be posted into the same thread. This relieves bots and webhooks from having to store the Hangouts Chat thread ID of a thread (created earlier by them) to post further updates to it.

    .PARAMETER Webhook
    The Url of the Webhook for the space to send the message to.

    You can safely store an encrypted dictionary of Webhooks in the PSGSuite Config by passing a hashtable to the `-Webhook` parameter, i.e.:
        Set-PSGSuiteConfig -Webhook @{JobReports = 'https://chat.googleapis.com/v1/spaces/xxxxxxxxxx/messages?key=xxxxxxxxxxxxxxxxxx&token=xxxxxxxxxxxxxxxxxx'}
    
    To retrieve a stored Webhook, you can use `Get-GSChatWebhook`, i.e.:
        Send-GSChatMessage -Text "Post job report:" -Cards $cards -Webhook (Get-GSChatWebhook JobReports)

    .PARAMETER MessageSegment
    Any Chat message segment objects created with functions named `Add-GSChat*` passed through the pipeline or added directly to this parameter as values.

    If section widgets are passed directly to this function, a new section without a SectionHeader will be created and the widgets will be added to it

    .EXAMPLE
    Send-GSChatMessage -Text "Post job report:" -Cards $cards -Webhook (Get-GSChatWebhook JobReports)

    Sends a simple Chat message using the JobReports webhook

    .EXAMPLE
    Add-GSChatTextParagraph -Text "Guys...","We <b>NEED</b> to <i>stop</i> spending money on <b>crap</b>!" |
    Add-GSChatKeyValue -TopLabel "Chocolate Budget" -Content '$5.00' -Icon DOLLAR |
    Add-GSChatKeyValue -TopLabel "Actual Spending" -Content '$5,000,000!' -BottomLabel "WTF" -Icon AIRPLANE |
    Add-GSChatImage -ImageUrl "https://media.tenor.com/images/f78545a9b520ecf953578b4be220f26d/tenor.gif" -LinkImage |
    Add-GSChatCardSection -SectionHeader "Dollar bills, y'all" -OutVariable sect1 | 
    Add-GSChatButton -Text "Launch nuke" -OnClick (Add-GSChatOnClick -Url "https://github.com/scrthq/PSGSuite") -Verbose -OutVariable button1 | 
    Add-GSChatButton -Text "Unleash hounds" -OnClick (Add-GSChatOnClick -Url "https://admin.google.com/?hl=en&authuser=0") -Verbose -OutVariable button2 | 
    Add-GSChatCardSection -SectionHeader "What should we do?" -OutVariable sect2 | 
    Add-GSChatCard -HeaderTitle "Makin' moves with" -HeaderSubtitle "DEM GOODIES" -OutVariable card |
    Add-GSChatTextParagraph -Text "This message sent by <b>PSGSuite</b> via WebHook!" | 
    Add-GSChatCardSection -SectionHeader "Additional Info" -OutVariable sect2 | 
    Send-GSChatMessage -Text "Got that report, boss:" -FallbackText "Mistakes have been made..." -Webhook ReportRoom

    This example shows the pipeline capabilities of the Chat functions in PSGSuite. Starting from top to bottom:
        1. Add a TextParagraph widget
        2. Add a KeyValue with an icon
        3. Add another KeyValue with a different icon
        4. Add an image and create an OnClick event to open the image's URL by using the -LinkImage parameter
        5. Add a new section to encapsulate the widgets sent through the pipeline before it
        6. Add a TextButton that opens the PSGSuite GitHub repo when clicked
        7. Add another TextButton that opens Google Admin Console when clicked
        8. Wrap the 2 buttons in a new Section to divide the content
        9. Wrap all widgets and sections in the pipeline so far in a Card
        10. Add a new TextParagraph as a footer to the message
        11. Wrap that TextParagraph in a new section
        12. Send the message and include FallbackText that's displayed in the mobile notification. Since the final TextParagraph and Section are not followed by a new Card addition, Send-GSChatMessage will create a new Card just for the remaining segments then send the completed message via Webhook. The Webhook short-name is used to reference the full URL stored in the encrypted Config so it's not displayed in the actual script.

    .EXAMPLE
    Get-Service | Select-Object -First 5 | ForEach-Object {
        Add-GSChatKeyValue -TopLabel $_.DisplayName -Content $_.Status -BottomLabel $_.Name -Icon TICKET
    } | Add-GSChatCardSection -SectionHeader "Top 5 Services" | Send-GSChatMessage -Text "Service Report:" -FallbackText "Service Report" -Webhook Reports

    This gets the first 5 Services returned by Get-Service, creates KeyValue widgets for each, wraps it in a section with a header, then sends it to the Reports Webhook
    #>
    [cmdletbinding(DefaultParameterSetName = "Webhook")]
    Param
    (
        [parameter(Mandatory = $false,Position = 0)]
        [string[]]
        $Text,
        [parameter(Mandatory = $false)]
        [string]
        $Thread,
        [parameter(Mandatory = $false)]
        [string[]]
        $FallbackText,
        [parameter(Mandatory = $false)]
        [string]
        $PreviewText,
        [parameter(Mandatory = $false)]
        [ValidateSet('NEW_MESSAGE','UPDATE_MESSAGE','REQUEST_CONFIG')]
        [string]
        $ActionResponseType,
        [parameter(Mandatory = $false)]
        [string]
        $ActionResponseUrl,
        [parameter(Mandatory = $true,ParameterSetName = "SDK")]
        [string[]]
        $Parent,
        [parameter(Mandatory = $false,ParameterSetName = "SDK")]
        [string]
        $ThreadKey,
        [parameter(Mandatory = $true,ParameterSetName = "Webhook")]
        [string[]]
        $Webhook,
        [parameter(Mandatory = $false,ValueFromPipeline = $true)]
        [Alias('InputObject')]
        [ValidateScript({
            $allowedTypes = "PSGSuite.Chat.Message.Card","PSGSuite.Chat.Message.Card.Section","PSGSuite.Chat.Message.Card.CardAction","PSGSuite.Chat.Message.Card.Section.TextParagraph","PSGSuite.Chat.Message.Card.Section.Button","PSGSuite.Chat.Message.Card.Section.Image","PSGSuite.Chat.Message.Card.Section.KeyValue"
            foreach ($item in $_) {
                if ([string]$($item.PSTypeNames) -match "($(($allowedTypes|ForEach-Object{[RegEx]::Escape($_)}) -join '|'))") {
                    $true
                }
                else {
                    throw "This parameter only accepts the following types: $($allowedTypes -join ", "). The current types of the value are: $($item.PSTypeNames -join ", ")."
                }
            }
        })]
        [Object[]]
        $MessageSegment
    )
    Begin {
        $addlSections = @()
        $addlCardActions = @()
        $addlSectionWidgets = @()
        switch ($PSCmdlet.ParameterSetName) {
            Webhook {
                $body = @{}
                foreach ($key in $PSBoundParameters.Keys) {
                    switch ($key) {
                        Text {
                            $body['text'] = ($Text -join "`n")
                        }
                        PreviewText {
                            $body['previewText'] = $PSBoundParameters[$key]
                        }
                        FallbackText {
                            $body['fallbackText'] = ($PSBoundParameters[$key] -join "`n")
                        }
                        Thread {
                            $body['thread'] = @{
                                name = $Thread
                            }
                        }
                        ActionResponseType {
                            if (!$body['actionResponse']) {
                                $body['actionResponse'] = @{}
                            }
                            $body['actionResponse']['type'] = $PSBoundParameters[$key]
                        }
                        ActionResponseUrl {
                            if (!$body['actionResponse']) {
                                $body['actionResponse'] = @{}
                            }
                            $body['actionResponse']['url'] = $PSBoundParameters[$key]
                        }
                    }
                }
            }
            SDK {
                $serviceParams = @{
                    Scope       = 'https://www.googleapis.com/auth/chat.bot'
                    ServiceType = 'Google.Apis.HangoutsChat.v1.HangoutsChatService'
                }
                $service = New-GoogleService @serviceParams
                $body = New-Object 'Google.Apis.HangoutsChat.v1.Data.Message'
                foreach ($key in $PSBoundParameters.Keys) {
                    switch ($key) {
                        Text {
                            $body.Text = ($PSBoundParameters[$key] -join "`n")
                        }
                        PreviewText {
                            $body.PreviewText = $PSBoundParameters[$key]
                        }
                        FallbackText {
                            $body.FallbackText = ($PSBoundParameters[$key] -join "`n")
                        }
                        Thread {
                            $body.Thread = New-Object 'Google.Apis.HangoutsChat.v1.Data.Thread' -Property @{
                                Name = $Thread
                            }
                        }
                        ActionResponseType {
                            if (!$body.ActionResponse) {
                                $body.ActionResponse = New-Object 'Google.Apis.HangoutsChat.v1.Data.ActionResponse'
                            }
                            $body.ActionResponse.Type = $PSBoundParameters[$key]
                        }
                        ActionResponseUrl {
                            if (!$body.ActionResponse) {
                                $body.ActionResponse = New-Object 'Google.Apis.HangoutsChat.v1.Data.ActionResponse'
                            }
                            $body.ActionResponse.Url = $PSBoundParameters[$key]
                        }
                    }
                }
            }
        }
    }
    Process {
        foreach ($segment in $MessageSegment) {
            switch ($segment.PSTypeNames[0]) {
                'PSGSuite.Chat.Message.Card' {
                    switch ($PSCmdlet.ParameterSetName) {
                        Webhook {
                            if (!$body['cards']) {
                                $body['cards'] = @()
                            }
                            $body['cards'] += $segment['Webhook']
                        }
                        SDK {
                            if (!$body.Cards) {
                                $body.Cards = New-Object 'System.Collections.Generic.List[Google.Apis.HangoutsChat.v1.Data.Card]'
                            }
                            $body.Cards.Add($segment['SDK']) | Out-Null
                        }
                    }
                }
                'PSGSuite.Chat.Message.Card.Section' {
                    $addlSections += $segment
                }
                'PSGSuite.Chat.Message.Card.CardAction' {
                    $addlCardActions += $segment
                }
                default {
                    $addlSectionWidgets += $segment
                }
            }
        }
    }
    End {
        switch ($PSCmdlet.ParameterSetName) {
            Webhook {
                if ($addlCardActions -or $addlSections -or $addlSectionWidgets) {
                    if (!$body['cards']) {
                        $cardless = $true
                        $body['cards'] = @()
                    }
                    if ($addlSections) {
                        $body['cards'] += ($addlSections | Add-GSChatCard)['Webhook']
                        $cardless = $false
                    }
                    if ($addlSectionWidgets) {
                        if ($cardless) {
                            $body['cards'] += ($addlSectionWidgets | Add-GSChatCardSection | Add-GSChatCard)['Webhook']
                        }
                        else {
                            $newSection = ($addlSectionWidgets | Add-GSChatCardSection)['Webhook']
                            if (!$body['cards'][-1]['sections']) {
                                $body['cards'][-1]['sections'] = @()
                            }
                            $body['cards'][-1]['sections'] += $newSection
                        }
                        $cardless = $false
                    }
                    if ($addlCardActions) {
                        if ($cardless) {
                            $body['cards'] += ($addlCardActions | Add-GSChatCard)['Webhook']
                        }
                        elseif (!$body['cards'][-1]['cardActions']) {
                            $body['cards'][-1]['cardActions'] = @()
                        }
                        foreach ($cardAction in $addlCardActions) {
                            $body['cards'][-1]['cardActions'] += $cardAction['Webhook']
                        }
                    }
                }
                $body = $body | ConvertTo-Json -Depth 15
                foreach ($hook in $Webhook) {
                    try {
                        if ($hook -notlike "https://chat.googleapis.com/v1/spaces/*") {
                            $hook = Get-GSChatWebhook -Name $hook -ErrorAction Stop
                        }
                        Write-Verbose "Sending Chat Message via Webhook to '$($hook -replace "\?key\=.*",'')'"
                        Invoke-RestMethod -Method Post -Uri ([Uri]$hook) -Body $body -ContentType 'application/json' -Verbose:$false | Add-Member -MemberType NoteProperty -Name 'Webhook' -Value $hook -PassThru
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
            SDK {
                if ($addlCardActions -or $addlSections -or $addlSectionWidgets) {
                    if (!$body.Cards) {
                        $cardless = $true
                        $body.Cards = New-Object 'System.Collections.Generic.List[Google.Apis.HangoutsChat.v1.Data.Card]'
                    }
                    if ($addlSections) {
                        $body.Cards.Add(($addlSections | Add-GSChatCard)['SDK']) | Out-Null
                        $cardless = $false
                    }
                    if ($addlSectionWidgets) {
                        if ($cardless) {
                            $body.Cards.Add(($addlSectionWidgets | Add-GSChatCardSection | Add-GSChatCard)['SDK']) | Out-Null
                        }
                        else {
                            $newSection = ($addlSectionWidgets | Add-GSChatCardSection)['SDK']
                            if (!$body.Cards[-1].Sections) {
                                $body.Cards[-1].Sections = New-Object 'System.Collections.Generic.List[Google.Apis.HangoutsChat.v1.Data.Section]'
                            }
                            $body.Cards[-1].Sections.Add($newSection) | Out-Null
                        }
                        $cardless = $false
                    }
                    if ($addlCardActions) {
                        if ($cardless) {
                            $body.Cards.Add(($addlCardActions | Add-GSChatCard)['SDK'])
                        }
                        elseif (!$body.Cards[-1].CardActions) {
                            $body.Cards[-1].CardActions = New-Object 'System.Collections.Generic.List[Google.Apis.HangoutsChat.v1.Data.CardAction]'
                        }
                        foreach ($cardAction in $addlCardActions) {
                            $body.Cards[-1].CardActions.Add($cardAction['SDK']) | Out-Null
                        }
                    }
                }
                foreach ($par in $Parent){
                    try {
                        if ($par -notlike "spaces/*") {
                            $par = "spaces/$par"
                        }
                        $request = $service.Spaces.Messages.Create($body,$par)
                        if ($PSBoundParameters.Keys -contains 'ThreadKey') {
                            $request.ThreadKey = $ThreadKey
                            $addlText = " in ThreadKey '$ThreadKey'"
                        }
                        else {
                            $addlText = ""
                        }
                        Write-Verbose "Sending Chat Message via SDK to Space '$par'$addlText"
                        $request.Execute() | Add-Member -MemberType NoteProperty -Name 'Parent' -Value $par -PassThru | Add-Member -MemberType NoteProperty -Name 'ThreadKey' -Value $ThreadKey -PassThru
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
}