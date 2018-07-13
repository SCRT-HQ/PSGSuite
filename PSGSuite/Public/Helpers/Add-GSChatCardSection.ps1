function Add-GSChatCardSection {
    <#
    .SYNOPSIS
    Creates a Chat Message Card Section

    .DESCRIPTION
    Creates a Chat Message Card Section

    .PARAMETER SectionHeader
    The header title of the section

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
    Param
    (
        [parameter(Mandatory = $false,Position = 0)]
        [String]
        $SectionHeader,
        [parameter(Mandatory = $true,ValueFromPipeline = $true)]
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
        $sectionObject = @{
            Webhook = @{
                widgets = @()
            }
            SDK = (New-Object 'Google.Apis.HangoutsChat.v1.Data.Section' -Property @{
                Widgets = (New-Object 'System.Collections.Generic.List[Google.Apis.HangoutsChat.v1.Data.WidgetMarkup]')
            })
        }
        if ($PSBoundParameters.Keys -contains 'SectionHeader') {
            $sectionObject['Webhook']['header'] = $SectionHeader
            $sectionObject['SDK'].Header = $SectionHeader
        }
    }
    Process {
        foreach ($segment in $MessageSegment) {
            if ($segment.PSTypeNames[0] -in @("PSGSuite.Chat.Message.Card.Section.TextParagraph","PSGSuite.Chat.Message.Card.Section.Button","PSGSuite.Chat.Message.Card.Section.Image","PSGSuite.Chat.Message.Card.Section.KeyValue")) {
                $sectionObject['Webhook']['widgets'] += $segment['Webhook']
                $sectionObject['SDK'].Widgets.Add($segment['SDK'])
            }
            else {
                $segment
            }
            
        }
    }
    End {
        [void]$sectionObject.PSObject.TypeNames.Insert(0,'PSGSuite.Chat.Message.Card.Section')
        return $sectionObject
    }
}