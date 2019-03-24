function Add-GSSheetPivotGroup {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.PivotGroup object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.PivotGroup object.

    .PARAMETER GroupRule
    Accepts the following type: [Google.Apis.Sheets.v4.Data.PivotGroupRule].

    To create this type, use the function Add-GSSheetPivotGroupRule or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.PivotGroupRule'.

    .PARAMETER Label
    Accepts the following type: [string].

    .PARAMETER RepeatHeadings
    Accepts the following type: [switch].

    .PARAMETER ShowTotals
    Accepts the following type: [switch].

    .PARAMETER SortOrder
    Accepts the following type: [string].

    .PARAMETER SourceColumnOffset
    Accepts the following type: [int].

    .PARAMETER ValueBucket
    Accepts the following type: [Google.Apis.Sheets.v4.Data.PivotGroupSortValueBucket].

    To create this type, use the function Add-GSSheetPivotGroupSortValueBucket or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.PivotGroupSortValueBucket'.

    .PARAMETER ValueMetadata
    Accepts the following type: [Google.Apis.Sheets.v4.Data.PivotGroupValueMetadata[]].

    To create this type, use the function Add-GSSheetPivotGroupValueMetadata or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.PivotGroupValueMetadata'.

    .EXAMPLE
    Add-GSSheetPivotGroup -GroupRule $groupRule -Label $label -RepeatHeadings $repeatHeadings -ShowTotals $showTotals -SortOrder $sortOrder -SourceColumnOffset $sourceColumnOffset -ValueBucket $valueBucket -ValueMetadata $valueMetadata
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.PivotGroup')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.PivotGroupRule]
        $GroupRule,
        [parameter()]
        [string]
        $Label,
        [parameter()]
        [switch]
        $RepeatHeadings,
        [parameter()]
        [switch]
        $ShowTotals,
        [parameter()]
        [string]
        $SortOrder,
        [parameter()]
        [int]
        $SourceColumnOffset,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.PivotGroupSortValueBucket]
        $ValueBucket,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.PivotGroupValueMetadata[]]
        $ValueMetadata,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.PivotGroup[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.PivotGroup'
                    foreach ($prop in $PSBoundParameters.Keys | Where-Object {$obj.PSObject.Properties.Name -contains $_}) {
                        switch ($prop) {
                            ValueMetadata {
                                $list = New-Object 'System.Collections.Generic.List[Google.Apis.Sheets.v4.Data.PivotGroupValueMetadata]'
                                foreach ($item in $ValueMetadata) {
                                    $list.Add($item)
                                }
                                $obj.ValueMetadata = $list
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.PivotGroup'
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
