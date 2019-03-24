function Add-GSSheetDeveloperMetadataLocation {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.DeveloperMetadataLocation object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.DeveloperMetadataLocation object.

    .PARAMETER DimensionRange
    Accepts the following type: Google.Apis.Sheets.v4.Data.DimensionRange

    .PARAMETER LocationType
    Accepts the following type: string

    .PARAMETER SheetId
    Accepts the following type: int

    .PARAMETER Spreadsheet
    Accepts the following type: bool

    .EXAMPLE
    Add-GSSheetDeveloperMetadataLocation -DimensionRange $dimensionRange -LocationType $locationType -SheetId $sheetId -Spreadsheet $spreadsheet
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.DeveloperMetadataLocation')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.DimensionRange]
        $DimensionRange,
        [parameter()]
        [string]
        $LocationType,
        [parameter()]
        [int]
        $SheetId,
        [parameter()]
        [bool]
        $Spreadsheet,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.DeveloperMetadataLocation[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.DeveloperMetadataLocation'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.DeveloperMetadataLocation'
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
