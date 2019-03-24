function Add-GSSheetWaterfallChartCustomSubtotal {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.WaterfallChartCustomSubtotal object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.WaterfallChartCustomSubtotal object.

    .PARAMETER DataIsSubtotal
    Accepts the following type: [switch].

    .PARAMETER Label
    Accepts the following type: [string].

    .PARAMETER SubtotalIndex
    Accepts the following type: [int].

    .EXAMPLE
    Add-GSSheetWaterfallChartCustomSubtotal -DataIsSubtotal $dataIsSubtotal -Label $label -SubtotalIndex $subtotalIndex
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.WaterfallChartCustomSubtotal')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [switch]
        $DataIsSubtotal,
        [parameter()]
        [string]
        $Label,
        [parameter()]
        [int]
        $SubtotalIndex,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.WaterfallChartCustomSubtotal[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.WaterfallChartCustomSubtotal'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.WaterfallChartCustomSubtotal'
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
