function Add-GSSheetCandlestickData {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.CandlestickData object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.CandlestickData object.

    .PARAMETER CloseSeries
    Accepts the following type: [Google.Apis.Sheets.v4.Data.CandlestickSeries].

    To create this type, use the function Add-GSSheetCandlestickSeries or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.CandlestickSeries'.

    .PARAMETER HighSeries
    Accepts the following type: [Google.Apis.Sheets.v4.Data.CandlestickSeries].

    To create this type, use the function Add-GSSheetCandlestickSeries or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.CandlestickSeries'.

    .PARAMETER LowSeries
    Accepts the following type: [Google.Apis.Sheets.v4.Data.CandlestickSeries].

    To create this type, use the function Add-GSSheetCandlestickSeries or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.CandlestickSeries'.

    .PARAMETER OpenSeries
    Accepts the following type: [Google.Apis.Sheets.v4.Data.CandlestickSeries].

    To create this type, use the function Add-GSSheetCandlestickSeries or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.CandlestickSeries'.

    .EXAMPLE
    Add-GSSheetCandlestickData -CloseSeries $closeSeries -HighSeries $highSeries -LowSeries $lowSeries -OpenSeries $openSeries
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.CandlestickData')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.CandlestickSeries]
        $CloseSeries,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.CandlestickSeries]
        $HighSeries,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.CandlestickSeries]
        $LowSeries,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.CandlestickSeries]
        $OpenSeries,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.CandlestickData[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.CandlestickData'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.CandlestickData'
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
