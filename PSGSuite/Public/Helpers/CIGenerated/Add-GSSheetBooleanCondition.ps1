function Add-GSSheetBooleanCondition {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.BooleanCondition object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.BooleanCondition object.

    .PARAMETER Type
    Accepts the following type: string

    .PARAMETER Values
    Accepts the following type: System.Collections.Generic.IList[Google.Apis.Sheets.v4.Data.ConditionValue][]

    .EXAMPLE
    Add-GSSheetBooleanCondition -Type $type -Values $values
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.BooleanCondition')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [string]
        $Type,
        [parameter()]
        [System.Collections.Generic.IList[Google.Apis.Sheets.v4.Data.ConditionValue][]]
        $Values,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.BooleanCondition[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.BooleanCondition'
                    foreach ($prop in $PSBoundParameters.Keys | Where-Object {$obj.PSObject.Properties.Name -contains $_}) {
                        switch ($prop) {
                            Values {
                                $list = New-Object 'System.Collections.Generic.List[System.Collections.Generic.IList[Google.Apis.Sheets.v4.Data.ConditionValue]]'
                                foreach ($item in $Values) {
                                    $list.Add($item)
                                }
                                $obj.Values = $list
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.BooleanCondition'
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
