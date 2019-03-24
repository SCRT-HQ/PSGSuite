function Add-GSSheetWaterfallChartSeries {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.WaterfallChartSeries object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.WaterfallChartSeries object.

    .PARAMETER CustomSubtotals
    Accepts the following type: [Google.Apis.Sheets.v4.Data.WaterfallChartCustomSubtotal[]].

    To create this type, use the function Add-GSSheetWaterfallChartCustomSubtotal or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.WaterfallChartCustomSubtotal'.

    .PARAMETER Data
    Accepts the following type: [Google.Apis.Sheets.v4.Data.ChartData].

    To create this type, use the function Add-GSSheetChartData or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.ChartData'.

    .PARAMETER HideTrailingSubtotal
    Accepts the following type: [switch].

    .PARAMETER NegativeColumnsStyle
    Accepts the following type: [Google.Apis.Sheets.v4.Data.WaterfallChartColumnStyle].

    To create this type, use the function Add-GSSheetWaterfallChartColumnStyle or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.WaterfallChartColumnStyle'.

    .PARAMETER PositiveColumnsStyle
    Accepts the following type: [Google.Apis.Sheets.v4.Data.WaterfallChartColumnStyle].

    To create this type, use the function Add-GSSheetWaterfallChartColumnStyle or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.WaterfallChartColumnStyle'.

    .PARAMETER SubtotalColumnsStyle
    Accepts the following type: [Google.Apis.Sheets.v4.Data.WaterfallChartColumnStyle].

    To create this type, use the function Add-GSSheetWaterfallChartColumnStyle or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.WaterfallChartColumnStyle'.

    .EXAMPLE
    Add-GSSheetWaterfallChartSeries -CustomSubtotals $customSubtotals -Data $data -HideTrailingSubtotal $hideTrailingSubtotal -NegativeColumnsStyle $negativeColumnsStyle -PositiveColumnsStyle $positiveColumnsStyle -SubtotalColumnsStyle $subtotalColumnsStyle
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.WaterfallChartSeries')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.WaterfallChartCustomSubtotal[]]
        $CustomSubtotals,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.ChartData]
        $Data,
        [parameter()]
        [switch]
        $HideTrailingSubtotal,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.WaterfallChartColumnStyle]
        $NegativeColumnsStyle,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.WaterfallChartColumnStyle]
        $PositiveColumnsStyle,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.WaterfallChartColumnStyle]
        $SubtotalColumnsStyle,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.WaterfallChartSeries[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.WaterfallChartSeries'
                    foreach ($prop in $PSBoundParameters.Keys | Where-Object {$obj.PSObject.Properties.Name -contains $_}) {
                        switch ($prop) {
                            CustomSubtotals {
                                $list = New-Object 'System.Collections.Generic.List[Google.Apis.Sheets.v4.Data.WaterfallChartCustomSubtotal]'
                                foreach ($item in $CustomSubtotals) {
                                    $list.Add($item)
                                }
                                $obj.CustomSubtotals = $list
                            }
                            default {
                                $obj.$prop = $PSBoundParameters[$prop]
                            }
                        }
                    }
                    $obj
                }
                InputObject {
                    foreach ($iObj in $InputObject) {
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.WaterfallChartSeries'
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
