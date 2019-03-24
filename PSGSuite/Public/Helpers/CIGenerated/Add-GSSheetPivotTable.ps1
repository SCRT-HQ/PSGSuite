function Add-GSSheetPivotTable {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.PivotTable object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.PivotTable object.

    .PARAMETER Columns
    Accepts the following type: System.Collections.Generic.IList[Google.Apis.Sheets.v4.Data.PivotGroup][]

    .PARAMETER Criteria
    Accepts the following type: System.Collections.Generic.IDictionary[string,Google.Apis.Sheets.v4.Data.PivotFilterCriteria]

    .PARAMETER Rows
    Accepts the following type: System.Collections.Generic.IList[Google.Apis.Sheets.v4.Data.PivotGroup][]

    .PARAMETER Source
    Accepts the following type: Google.Apis.Sheets.v4.Data.GridRange

    .PARAMETER ValueLayout
    Accepts the following type: string

    .PARAMETER Values
    Accepts the following type: System.Collections.Generic.IList[Google.Apis.Sheets.v4.Data.PivotValue][]

    .EXAMPLE
    Add-GSSheetPivotTable -Columns $columns -Criteria $criteria -Rows $rows -Source $source -ValueLayout $valueLayout -Values $values
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.PivotTable')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [System.Collections.Generic.IList[Google.Apis.Sheets.v4.Data.PivotGroup][]]
        $Columns,
        [parameter()]
        [System.Collections.Generic.IDictionary[string,Google.Apis.Sheets.v4.Data.PivotFilterCriteria]]
        $Criteria,
        [parameter()]
        [System.Collections.Generic.IList[Google.Apis.Sheets.v4.Data.PivotGroup][]]
        $Rows,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.GridRange]
        $Source,
        [parameter()]
        [string]
        $ValueLayout,
        [parameter()]
        [System.Collections.Generic.IList[Google.Apis.Sheets.v4.Data.PivotValue][]]
        $Values,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.PivotTable[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.PivotTable'
                    foreach ($prop in $PSBoundParameters.Keys | Where-Object {$obj.PSObject.Properties.Name -contains $_}) {
                        switch ($prop) {
                            Columns {
                                $list = New-Object 'System.Collections.Generic.List[System.Collections.Generic.IList[Google.Apis.Sheets.v4.Data.PivotGroup]]'
                                foreach ($item in $Columns) {
                                    $list.Add($item)
                                }
                                $obj.Columns = $list
                            }
                            Rows {
                                $list = New-Object 'System.Collections.Generic.List[System.Collections.Generic.IList[Google.Apis.Sheets.v4.Data.PivotGroup]]'
                                foreach ($item in $Rows) {
                                    $list.Add($item)
                                }
                                $obj.Rows = $list
                            }
                            Values {
                                $list = New-Object 'System.Collections.Generic.List[System.Collections.Generic.IList[Google.Apis.Sheets.v4.Data.PivotValue]]'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.PivotTable'
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
