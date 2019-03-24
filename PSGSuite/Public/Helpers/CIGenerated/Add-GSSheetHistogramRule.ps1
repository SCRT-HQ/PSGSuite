function Add-GSSheetHistogramRule {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.HistogramRule object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.HistogramRule object.

    .PARAMETER End
    Accepts the following type: [double].

    .PARAMETER Interval
    Accepts the following type: [double].

    .PARAMETER Start
    Accepts the following type: [double].

    .EXAMPLE
    Add-GSSheetHistogramRule -End $end -Interval $interval -Start $start
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.HistogramRule')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [double]
        $End,
        [parameter()]
        [double]
        $Interval,
        [parameter()]
        [double]
        $Start,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.HistogramRule[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.HistogramRule'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.HistogramRule'
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
