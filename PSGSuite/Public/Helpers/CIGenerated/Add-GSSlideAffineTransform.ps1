function Add-GSSlideAffineTransform {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Slides.v1.Data.AffineTransform object.

    .DESCRIPTION
    Creates a Google.Apis.Slides.v1.Data.AffineTransform object.

    .PARAMETER ScaleX
    Accepts the following type: [double].

    .PARAMETER ScaleY
    Accepts the following type: [double].

    .PARAMETER ShearX
    Accepts the following type: [double].

    .PARAMETER ShearY
    Accepts the following type: [double].

    .PARAMETER TranslateX
    Accepts the following type: [double].

    .PARAMETER TranslateY
    Accepts the following type: [double].

    .PARAMETER Unit
    Accepts the following type: [string].

    .EXAMPLE
    Add-GSSlideAffineTransform -ScaleX $scaleX -ScaleY $scaleY -ShearX $shearX -ShearY $shearY -TranslateX $translateX -TranslateY $translateY -Unit $unit
    #>
    [OutputType('Google.Apis.Slides.v1.Data.AffineTransform')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [double]
        $ScaleX,
        [parameter()]
        [double]
        $ScaleY,
        [parameter()]
        [double]
        $ShearX,
        [parameter()]
        [double]
        $ShearY,
        [parameter()]
        [double]
        $TranslateX,
        [parameter()]
        [double]
        $TranslateY,
        [parameter()]
        [string]
        $Unit,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Slides.v1.Data.AffineTransform[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Slides.v1.Data.AffineTransform'
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
                        $obj = New-Object 'Google.Apis.Slides.v1.Data.AffineTransform'
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
