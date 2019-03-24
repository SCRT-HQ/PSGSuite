function Add-GSSheetCellData {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.CellData object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.CellData object.

    .PARAMETER DataValidation
    Accepts the following type: Google.Apis.Sheets.v4.Data.DataValidationRule

    .PARAMETER EffectiveFormat
    Accepts the following type: Google.Apis.Sheets.v4.Data.CellFormat

    .PARAMETER EffectiveValue
    Accepts the following type: Google.Apis.Sheets.v4.Data.ExtendedValue

    .PARAMETER FormattedValue
    Accepts the following type: string

    .PARAMETER Hyperlink
    Accepts the following type: string

    .PARAMETER Note
    Accepts the following type: string

    .PARAMETER PivotTable
    Accepts the following type: Google.Apis.Sheets.v4.Data.PivotTable

    .PARAMETER TextFormatRuns
    Accepts the following type: System.Collections.Generic.IList[Google.Apis.Sheets.v4.Data.TextFormatRun][]

    .PARAMETER UserEnteredFormat
    Accepts the following type: Google.Apis.Sheets.v4.Data.CellFormat

    .PARAMETER UserEnteredValue
    Accepts the following type: Google.Apis.Sheets.v4.Data.ExtendedValue

    .EXAMPLE
    Add-GSSheetCellData -DataValidation $dataValidation -EffectiveFormat $effectiveFormat -EffectiveValue $effectiveValue -FormattedValue $formattedValue -Hyperlink $hyperlink -Note $note -PivotTable $pivotTable -TextFormatRuns $textFormatRuns -UserEnteredFormat $userEnteredFormat -UserEnteredValue $userEnteredValue
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.CellData')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.DataValidationRule]
        $DataValidation,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.CellFormat]
        $EffectiveFormat,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.ExtendedValue]
        $EffectiveValue,
        [parameter()]
        [string]
        $FormattedValue,
        [parameter()]
        [string]
        $Hyperlink,
        [parameter()]
        [string]
        $Note,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.PivotTable]
        $PivotTable,
        [parameter()]
        [System.Collections.Generic.IList[Google.Apis.Sheets.v4.Data.TextFormatRun][]]
        $TextFormatRuns,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.CellFormat]
        $UserEnteredFormat,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.ExtendedValue]
        $UserEnteredValue,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.CellData[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.CellData'
                    foreach ($prop in $PSBoundParameters.Keys | Where-Object {$obj.PSObject.Properties.Name -contains $_}) {
                        switch ($prop) {
                            TextFormatRuns {
                                $list = New-Object 'System.Collections.Generic.List[System.Collections.Generic.IList[Google.Apis.Sheets.v4.Data.TextFormatRun]]'
                                foreach ($item in $TextFormatRuns) {
                                    $list.Add($item)
                                }
                                $obj.TextFormatRuns = $list
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.CellData'
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
