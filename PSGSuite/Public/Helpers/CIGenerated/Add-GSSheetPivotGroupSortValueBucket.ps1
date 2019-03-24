function Add-GSSheetPivotGroupSortValueBucket {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.PivotGroupSortValueBucket object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.PivotGroupSortValueBucket object.

    .PARAMETER Buckets
    Accepts the following type: [Google.Apis.Sheets.v4.Data.ExtendedValue[]].

    To create this type, use the function Add-GSSheetExtendedValue or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.ExtendedValue'.

    .PARAMETER ValuesIndex
    Accepts the following type: [int].

    .EXAMPLE
    Add-GSSheetPivotGroupSortValueBucket -Buckets $buckets -ValuesIndex $valuesIndex
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.PivotGroupSortValueBucket')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.ExtendedValue[]]
        $Buckets,
        [parameter()]
        [int]
        $ValuesIndex,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.PivotGroupSortValueBucket[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.PivotGroupSortValueBucket'
                    foreach ($prop in $PSBoundParameters.Keys | Where-Object {$obj.PSObject.Properties.Name -contains $_}) {
                        switch ($prop) {
                            Buckets {
                                $list = New-Object 'System.Collections.Generic.List[Google.Apis.Sheets.v4.Data.ExtendedValue]'
                                foreach ($item in $Buckets) {
                                    $list.Add($item)
                                }
                                $obj.Buckets = $list
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.PivotGroupSortValueBucket'
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
