function Add-GSSheetBandedRange {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.BandedRange object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.BandedRange object.

    .PARAMETER BandedRangeId
    Accepts the following type: int

    .PARAMETER ColumnProperties
    Accepts the following type: Google.Apis.Sheets.v4.Data.BandingProperties

    .PARAMETER Range
    Accepts the following type: Google.Apis.Sheets.v4.Data.GridRange

    .PARAMETER RowProperties
    Accepts the following type: Google.Apis.Sheets.v4.Data.BandingProperties

    .EXAMPLE
    Add-GSSheetBandedRange -BandedRangeId $bandedRangeId -ColumnProperties $columnProperties -Range $range -RowProperties $rowProperties
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.BandedRange')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [int]
        $BandedRangeId,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.BandingProperties]
        $ColumnProperties,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.GridRange]
        $Range,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.BandingProperties]
        $RowProperties,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.BandedRange[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.BandedRange'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.BandedRange'
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
