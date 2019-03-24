function Add-GSSheetGridCoordinate {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.GridCoordinate object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.GridCoordinate object.

    .PARAMETER ColumnIndex
    Accepts the following type: int

    .PARAMETER RowIndex
    Accepts the following type: int

    .PARAMETER SheetId
    Accepts the following type: int

    .EXAMPLE
    Add-GSSheetGridCoordinate -ColumnIndex $columnIndex -RowIndex $rowIndex -SheetId $sheetId
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.GridCoordinate')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [int]
        $ColumnIndex,
        [parameter()]
        [int]
        $RowIndex,
        [parameter()]
        [int]
        $SheetId,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.GridCoordinate[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.GridCoordinate'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.GridCoordinate'
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
