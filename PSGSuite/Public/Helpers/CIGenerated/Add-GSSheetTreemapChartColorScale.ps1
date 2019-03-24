function Add-GSSheetTreemapChartColorScale {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.TreemapChartColorScale object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.TreemapChartColorScale object.

    .PARAMETER MaxValueColor
    Accepts the following type: Google.Apis.Sheets.v4.Data.Color

    .PARAMETER MidValueColor
    Accepts the following type: Google.Apis.Sheets.v4.Data.Color

    .PARAMETER MinValueColor
    Accepts the following type: Google.Apis.Sheets.v4.Data.Color

    .PARAMETER NoDataColor
    Accepts the following type: Google.Apis.Sheets.v4.Data.Color

    .EXAMPLE
    Add-GSSheetTreemapChartColorScale -MaxValueColor $maxValueColor -MidValueColor $midValueColor -MinValueColor $minValueColor -NoDataColor $noDataColor
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.TreemapChartColorScale')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.Color]
        $MaxValueColor,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.Color]
        $MidValueColor,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.Color]
        $MinValueColor,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.Color]
        $NoDataColor,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.TreemapChartColorScale[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.TreemapChartColorScale'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.TreemapChartColorScale'
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
