function Add-GSDocTableCellLocation {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Docs.v1.Data.TableCellLocation object.

    .DESCRIPTION
    Creates a Google.Apis.Docs.v1.Data.TableCellLocation object.

    .PARAMETER ColumnIndex
    Accepts the following type: [int].

    .PARAMETER RowIndex
    Accepts the following type: [int].

    .PARAMETER TableStartLocation
    Accepts the following type: [Google.Apis.Docs.v1.Data.Location].

    To create this type, use the function Add-GSDocLocation or instantiate the type directly via New-Object 'Google.Apis.Docs.v1.Data.Location'.

    .EXAMPLE
    Add-GSDocTableCellLocation -ColumnIndex $columnIndex -RowIndex $rowIndex -TableStartLocation $tableStartLocation
    #>
    [OutputType('Google.Apis.Docs.v1.Data.TableCellLocation')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [int]
        $ColumnIndex,
        [parameter()]
        [int]
        $RowIndex,
        [parameter()]
        [Google.Apis.Docs.v1.Data.Location]
        $TableStartLocation,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Docs.v1.Data.TableCellLocation[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Docs.v1.Data.TableCellLocation'
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
                        $obj = New-Object 'Google.Apis.Docs.v1.Data.TableCellLocation'
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
