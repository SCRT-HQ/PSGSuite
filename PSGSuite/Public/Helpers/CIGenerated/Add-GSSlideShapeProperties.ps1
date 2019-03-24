function Add-GSSlideShapeProperties {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Slides.v1.Data.ShapeProperties object.

    .DESCRIPTION
    Creates a Google.Apis.Slides.v1.Data.ShapeProperties object.

    .PARAMETER ContentAlignment
    Accepts the following type: string

    .PARAMETER Link
    Accepts the following type: Google.Apis.Slides.v1.Data.Link

    .PARAMETER Outline
    Accepts the following type: Google.Apis.Slides.v1.Data.Outline

    .PARAMETER Shadow
    Accepts the following type: Google.Apis.Slides.v1.Data.Shadow

    .PARAMETER ShapeBackgroundFill
    Accepts the following type: Google.Apis.Slides.v1.Data.ShapeBackgroundFill

    .EXAMPLE
    Add-GSSlideShapeProperties -ContentAlignment $contentAlignment -Link $link -Outline $outline -Shadow $shadow -ShapeBackgroundFill $shapeBackgroundFill
    #>
    [OutputType('Google.Apis.Slides.v1.Data.ShapeProperties')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [string]
        $ContentAlignment,
        [parameter()]
        [Google.Apis.Slides.v1.Data.Link]
        $Link,
        [parameter()]
        [Google.Apis.Slides.v1.Data.Outline]
        $Outline,
        [parameter()]
        [Google.Apis.Slides.v1.Data.Shadow]
        $Shadow,
        [parameter()]
        [Google.Apis.Slides.v1.Data.ShapeBackgroundFill]
        $ShapeBackgroundFill,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Slides.v1.Data.ShapeProperties[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Slides.v1.Data.ShapeProperties'
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
                        $obj = New-Object 'Google.Apis.Slides.v1.Data.ShapeProperties'
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
