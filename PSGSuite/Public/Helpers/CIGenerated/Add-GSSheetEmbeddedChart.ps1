function Add-GSSheetEmbeddedChart {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.EmbeddedChart object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.EmbeddedChart object.

    .PARAMETER ChartId
    Accepts the following type: [int].

    .PARAMETER Position
    Accepts the following type: [Google.Apis.Sheets.v4.Data.EmbeddedObjectPosition].

    To create this type, use the function Add-GSSheetEmbeddedObjectPosition or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.EmbeddedObjectPosition'.

    .PARAMETER Spec
    Accepts the following type: [Google.Apis.Sheets.v4.Data.ChartSpec].

    To create this type, use the function Add-GSSheetChartSpec or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.ChartSpec'.

    .EXAMPLE
    Add-GSSheetEmbeddedChart -ChartId $chartId -Position $position -Spec $spec
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.EmbeddedChart')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [int]
        $ChartId,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.EmbeddedObjectPosition]
        $Position,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.ChartSpec]
        $Spec,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.EmbeddedChart[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.EmbeddedChart'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.EmbeddedChart'
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
