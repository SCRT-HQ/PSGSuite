function Add-GSSheetWaterfallChartSpec {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.WaterfallChartSpec object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.WaterfallChartSpec object.

    .PARAMETER ConnectorLineStyle
    Accepts the following type: Google.Apis.Sheets.v4.Data.LineStyle

    .PARAMETER Domain
    Accepts the following type: Google.Apis.Sheets.v4.Data.WaterfallChartDomain

    .PARAMETER FirstValueIsTotal
    Accepts the following type: bool

    .PARAMETER HideConnectorLines
    Accepts the following type: bool

    .PARAMETER Series
    Accepts the following type: System.Collections.Generic.IList[Google.Apis.Sheets.v4.Data.WaterfallChartSeries][]

    .PARAMETER StackedType
    Accepts the following type: string

    .EXAMPLE
    Add-GSSheetWaterfallChartSpec -ConnectorLineStyle $connectorLineStyle -Domain $domain -FirstValueIsTotal $firstValueIsTotal -HideConnectorLines $hideConnectorLines -Series $series -StackedType $stackedType
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.WaterfallChartSpec')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.LineStyle]
        $ConnectorLineStyle,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.WaterfallChartDomain]
        $Domain,
        [parameter()]
        [bool]
        $FirstValueIsTotal,
        [parameter()]
        [bool]
        $HideConnectorLines,
        [parameter()]
        [System.Collections.Generic.IList[Google.Apis.Sheets.v4.Data.WaterfallChartSeries][]]
        $Series,
        [parameter()]
        [string]
        $StackedType,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.WaterfallChartSpec[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.WaterfallChartSpec'
                    foreach ($prop in $PSBoundParameters.Keys | Where-Object {$obj.PSObject.Properties.Name -contains $_}) {
                        switch ($prop) {
                            Series {
                                $list = New-Object 'System.Collections.Generic.List[System.Collections.Generic.IList[Google.Apis.Sheets.v4.Data.WaterfallChartSeries]]'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.WaterfallChartSpec'
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
