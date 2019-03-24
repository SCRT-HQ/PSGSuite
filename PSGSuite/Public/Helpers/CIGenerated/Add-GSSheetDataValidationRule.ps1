function Add-GSSheetDataValidationRule {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.DataValidationRule object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.DataValidationRule object.

    .PARAMETER Condition
    Accepts the following type: Google.Apis.Sheets.v4.Data.BooleanCondition

    .PARAMETER InputMessage
    Accepts the following type: string

    .PARAMETER ShowCustomUi
    Accepts the following type: bool

    .PARAMETER Strict
    Accepts the following type: bool

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
        [bool]
        $ShowCustomUi,
        [parameter()]
        [bool]
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
