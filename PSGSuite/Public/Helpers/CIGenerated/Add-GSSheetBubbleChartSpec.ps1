function Add-GSSheetBubbleChartSpec {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.BubbleChartSpec object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.BubbleChartSpec object.

    .PARAMETER BubbleBorderColor
    Accepts the following type: [Google.Apis.Sheets.v4.Data.Color].

    To create this type, use the function Add-GSSheetColor or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.Color'.

    .PARAMETER BubbleLabels
    Accepts the following type: [Google.Apis.Sheets.v4.Data.ChartData].

    To create this type, use the function Add-GSSheetChartData or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.ChartData'.

    .PARAMETER BubbleMaxRadiusSize
    Accepts the following type: [int].

    .PARAMETER BubbleMinRadiusSize
    Accepts the following type: [int].

    .PARAMETER BubbleOpacity
    Accepts the following type: [float].

    .PARAMETER BubbleSizes
    Accepts the following type: [Google.Apis.Sheets.v4.Data.ChartData].

    To create this type, use the function Add-GSSheetChartData or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.ChartData'.

    .PARAMETER BubbleTextStyle
    Accepts the following type: [Google.Apis.Sheets.v4.Data.TextFormat].

    To create this type, use the function Add-GSSheetTextFormat or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.TextFormat'.

    .PARAMETER Domain
    Accepts the following type: [Google.Apis.Sheets.v4.Data.ChartData].

    To create this type, use the function Add-GSSheetChartData or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.ChartData'.

    .PARAMETER GroupIds
    Accepts the following type: [Google.Apis.Sheets.v4.Data.ChartData].

    To create this type, use the function Add-GSSheetChartData or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.ChartData'.

    .PARAMETER LegendPosition
    Accepts the following type: [string].

    .PARAMETER Series
    Accepts the following type: [Google.Apis.Sheets.v4.Data.ChartData].

    To create this type, use the function Add-GSSheetChartData or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.ChartData'.

    .EXAMPLE
    Add-GSSheetBubbleChartSpec -BubbleBorderColor $bubbleBorderColor -BubbleLabels $bubbleLabels -BubbleMaxRadiusSize $bubbleMaxRadiusSize -BubbleMinRadiusSize $bubbleMinRadiusSize -BubbleOpacity $bubbleOpacity -BubbleSizes $bubbleSizes -BubbleTextStyle $bubbleTextStyle -Domain $domain -GroupIds $groupIds -LegendPosition $legendPosition -Series $series
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.BubbleChartSpec')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.Color]
        $BubbleBorderColor,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.ChartData]
        $BubbleLabels,
        [parameter()]
        [int]
        $BubbleMaxRadiusSize,
        [parameter()]
        [int]
        $BubbleMinRadiusSize,
        [parameter()]
        [float]
        $BubbleOpacity,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.ChartData]
        $BubbleSizes,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.TextFormat]
        $BubbleTextStyle,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.ChartData]
        $Domain,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.ChartData]
        $GroupIds,
        [parameter()]
        [string]
        $LegendPosition,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.ChartData]
        $Series,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.BubbleChartSpec[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.BubbleChartSpec'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.BubbleChartSpec'
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
