function Add-GSSheetGridRange {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.GridRange object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.GridRange object.

    .PARAMETER EndColumnIndex
    Accepts the following type: [int].

    .PARAMETER EndRowIndex
    Accepts the following type: [int].

    .PARAMETER SheetId
    Accepts the following type: [int].

    .PARAMETER StartColumnIndex
    Accepts the following type: [int].

    .PARAMETER StartRowIndex
    Accepts the following type: [int].

    .EXAMPLE
    Add-GSSheetGridRange -EndColumnIndex $endColumnIndex -EndRowIndex $endRowIndex -SheetId $sheetId -StartColumnIndex $startColumnIndex -StartRowIndex $startRowIndex
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.GridRange')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [int]
        $EndColumnIndex,
        [parameter()]
        [int]
        $EndRowIndex,
        [parameter()]
        [int]
        $SheetId,
        [parameter()]
        [int]
        $StartColumnIndex,
        [parameter()]
        [int]
        $StartRowIndex,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.GridRange[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.GridRange'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.GridRange'
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
