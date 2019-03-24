function Add-GSSheetWaterfallChartDomain {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.WaterfallChartDomain object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.WaterfallChartDomain object.

    .PARAMETER Data
    Accepts the following type: Google.Apis.Sheets.v4.Data.ChartData

    .PARAMETER Reversed
    Accepts the following type: bool

    .EXAMPLE
    Add-GSSheetWaterfallChartDomain -Data $data -Reversed $reversed
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.WaterfallChartDomain')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.ChartData]
        $Data,
        [parameter()]
        [bool]
        $Reversed,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.WaterfallChartDomain[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.WaterfallChartDomain'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.WaterfallChartDomain'
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
