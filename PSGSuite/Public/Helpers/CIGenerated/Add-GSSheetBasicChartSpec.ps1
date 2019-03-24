function Add-GSSheetBasicChartSpec {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.BasicChartSpec object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.BasicChartSpec object.

    .PARAMETER Axis
    Accepts the following type: [Google.Apis.Sheets.v4.Data.BasicChartAxis[]].

    To create this type, use the function Add-GSSheetBasicChartAxis or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.BasicChartAxis'.

    .PARAMETER ChartType
    Accepts the following type: [string].

    .PARAMETER CompareMode
    Accepts the following type: [string].

    .PARAMETER Domains
    Accepts the following type: [Google.Apis.Sheets.v4.Data.BasicChartDomain[]].

    To create this type, use the function Add-GSSheetBasicChartDomain or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.BasicChartDomain'.

    .PARAMETER HeaderCount
    Accepts the following type: [int].

    .PARAMETER InterpolateNulls
    Accepts the following type: [switch].

    .PARAMETER LegendPosition
    Accepts the following type: [string].

    .PARAMETER LineSmoothing
    Accepts the following type: [switch].

    .PARAMETER Series
    Accepts the following type: [Google.Apis.Sheets.v4.Data.BasicChartSeries[]].

    To create this type, use the function Add-GSSheetBasicChartSeries or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.BasicChartSeries'.

    .PARAMETER StackedType
    Accepts the following type: [string].

    .PARAMETER ThreeDimensional
    Accepts the following type: [switch].

    .EXAMPLE
    Add-GSSheetBasicChartSpec -Axis $axis -ChartType $chartType -CompareMode $compareMode -Domains $domains -HeaderCount $headerCount -InterpolateNulls $interpolateNulls -LegendPosition $legendPosition -LineSmoothing $lineSmoothing -Series $series -StackedType $stackedType -ThreeDimensional $threeDimensional
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.BasicChartSpec')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.BasicChartAxis[]]
        $Axis,
        [parameter()]
        [string]
        $ChartType,
        [parameter()]
        [string]
        $CompareMode,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.BasicChartDomain[]]
        $Domains,
        [parameter()]
        [int]
        $HeaderCount,
        [parameter()]
        [switch]
        $InterpolateNulls,
        [parameter()]
        [string]
        $LegendPosition,
        [parameter()]
        [switch]
        $LineSmoothing,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.BasicChartSeries[]]
        $Series,
        [parameter()]
        [string]
        $StackedType,
        [parameter()]
        [switch]
        $ThreeDimensional,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.BasicChartSpec[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.BasicChartSpec'
                    foreach ($prop in $PSBoundParameters.Keys | Where-Object {$obj.PSObject.Properties.Name -contains $_}) {
                        switch ($prop) {
                            Axis {
                                $list = New-Object 'System.Collections.Generic.List[Google.Apis.Sheets.v4.Data.BasicChartAxis]'
                                foreach ($item in $Axis) {
                                    $list.Add($item)
                                }
                                $obj.Axis = $list
                            }
                            Domains {
                                $list = New-Object 'System.Collections.Generic.List[Google.Apis.Sheets.v4.Data.BasicChartDomain]'
                                foreach ($item in $Domains) {
                                    $list.Add($item)
                                }
                                $obj.Domains = $list
                            }
                            Series {
                                $list = New-Object 'System.Collections.Generic.List[Google.Apis.Sheets.v4.Data.BasicChartSeries]'
                                foreach ($item in $Series) {
                                    $list.Add($item)
                                }
                                $obj.Series = $list
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.BasicChartSpec'
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
