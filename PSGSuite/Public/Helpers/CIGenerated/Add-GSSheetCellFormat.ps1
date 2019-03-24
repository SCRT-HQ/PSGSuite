function Add-GSSheetCellFormat {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.CellFormat object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.CellFormat object.

    .PARAMETER BackgroundColor
    Accepts the following type: [Google.Apis.Sheets.v4.Data.Color].

    To create this type, use the function Add-GSSheetColor or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.Color'.

    .PARAMETER Borders
    Accepts the following type: [Google.Apis.Sheets.v4.Data.Borders].

    To create this type, use the function Add-GSSheetBorders or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.Borders'.

    .PARAMETER HorizontalAlignment
    Accepts the following type: [string].

    .PARAMETER HyperlinkDisplayType
    Accepts the following type: [string].

    .PARAMETER NumberFormat
    Accepts the following type: [Google.Apis.Sheets.v4.Data.NumberFormat].

    To create this type, use the function Add-GSSheetNumberFormat or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.NumberFormat'.

    .PARAMETER Padding
    Accepts the following type: [Google.Apis.Sheets.v4.Data.Padding].

    To create this type, use the function Add-GSSheetPadding or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.Padding'.

    .PARAMETER TextDirection
    Accepts the following type: [string].

    .PARAMETER TextFormat
    Accepts the following type: [Google.Apis.Sheets.v4.Data.TextFormat].

    To create this type, use the function Add-GSSheetTextFormat or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.TextFormat'.

    .PARAMETER TextRotation
    Accepts the following type: [Google.Apis.Sheets.v4.Data.TextRotation].

    To create this type, use the function Add-GSSheetTextRotation or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.TextRotation'.

    .PARAMETER VerticalAlignment
    Accepts the following type: [string].

    .PARAMETER WrapStrategy
    Accepts the following type: [string].

    .EXAMPLE
    Add-GSSheetCellFormat -BackgroundColor $backgroundColor -Borders $borders -HorizontalAlignment $horizontalAlignment -HyperlinkDisplayType $hyperlinkDisplayType -NumberFormat $numberFormat -Padding $padding -TextDirection $textDirection -TextFormat $textFormat -TextRotation $textRotation -VerticalAlignment $verticalAlignment -WrapStrategy $wrapStrategy
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.CellFormat')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.Color]
        $BackgroundColor,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.Borders]
        $Borders,
        [parameter()]
        [string]
        $HorizontalAlignment,
        [parameter()]
        [string]
        $HyperlinkDisplayType,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.NumberFormat]
        $NumberFormat,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.Padding]
        $Padding,
        [parameter()]
        [string]
        $TextDirection,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.TextFormat]
        $TextFormat,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.TextRotation]
        $TextRotation,
        [parameter()]
        [string]
        $VerticalAlignment,
        [parameter()]
        [string]
        $WrapStrategy,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.CellFormat[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.CellFormat'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.CellFormat'
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
