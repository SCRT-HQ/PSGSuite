function Add-GSSheetDimensionRange {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.DimensionRange object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.DimensionRange object.

    .PARAMETER Dimension
    Accepts the following type: [string].

    .PARAMETER EndIndex
    Accepts the following type: [int].

    .PARAMETER SheetId
    Accepts the following type: [int].

    .PARAMETER StartIndex
    Accepts the following type: [int].

    .EXAMPLE
    Add-GSSheetDimensionRange -Dimension $dimension -EndIndex $endIndex -SheetId $sheetId -StartIndex $startIndex
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.DimensionRange')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [string]
        $Dimension,
        [parameter()]
        [int]
        $EndIndex,
        [parameter()]
        [int]
        $SheetId,
        [parameter()]
        [int]
        $StartIndex,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.DimensionRange[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.DimensionRange'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.DimensionRange'
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
