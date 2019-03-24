function Add-GSSlideShadow {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Slides.v1.Data.Shadow object.

    .DESCRIPTION
    Creates a Google.Apis.Slides.v1.Data.Shadow object.

    .PARAMETER Alignment
    Accepts the following type: string

    .PARAMETER Alpha
    Accepts the following type: float

    .PARAMETER BlurRadius
    Accepts the following type: Google.Apis.Slides.v1.Data.Dimension

    .PARAMETER Color
    Accepts the following type: Google.Apis.Slides.v1.Data.OpaqueColor

    .PARAMETER PropertyState
    Accepts the following type: string

    .PARAMETER RotateWithShape
    Accepts the following type: bool

    .PARAMETER Transform
    Accepts the following type: Google.Apis.Slides.v1.Data.AffineTransform

    .PARAMETER Type
    Accepts the following type: string

    .EXAMPLE
    Add-GSSlideShadow -Alignment $alignment -Alpha $alpha -BlurRadius $blurRadius -Color $color -PropertyState $propertyState -RotateWithShape $rotateWithShape -Transform $transform -Type $type
    #>
    [OutputType('Google.Apis.Slides.v1.Data.Shadow')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [string]
        $Alignment,
        [parameter()]
        [float]
        $Alpha,
        [parameter()]
        [Google.Apis.Slides.v1.Data.Dimension]
        $BlurRadius,
        [parameter()]
        [Google.Apis.Slides.v1.Data.OpaqueColor]
        $Color,
        [parameter()]
        [string]
        $PropertyState,
        [parameter()]
        [bool]
        $RotateWithShape,
        [parameter()]
        [Google.Apis.Slides.v1.Data.AffineTransform]
        $Transform,
        [parameter()]
        [string]
        $Type,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Slides.v1.Data.Shadow[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Slides.v1.Data.Shadow'
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
                        $obj = New-Object 'Google.Apis.Slides.v1.Data.Shadow'
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
