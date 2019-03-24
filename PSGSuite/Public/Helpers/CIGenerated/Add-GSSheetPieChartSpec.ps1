function Add-GSSheetPieChartSpec {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.PieChartSpec object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.PieChartSpec object.

    .PARAMETER Domain
    Accepts the following type: Google.Apis.Sheets.v4.Data.ChartData

    .PARAMETER LegendPosition
    Accepts the following type: string

    .PARAMETER PieHole
    Accepts the following type: double

    .PARAMETER Series
    Accepts the following type: Google.Apis.Sheets.v4.Data.ChartData

    .PARAMETER ThreeDimensional
    Accepts the following type: bool

    .EXAMPLE
    Add-GSSheetPieChartSpec -Domain $domain -LegendPosition $legendPosition -PieHole $pieHole -Series $series -ThreeDimensional $threeDimensional
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.PieChartSpec')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.ChartData]
        $Domain,
        [parameter()]
        [string]
        $LegendPosition,
        [parameter()]
        [double]
        $PieHole,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.ChartData]
        $Series,
        [parameter()]
        [bool]
        $ThreeDimensional,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.PieChartSpec[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.PieChartSpec'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.PieChartSpec'
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
