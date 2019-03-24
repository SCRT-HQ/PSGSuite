function Add-GSSheetDataValidationRule {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.DataValidationRule object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.DataValidationRule object.

    .PARAMETER Condition
    Accepts the following type: [Google.Apis.Sheets.v4.Data.BooleanCondition].

    To create this type, use the function Add-GSSheetBooleanCondition or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.BooleanCondition'.

    .PARAMETER InputMessage
    Accepts the following type: [string].

    .PARAMETER ShowCustomUi
    Accepts the following type: [switch].

    .PARAMETER Strict
    Accepts the following type: [switch].

    .EXAMPLE
    Add-GSSheetDataValidationRule -Condition $condition -InputMessage $inputMessage -ShowCustomUi $showCustomUi -Strict $strict
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.DataValidationRule')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.BooleanCondition]
        $Condition,
        [parameter()]
        [string]
        $InputMessage,
        [parameter()]
        [switch]
        $ShowCustomUi,
        [parameter()]
        [switch]
        $Strict,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.DataValidationRule[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.DataValidationRule'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.DataValidationRule'
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
