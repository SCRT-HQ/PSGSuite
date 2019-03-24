function Add-GSSheetConditionalFormatRule {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.ConditionalFormatRule object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.ConditionalFormatRule object.

    .PARAMETER BooleanRule
    Accepts the following type: [Google.Apis.Sheets.v4.Data.BooleanRule].

    To create this type, use the function Add-GSSheetBooleanRule or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.BooleanRule'.

    .PARAMETER GradientRule
    Accepts the following type: [Google.Apis.Sheets.v4.Data.GradientRule].

    To create this type, use the function Add-GSSheetGradientRule or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.GradientRule'.

    .PARAMETER Ranges
    Accepts the following type: [Google.Apis.Sheets.v4.Data.GridRange[]].

    To create this type, use the function Add-GSSheetGridRange or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.GridRange'.

    .EXAMPLE
    Add-GSSheetConditionalFormatRule -BooleanRule $booleanRule -GradientRule $gradientRule -Ranges $ranges
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.ConditionalFormatRule')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.BooleanRule]
        $BooleanRule,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.GradientRule]
        $GradientRule,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.GridRange[]]
        $Ranges,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.ConditionalFormatRule[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.ConditionalFormatRule'
                    foreach ($prop in $PSBoundParameters.Keys | Where-Object {$obj.PSObject.Properties.Name -contains $_}) {
                        switch ($prop) {
                            Ranges {
                                $list = New-Object 'System.Collections.Generic.List[Google.Apis.Sheets.v4.Data.GridRange]'
                                foreach ($item in $Ranges) {
                                    $list.Add($item)
                                }
                                $obj.Ranges = $list
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.ConditionalFormatRule'
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
