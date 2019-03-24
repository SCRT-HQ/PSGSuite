function Add-GSSheetExtendedValue {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.ExtendedValue object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.ExtendedValue object.

    .PARAMETER BoolValue
    Accepts the following type: bool

    .PARAMETER ErrorValue
    Accepts the following type: Google.Apis.Sheets.v4.Data.ErrorValue

    .PARAMETER FormulaValue
    Accepts the following type: string

    .PARAMETER NumberValue
    Accepts the following type: double

    .PARAMETER StringValue
    Accepts the following type: string

    .EXAMPLE
    Add-GSSheetExtendedValue -BoolValue $boolValue -ErrorValue $errorValue -FormulaValue $formulaValue -NumberValue $numberValue -StringValue $stringValue
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.ExtendedValue')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [bool]
        $BoolValue,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.ErrorValue]
        $ErrorValue,
        [parameter()]
        [string]
        $FormulaValue,
        [parameter()]
        [double]
        $NumberValue,
        [parameter()]
        [string]
        $StringValue,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.ExtendedValue[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.ExtendedValue'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.ExtendedValue'
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
