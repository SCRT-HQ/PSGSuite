function Add-GSSheetChartSpec {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.ChartSpec object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.ChartSpec object.

    .PARAMETER AltText
    Accepts the following type: [string].

    .PARAMETER BackgroundColor
    Accepts the following type: [Google.Apis.Sheets.v4.Data.Color].

    To create this type, use the function Add-GSSheetColor or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.Color'.

    .PARAMETER BasicChart
    Accepts the following type: [Google.Apis.Sheets.v4.Data.BasicChartSpec].

    To create this type, use the function Add-GSSheetBasicChartSpec or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.BasicChartSpec'.

    .PARAMETER BubbleChart
    Accepts the following type: [Google.Apis.Sheets.v4.Data.BubbleChartSpec].

    To create this type, use the function Add-GSSheetBubbleChartSpec or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.BubbleChartSpec'.

    .PARAMETER CandlestickChart
    Accepts the following type: [Google.Apis.Sheets.v4.Data.CandlestickChartSpec].

    To create this type, use the function Add-GSSheetCandlestickChartSpec or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.CandlestickChartSpec'.

    .PARAMETER FontName
    Accepts the following type: [string].

    .PARAMETER HiddenDimensionStrategy
    Accepts the following type: [string].

    .PARAMETER HistogramChart
    Accepts the following type: [Google.Apis.Sheets.v4.Data.HistogramChartSpec].

    To create this type, use the function Add-GSSheetHistogramChartSpec or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.HistogramChartSpec'.

    .PARAMETER Maximized
    Accepts the following type: [switch].

    .PARAMETER OrgChart
    Accepts the following type: [Google.Apis.Sheets.v4.Data.OrgChartSpec].

    To create this type, use the function Add-GSSheetOrgChartSpec or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.OrgChartSpec'.

    .PARAMETER PieChart
    Accepts the following type: [Google.Apis.Sheets.v4.Data.PieChartSpec].

    To create this type, use the function Add-GSSheetPieChartSpec or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.PieChartSpec'.

    .PARAMETER Subtitle
    Accepts the following type: [string].

    .PARAMETER SubtitleTextFormat
    Accepts the following type: [Google.Apis.Sheets.v4.Data.TextFormat].

    To create this type, use the function Add-GSSheetTextFormat or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.TextFormat'.

    .PARAMETER SubtitleTextPosition
    Accepts the following type: [Google.Apis.Sheets.v4.Data.TextPosition].

    To create this type, use the function Add-GSSheetTextPosition or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.TextPosition'.

    .PARAMETER Title
    Accepts the following type: [string].

    .PARAMETER TitleTextFormat
    Accepts the following type: [Google.Apis.Sheets.v4.Data.TextFormat].

    To create this type, use the function Add-GSSheetTextFormat or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.TextFormat'.

    .PARAMETER TitleTextPosition
    Accepts the following type: [Google.Apis.Sheets.v4.Data.TextPosition].

    To create this type, use the function Add-GSSheetTextPosition or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.TextPosition'.

    .PARAMETER TreemapChart
    Accepts the following type: [Google.Apis.Sheets.v4.Data.TreemapChartSpec].

    To create this type, use the function Add-GSSheetTreemapChartSpec or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.TreemapChartSpec'.

    .PARAMETER WaterfallChart
    Accepts the following type: [Google.Apis.Sheets.v4.Data.WaterfallChartSpec].

    To create this type, use the function Add-GSSheetWaterfallChartSpec or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.WaterfallChartSpec'.

    .EXAMPLE
    Add-GSSheetChartSpec -AltText $altText -BackgroundColor $backgroundColor -BasicChart $basicChart -BubbleChart $bubbleChart -CandlestickChart $candlestickChart -FontName $fontName -HiddenDimensionStrategy $hiddenDimensionStrategy -HistogramChart $histogramChart -Maximized $maximized -OrgChart $orgChart -PieChart $pieChart -Subtitle $subtitle -SubtitleTextFormat $subtitleTextFormat -SubtitleTextPosition $subtitleTextPosition -Title $title -TitleTextFormat $titleTextFormat -TitleTextPosition $titleTextPosition -TreemapChart $treemapChart -WaterfallChart $waterfallChart
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.ChartSpec')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [string]
        $AltText,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.Color]
        $BackgroundColor,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.BasicChartSpec]
        $BasicChart,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.BubbleChartSpec]
        $BubbleChart,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.CandlestickChartSpec]
        $CandlestickChart,
        [parameter()]
        [string]
        $FontName,
        [parameter()]
        [string]
        $HiddenDimensionStrategy,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.HistogramChartSpec]
        $HistogramChart,
        [parameter()]
        [switch]
        $Maximized,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.OrgChartSpec]
        $OrgChart,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.PieChartSpec]
        $PieChart,
        [parameter()]
        [string]
        $Subtitle,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.TextFormat]
        $SubtitleTextFormat,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.TextPosition]
        $SubtitleTextPosition,
        [parameter()]
        [string]
        $Title,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.TextFormat]
        $TitleTextFormat,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.TextPosition]
        $TitleTextPosition,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.TreemapChartSpec]
        $TreemapChart,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.WaterfallChartSpec]
        $WaterfallChart,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.ChartSpec[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.ChartSpec'
                    foreach ($prop in $PSBoundParameters.Keys | Where-Object {$obj.PSObject.Properties.Name -contains $_}) {
                        switch ($prop) {
                            default {
                                $obj.$prop = $PSBoundParameters[$prop]
                            }
                        }
                    }
                    $obj
                }
                InputObject {
                    foreach ($iObj in $InputObject) {
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.ChartSpec'
                        foreach ($prop in $iObj.PSObject.Properties.Name | Where-Object {$obj.PSObject.Properties.Name -contains $_ -and $_ -ne 'ETag'}) {
                            $obj.$prop = $iObj.$prop
                        }
                        $obj
                    }
                }
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
