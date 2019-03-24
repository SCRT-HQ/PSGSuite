function Add-GSSlideImageProperties {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Slides.v1.Data.ImageProperties object.

    .DESCRIPTION
    Creates a Google.Apis.Slides.v1.Data.ImageProperties object.

    .PARAMETER Brightness
    Accepts the following type: float

    .PARAMETER Contrast
    Accepts the following type: float

    .PARAMETER CropProperties
    Accepts the following type: Google.Apis.Slides.v1.Data.CropProperties

    .PARAMETER Link
    Accepts the following type: Google.Apis.Slides.v1.Data.Link

    .PARAMETER Outline
    Accepts the following type: Google.Apis.Slides.v1.Data.Outline

    .PARAMETER Recolor
    Accepts the following type: Google.Apis.Slides.v1.Data.Recolor

    .PARAMETER Shadow
    Accepts the following type: Google.Apis.Slides.v1.Data.Shadow

    .PARAMETER Transparency
    Accepts the following type: float

    .EXAMPLE
    Add-GSSlideImageProperties -Brightness $brightness -Contrast $contrast -CropProperties $cropProperties -Link $link -Outline $outline -Recolor $recolor -Shadow $shadow -Transparency $transparency
    #>
    [OutputType('Google.Apis.Slides.v1.Data.ImageProperties')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [float]
        $Brightness,
        [parameter()]
        [float]
        $Contrast,
        [parameter()]
        [Google.Apis.Slides.v1.Data.CropProperties]
        $CropProperties,
        [parameter()]
        [Google.Apis.Slides.v1.Data.Link]
        $Link,
        [parameter()]
        [Google.Apis.Slides.v1.Data.Outline]
        $Outline,
        [parameter()]
        [Google.Apis.Slides.v1.Data.Recolor]
        $Recolor,
        [parameter()]
        [Google.Apis.Slides.v1.Data.Shadow]
        $Shadow,
        [parameter()]
        [float]
        $Transparency,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Slides.v1.Data.ImageProperties[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Slides.v1.Data.ImageProperties'
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
                        $obj = New-Object 'Google.Apis.Slides.v1.Data.ImageProperties'
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
