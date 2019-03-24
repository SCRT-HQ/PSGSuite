function Add-GSSheetWaterfallChartColumnStyle {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.WaterfallChartColumnStyle object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.WaterfallChartColumnStyle object.

    .PARAMETER Color
    Accepts the following type: [Google.Apis.Sheets.v4.Data.Color].

    To create this type, use the function Add-GSSheetColor or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.Color'.

    .PARAMETER Label
    Accepts the following type: [string].

    .EXAMPLE
    Add-GSSheetWaterfallChartColumnStyle -Color $color -Label $label
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.WaterfallChartColumnStyle')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.Color]
        $Color,
        [parameter()]
        [string]
        $Label,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.WaterfallChartColumnStyle[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.WaterfallChartColumnStyle'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.WaterfallChartColumnStyle'
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
