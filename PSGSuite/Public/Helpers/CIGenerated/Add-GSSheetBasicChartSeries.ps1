function Add-GSSheetBasicChartSeries {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.BasicChartSeries object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.BasicChartSeries object.

    .PARAMETER Color
    Accepts the following type: [Google.Apis.Sheets.v4.Data.Color].

    To create this type, use the function Add-GSSheetColor or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.Color'.

    .PARAMETER LineStyle
    Accepts the following type: [Google.Apis.Sheets.v4.Data.LineStyle].

    To create this type, use the function Add-GSSheetLineStyle or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.LineStyle'.

    .PARAMETER Series
    Accepts the following type: [Google.Apis.Sheets.v4.Data.ChartData].

    To create this type, use the function Add-GSSheetChartData or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.ChartData'.

    .PARAMETER TargetAxis
    Accepts the following type: [string].

    .PARAMETER Type
    Accepts the following type: [string].

    .EXAMPLE
    Add-GSSheetBasicChartSeries -Color $color -LineStyle $lineStyle -Series $series -TargetAxis $targetAxis -Type $type
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.BasicChartSeries')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.Color]
        $Color,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.LineStyle]
        $LineStyle,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.ChartData]
        $Series,
        [parameter()]
        [string]
        $TargetAxis,
        [parameter()]
        [string]
        $Type,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.BasicChartSeries[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.BasicChartSeries'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.BasicChartSeries'
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
