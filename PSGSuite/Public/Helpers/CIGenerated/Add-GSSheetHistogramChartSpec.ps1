function Add-GSSheetHistogramChartSpec {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.HistogramChartSpec object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.HistogramChartSpec object.

    .PARAMETER BucketSize
    Accepts the following type: double

    .PARAMETER LegendPosition
    Accepts the following type: string

    .PARAMETER OutlierPercentile
    Accepts the following type: double

    .PARAMETER Series
    Accepts the following type: System.Collections.Generic.IList[Google.Apis.Sheets.v4.Data.HistogramSeries][]

    .PARAMETER ShowItemDividers
    Accepts the following type: bool

    .EXAMPLE
    Add-GSSheetHistogramChartSpec -BucketSize $bucketSize -LegendPosition $legendPosition -OutlierPercentile $outlierPercentile -Series $series -ShowItemDividers $showItemDividers
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.HistogramChartSpec')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [double]
        $BucketSize,
        [parameter()]
        [string]
        $LegendPosition,
        [parameter()]
        [double]
        $OutlierPercentile,
        [parameter()]
        [System.Collections.Generic.IList[Google.Apis.Sheets.v4.Data.HistogramSeries][]]
        $Series,
        [parameter()]
        [bool]
        $ShowItemDividers,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.HistogramChartSpec[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.HistogramChartSpec'
                    foreach ($prop in $PSBoundParameters.Keys | Where-Object {$obj.PSObject.Properties.Name -contains $_}) {
                        switch ($prop) {
                            Series {
                                $list = New-Object 'System.Collections.Generic.List[System.Collections.Generic.IList[Google.Apis.Sheets.v4.Data.HistogramSeries]]'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.HistogramChartSpec'
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
