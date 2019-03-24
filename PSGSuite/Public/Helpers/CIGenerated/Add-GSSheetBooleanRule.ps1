function Add-GSSheetBooleanRule {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.BooleanRule object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.BooleanRule object.

    .PARAMETER Condition
    Accepts the following type: [Google.Apis.Sheets.v4.Data.BooleanCondition].

    To create this type, use the function Add-GSSheetBooleanCondition or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.BooleanCondition'.

    .PARAMETER Format
    Accepts the following type: [Google.Apis.Sheets.v4.Data.CellFormat].

    To create this type, use the function Add-GSSheetCellFormat or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.CellFormat'.

    .EXAMPLE
    Add-GSSheetBooleanRule -Condition $condition -Format $format
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.BooleanRule')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.BooleanCondition]
        $Condition,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.CellFormat]
        $Format,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.BooleanRule[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.BooleanRule'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.BooleanRule'
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
