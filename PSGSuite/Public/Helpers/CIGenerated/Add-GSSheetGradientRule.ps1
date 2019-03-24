function Add-GSSheetGradientRule {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.GradientRule object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.GradientRule object.

    .PARAMETER Maxpoint
    Accepts the following type: Google.Apis.Sheets.v4.Data.InterpolationPoint

    .PARAMETER Midpoint
    Accepts the following type: Google.Apis.Sheets.v4.Data.InterpolationPoint

    .PARAMETER Minpoint
    Accepts the following type: Google.Apis.Sheets.v4.Data.InterpolationPoint

    .EXAMPLE
    Add-GSSheetGradientRule -Maxpoint $maxpoint -Midpoint $midpoint -Minpoint $minpoint
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.GradientRule')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.InterpolationPoint]
        $Maxpoint,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.InterpolationPoint]
        $Midpoint,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.InterpolationPoint]
        $Minpoint,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.GradientRule[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.GradientRule'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.GradientRule'
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
