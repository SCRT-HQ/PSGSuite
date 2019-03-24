function Add-GSSheetGridProperties {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.GridProperties object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.GridProperties object.

    .PARAMETER ColumnCount
    Accepts the following type: [int].

    .PARAMETER ColumnGroupControlAfter
    Accepts the following type: [switch].

    .PARAMETER FrozenColumnCount
    Accepts the following type: [int].

    .PARAMETER FrozenRowCount
    Accepts the following type: [int].

    .PARAMETER HideGridlines
    Accepts the following type: [switch].

    .PARAMETER RowCount
    Accepts the following type: [int].

    .PARAMETER RowGroupControlAfter
    Accepts the following type: [switch].

    .EXAMPLE
    Add-GSSheetGridProperties -ColumnCount $columnCount -ColumnGroupControlAfter $columnGroupControlAfter -FrozenColumnCount $frozenColumnCount -FrozenRowCount $frozenRowCount -HideGridlines $hideGridlines -RowCount $rowCount -RowGroupControlAfter $rowGroupControlAfter
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.GridProperties')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [int]
        $ColumnCount,
        [parameter()]
        [switch]
        $ColumnGroupControlAfter,
        [parameter()]
        [int]
        $FrozenColumnCount,
        [parameter()]
        [int]
        $FrozenRowCount,
        [parameter()]
        [switch]
        $HideGridlines,
        [parameter()]
        [int]
        $RowCount,
        [parameter()]
        [switch]
        $RowGroupControlAfter,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.GridProperties[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.GridProperties'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.GridProperties'
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
