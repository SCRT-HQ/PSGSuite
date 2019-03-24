function Add-GSSheetSpreadsheetProperties {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.SpreadsheetProperties object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.SpreadsheetProperties object.

    .PARAMETER AutoRecalc
    Accepts the following type: [string].

    .PARAMETER DefaultFormat
    Accepts the following type: [Google.Apis.Sheets.v4.Data.CellFormat].

    To create this type, use the function Add-GSSheetCellFormat or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.CellFormat'.

    .PARAMETER IterativeCalculationSettings
    Accepts the following type: [Google.Apis.Sheets.v4.Data.IterativeCalculationSettings].

    To create this type, use the function Add-GSSheetIterativeCalculationSettings or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.IterativeCalculationSettings'.

    .PARAMETER Locale
    Accepts the following type: [string].

    .PARAMETER TimeZone
    Accepts the following type: [string].

    .PARAMETER Title
    Accepts the following type: [string].

    .EXAMPLE
    Add-GSSheetSpreadsheetProperties -AutoRecalc $autoRecalc -DefaultFormat $defaultFormat -IterativeCalculationSettings $iterativeCalculationSettings -Locale $locale -TimeZone $timeZone -Title $title
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.SpreadsheetProperties')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [string]
        $AutoRecalc,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.CellFormat]
        $DefaultFormat,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.IterativeCalculationSettings]
        $IterativeCalculationSettings,
        [parameter()]
        [string]
        $Locale,
        [parameter()]
        [string]
        $TimeZone,
        [parameter()]
        [string]
        $Title,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.SpreadsheetProperties[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.SpreadsheetProperties'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.SpreadsheetProperties'
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
