function Add-GSChatKeyValue {
    <#
    .SYNOPSIS
    Creates a Chat KeyValue widget to include in a section

    .DESCRIPTION
    Creates a Chat KeyValue widget to include in a section

    .PARAMETER TopLabel
    The TopLabel for the KeyValue

    .PARAMETER Content
    The Content for the KeyValue

    .PARAMETER BottomLabel
    The BottomLabel for the KeyValue

    .PARAMETER Icon
    The icon to display next to the KeyValue

    Available values are:
    * AIRPLANE
    * BOOKMARK
    * BUS
    * CAR
    * CLOCK
    * CONFIRMATION_NUMBER_ICON
    * DOLLAR
    * DESCRIPTION
    * EMAIL
    * EVENT_PERFORMER
    * EVENT_SEAT
    * FLIGHT_ARRIVAL
    * FLIGHT_DEPARTURE
    * HOTEL
    * HOTEL_ROOM_TYPE
    * INVITE
    * MAP_PIN
    * MEMBERSHIP
    * MULTIPLE_PEOPLE
    * OFFER
    * PERSON
    * PHONE
    * RESTAURANT_ICON
    * SHOPPING_CART
    * STAR
    * STORE
    * TICKET
    * TRAIN
    * VIDEO_CAMERA
    * VIDEO_PLAY

    .PARAMETER IconUrl
    The Url of the icon to display next to the KeyValue

    .PARAMETER ContentMultiline
    Whether the content of the KeyValue is multiline or not

    .PARAMETER OnClick
    The OnClick event that triggers when a user clicks the KeyValue

    You must use the function `Add-GSChatOnClick` to create OnClicks, otherwise this will throw a terminating error.

    .PARAMETER Button
    A button to add to the KeyValue

    You must use the function `Add-GSChatButton` to create Buttons, otherwise this will throw a terminating error.

    .PARAMETER MessageSegment
    Any Chat message segment objects created with functions named `Add-GSChat*` passed through the pipeline or added directly to this parameter as values.

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
    [CmdletBinding(DefaultParameterSetName = "Icon")]
    Param
    (
        [parameter(Mandatory = $false)]
        [String]
        $TopLabel,
        [parameter(Mandatory = $false)]
        [String]
        $Content,
        [parameter(Mandatory = $false)]
        [String]
        $BottomLabel,
        [parameter(Mandatory = $false,ParameterSetName = "Icon")]
        [ValidateSet('AIRPLANE','BOOKMARK','BUS','CAR','CLOCK','CONFIRMATION_NUMBER_ICON','DOLLAR','DESCRIPTION','EMAIL','EVENT_PERFORMER','EVENT_SEAT','FLIGHT_ARRIVAL','FLIGHT_DEPARTURE','HOTEL','HOTEL_ROOM_TYPE','INVITE','MAP_PIN','MEMBERSHIP','MULTIPLE_PEOPLE','OFFER','PERSON','PHONE','RESTAURANT_ICON','SHOPPING_CART','STAR','STORE','TICKET','TRAIN','VIDEO_CAMERA','VIDEO_PLAY')]
        [String]
        $Icon,
        [parameter(Mandatory = $false,ParameterSetName = "IconUrl")]
        [String]
        $IconUrl,
        [parameter(Mandatory = $false)]
        [Switch]
        $ContentMultiline,
        [parameter(Mandatory = $false)]
        [ValidateScript( {
            $allowedTypes = "PSGSuite.Chat.Message.Card.OnClick"
            if ([string]$($_.PSTypeNames) -match "($(($allowedTypes|ForEach-Object{[RegEx]::Escape($_)}) -join '|'))") {
                $true
            }
            else {
                throw "This parameter only accepts the following types: $($allowedTypes -join ", "). The current types of the value are: $($_.PSTypeNames -join ", ")."
            }
        })]
        [Object]
        $OnClick,
        [parameter(Mandatory = $false)]
        [ValidateScript( {
            $allowedTypes = "PSGSuite.Chat.Message.Card.Section.Button"
            if ([string]$($_.PSTypeNames) -match "($(($allowedTypes|ForEach-Object{[RegEx]::Escape($_)}) -join '|'))") {
                $true
            }
            else {
                throw "This parameter only accepts the following types: $($allowedTypes -join ", "). The current types of the value are: $($_.PSTypeNames -join ", ")."
            }
        })]
        [Object]
        $Button,
        [parameter(Mandatory = $false,ValueFromPipeline = $true)]
        [Alias('InputObject')]
        [ValidateScript({
            $allowedTypes = "PSGSuite.Chat.Message.Card.Section","PSGSuite.Chat.Message.Card","PSGSuite.Chat.Message.Card.CardAction","PSGSuite.Chat.Message.Card.Section.TextParagraph","PSGSuite.Chat.Message.Card.Section.Button","PSGSuite.Chat.Message.Card.Section.Image","PSGSuite.Chat.Message.Card.Section.KeyValue"
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
        $widgetObject = @{
            Webhook = @{
                keyValue = @{}
            }
            SDK = (New-Object 'Google.Apis.HangoutsChat.v1.Data.WidgetMarkup' -Property @{
                KeyValue = (New-Object 'Google.Apis.HangoutsChat.v1.Data.KeyValue')
            })
        }
        $widgetStack = @()
        foreach ($key in $PSBoundParameters.Keys) {
            switch ($key) {
                TopLabel {
                    $widgetObject['Webhook']['keyValue']['topLabel'] = $PSBoundParameters[$key]
                    $widgetObject['SDK'].KeyValue.TopLabel = $PSBoundParameters[$key]
                }
                Content {
                    $widgetObject['Webhook']['keyValue']['content'] = $PSBoundParameters[$key]
                    $widgetObject['SDK'].KeyValue.Content = $PSBoundParameters[$key]
                }
                BottomLabel {
                    $widgetObject['Webhook']['keyValue']['bottomLabel'] = $PSBoundParameters[$key]
                    $widgetObject['SDK'].KeyValue.BottomLabel = $PSBoundParameters[$key]
                }
                Icon {
                    $widgetObject['Webhook']['keyValue']['icon'] = $PSBoundParameters[$key]
                    $widgetObject['SDK'].KeyValue.Icon = $PSBoundParameters[$key]
                }
                IconUrl {
                    $widgetObject['Webhook']['keyValue']['iconUrl'] = $PSBoundParameters[$key]
                    $widgetObject['SDK'].KeyValue.IconUrl = $PSBoundParameters[$key]
                }
                ContentMultiline {
                    $widgetObject['Webhook']['keyValue']['contentMultiline'] = $PSBoundParameters[$key]
                    $widgetObject['SDK'].KeyValue.ContentMultiline = $PSBoundParameters[$key]
                }
                OnClick {
                    $widgetObject['Webhook']['keyValue']['onClick'] = $PSBoundParameters[$key]['Webhook']
                    $widgetObject['SDK'].KeyValue.OnClick = $PSBoundParameters[$key]['SDK']
                }
                Button {
                    $widgetObject['Webhook']['keyValue']['button'] = $PSBoundParameters[$key]['Webhook']
                    $widgetObject['SDK'].KeyValue.Button = $PSBoundParameters[$key]['SDK']
                }
            }
        }
    }
    Process {
        foreach ($segment in $MessageSegment) {
            if ($segment.PSTypeNames[0] -in @("PSGSuite.Chat.Message.Card.Section.TextParagraph","PSGSuite.Chat.Message.Card.Section.Button","PSGSuite.Chat.Message.Card.Section.Image","PSGSuite.Chat.Message.Card.Section.KeyValue")) {
                $widgetStack += $segment
            }
            else {
                $segment
            }
        }
    }
    End {
        [void]$widgetObject.PSObject.TypeNames.Insert(0,'PSGSuite.Chat.Message.Card.Section.KeyValue')
        if ($widgetStack) {
            $widgetStack += $widgetObject
            $widgetStack
        }
        else {
            $widgetObject
        }
    }
}