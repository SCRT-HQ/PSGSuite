function Add-GSSheetIterativeCalculationSettings {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.IterativeCalculationSettings object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.IterativeCalculationSettings object.

    .PARAMETER ConvergenceThreshold
    Accepts the following type: double

    .PARAMETER MaxIterations
    Accepts the following type: int

    .EXAMPLE
    Add-GSSheetIterativeCalculationSettings -ConvergenceThreshold $convergenceThreshold -MaxIterations $maxIterations
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.IterativeCalculationSettings')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [double]
        $ConvergenceThreshold,
        [parameter()]
        [int]
        $MaxIterations,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.IterativeCalculationSettings[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.IterativeCalculationSettings'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.IterativeCalculationSettings'
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
