function Add-GSSheetFilterView {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.FilterView object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.FilterView object.

    .PARAMETER Criteria
    Accepts the following type: [string,Google.Apis.Sheets.v4.Data.FilterCriteria].

    .PARAMETER FilterViewId
    Accepts the following type: [int].

    .PARAMETER NamedRangeId
    Accepts the following type: [string].

    .PARAMETER Range
    Accepts the following type: [Google.Apis.Sheets.v4.Data.GridRange].

    To create this type, use the function Add-GSSheetGridRange or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.GridRange'.

    .PARAMETER SortSpecs
    Accepts the following type: [Google.Apis.Sheets.v4.Data.SortSpec[]].

    To create this type, use the function Add-GSSheetSortSpec or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.SortSpec'.

    .PARAMETER Title
    Accepts the following type: [string].

    .EXAMPLE
    Add-GSSheetFilterView -Criteria $criteria -FilterViewId $filterViewId -NamedRangeId $namedRangeId -Range $range -SortSpecs $sortSpecs -Title $title
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.FilterView')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [string,Google.Apis.Sheets.v4.Data.FilterCriteria]
        $Criteria,
        [parameter()]
        [int]
        $FilterViewId,
        [parameter()]
        [string]
        $NamedRangeId,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.GridRange]
        $Range,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.SortSpec[]]
        $SortSpecs,
        [parameter()]
        [string]
        $Title,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.FilterView[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.FilterView'
                    foreach ($prop in $PSBoundParameters.Keys | Where-Object {$obj.PSObject.Properties.Name -contains $_}) {
                        switch ($prop) {
                            SortSpecs {
                                $list = New-Object 'System.Collections.Generic.List[Google.Apis.Sheets.v4.Data.SortSpec]'
                                foreach ($item in $SortSpecs) {
                                    $list.Add($item)
                                }
                                $obj.SortSpecs = $list
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.FilterView'
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
