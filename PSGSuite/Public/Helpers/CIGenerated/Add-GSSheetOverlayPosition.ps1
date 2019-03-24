function Add-GSSheetOverlayPosition {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.OverlayPosition object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.OverlayPosition object.

    .PARAMETER AnchorCell
    Accepts the following type: Google.Apis.Sheets.v4.Data.GridCoordinate

    .PARAMETER HeightPixels
    Accepts the following type: int

    .PARAMETER OffsetXPixels
    Accepts the following type: int

    .PARAMETER OffsetYPixels
    Accepts the following type: int

    .PARAMETER WidthPixels
    Accepts the following type: int

    .EXAMPLE
    Add-GSSheetOverlayPosition -AnchorCell $anchorCell -HeightPixels $heightPixels -OffsetXPixels $offsetXPixels -OffsetYPixels $offsetYPixels -WidthPixels $widthPixels
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.OverlayPosition')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.GridCoordinate]
        $AnchorCell,
        [parameter()]
        [int]
        $HeightPixels,
        [parameter()]
        [int]
        $OffsetXPixels,
        [parameter()]
        [int]
        $OffsetYPixels,
        [parameter()]
        [int]
        $WidthPixels,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.OverlayPosition[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.OverlayPosition'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.OverlayPosition'
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
