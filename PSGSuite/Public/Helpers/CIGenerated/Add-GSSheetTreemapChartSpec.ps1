function Add-GSSheetTreemapChartSpec {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.TreemapChartSpec object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.TreemapChartSpec object.

    .PARAMETER ColorData
    Accepts the following type: [Google.Apis.Sheets.v4.Data.ChartData].

    To create this type, use the function Add-GSSheetChartData or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.ChartData'.

    .PARAMETER ColorScale
    Accepts the following type: [Google.Apis.Sheets.v4.Data.TreemapChartColorScale].

    To create this type, use the function Add-GSSheetTreemapChartColorScale or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.TreemapChartColorScale'.

    .PARAMETER HeaderColor
    Accepts the following type: [Google.Apis.Sheets.v4.Data.Color].

    To create this type, use the function Add-GSSheetColor or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.Color'.

    .PARAMETER HideTooltips
    Accepts the following type: [switch].

    .PARAMETER HintedLevels
    Accepts the following type: [int].

    .PARAMETER Labels
    Accepts the following type: [Google.Apis.Sheets.v4.Data.ChartData].

    To create this type, use the function Add-GSSheetChartData or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.ChartData'.

    .PARAMETER Levels
    Accepts the following type: [int].

    .PARAMETER MaxValue
    Accepts the following type: [double].

    .PARAMETER MinValue
    Accepts the following type: [double].

    .PARAMETER ParentLabels
    Accepts the following type: [Google.Apis.Sheets.v4.Data.ChartData].

    To create this type, use the function Add-GSSheetChartData or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.ChartData'.

    .PARAMETER SizeData
    Accepts the following type: [Google.Apis.Sheets.v4.Data.ChartData].

    To create this type, use the function Add-GSSheetChartData or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.ChartData'.

    .PARAMETER TextFormat
    Accepts the following type: [Google.Apis.Sheets.v4.Data.TextFormat].

    To create this type, use the function Add-GSSheetTextFormat or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.TextFormat'.

    .EXAMPLE
    Add-GSSheetTreemapChartSpec -ColorData $colorData -ColorScale $colorScale -HeaderColor $headerColor -HideTooltips $hideTooltips -HintedLevels $hintedLevels -Labels $labels -Levels $levels -MaxValue $maxValue -MinValue $minValue -ParentLabels $parentLabels -SizeData $sizeData -TextFormat $textFormat
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.TreemapChartSpec')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.ChartData]
        $ColorData,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.TreemapChartColorScale]
        $ColorScale,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.Color]
        $HeaderColor,
        [parameter()]
        [switch]
        $HideTooltips,
        [parameter()]
        [int]
        $HintedLevels,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.ChartData]
        $Labels,
        [parameter()]
        [int]
        $Levels,
        [parameter()]
        [double]
        $MaxValue,
        [parameter()]
        [double]
        $MinValue,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.ChartData]
        $ParentLabels,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.ChartData]
        $SizeData,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.TextFormat]
        $TextFormat,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.TreemapChartSpec[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.TreemapChartSpec'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.TreemapChartSpec'
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
