function Add-GSSlideWeightedFontFamily {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Slides.v1.Data.WeightedFontFamily object.

    .DESCRIPTION
    Creates a Google.Apis.Slides.v1.Data.WeightedFontFamily object.

    .PARAMETER FontFamily
    Accepts the following type: [string].

    .PARAMETER Weight
    Accepts the following type: [int].

    .EXAMPLE
    Add-GSSlideWeightedFontFamily -FontFamily $fontFamily -Weight $weight
    #>
    [OutputType('Google.Apis.Slides.v1.Data.WeightedFontFamily')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [string]
        $FontFamily,
        [parameter()]
        [int]
        $Weight,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Slides.v1.Data.WeightedFontFamily[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Slides.v1.Data.WeightedFontFamily'
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
                        $obj = New-Object 'Google.Apis.Slides.v1.Data.WeightedFontFamily'
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
