function Add-GSSheetCandlestickChartSpec {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.CandlestickChartSpec object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.CandlestickChartSpec object.

    .PARAMETER Data
    Accepts the following type: System.Collections.Generic.IList[Google.Apis.Sheets.v4.Data.CandlestickData][]

    .PARAMETER Domain
    Accepts the following type: Google.Apis.Sheets.v4.Data.CandlestickDomain

    .EXAMPLE
    Add-GSSheetCandlestickChartSpec -Data $data -Domain $domain
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.CandlestickChartSpec')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [System.Collections.Generic.IList[Google.Apis.Sheets.v4.Data.CandlestickData][]]
        $Data,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.CandlestickDomain]
        $Domain,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.CandlestickChartSpec[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.CandlestickChartSpec'
                    foreach ($prop in $PSBoundParameters.Keys | Where-Object {$obj.PSObject.Properties.Name -contains $_}) {
                        switch ($prop) {
                            Data {
                                $list = New-Object 'System.Collections.Generic.List[System.Collections.Generic.IList[Google.Apis.Sheets.v4.Data.CandlestickData]]'
                                foreach ($item in $Data) {
                                    $list.Add($item)
                                }
                                $obj.Data = $list
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.CandlestickChartSpec'
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
