function Add-GSSheetBasicFilter {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.BasicFilter object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.BasicFilter object.

    .PARAMETER Criteria
    Accepts the following type: [string,Google.Apis.Sheets.v4.Data.FilterCriteria].

    .PARAMETER Range
    Accepts the following type: [Google.Apis.Sheets.v4.Data.GridRange].

    To create this type, use the function Add-GSSheetGridRange or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.GridRange'.

    .PARAMETER SortSpecs
    Accepts the following type: [Google.Apis.Sheets.v4.Data.SortSpec[]].

    To create this type, use the function Add-GSSheetSortSpec or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.SortSpec'.

    .EXAMPLE
    Add-GSSheetBasicFilter -Criteria $criteria -Range $range -SortSpecs $sortSpecs
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.BasicFilter')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [string,Google.Apis.Sheets.v4.Data.FilterCriteria]
        $Criteria,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.GridRange]
        $Range,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.SortSpec[]]
        $SortSpecs,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.BasicFilter[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.BasicFilter'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.BasicFilter'
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
