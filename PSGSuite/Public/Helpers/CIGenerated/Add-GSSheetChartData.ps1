function Add-GSSheetChartData {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.ChartData object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.ChartData object.

    .PARAMETER SourceRange
    Accepts the following type: Google.Apis.Sheets.v4.Data.ChartSourceRange

    .EXAMPLE
    Add-GSSheetChartData -SourceRange $sourceRange
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.ChartData')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.ChartSourceRange]
        $SourceRange,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.ChartData[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.ChartData'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.ChartData'
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
