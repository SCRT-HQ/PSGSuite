function Add-GSSheetPivotGroupRule {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.PivotGroupRule object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.PivotGroupRule object.

    .PARAMETER DateTimeRule
    Accepts the following type: [Google.Apis.Sheets.v4.Data.DateTimeRule].

    To create this type, use the function Add-GSSheetDateTimeRule or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.DateTimeRule'.

    .PARAMETER HistogramRule
    Accepts the following type: [Google.Apis.Sheets.v4.Data.HistogramRule].

    To create this type, use the function Add-GSSheetHistogramRule or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.HistogramRule'.

    .PARAMETER ManualRule
    Accepts the following type: [Google.Apis.Sheets.v4.Data.ManualRule].

    To create this type, use the function Add-GSSheetManualRule or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.ManualRule'.

    .EXAMPLE
    Add-GSSheetPivotGroupRule -DateTimeRule $dateTimeRule -HistogramRule $histogramRule -ManualRule $manualRule
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.PivotGroupRule')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.DateTimeRule]
        $DateTimeRule,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.HistogramRule]
        $HistogramRule,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.ManualRule]
        $ManualRule,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.PivotGroupRule[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.PivotGroupRule'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.PivotGroupRule'
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
