function Add-GSSlideTextStyle {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Slides.v1.Data.TextStyle object.

    .DESCRIPTION
    Creates a Google.Apis.Slides.v1.Data.TextStyle object.

    .PARAMETER BackgroundColor
    Accepts the following type: Google.Apis.Slides.v1.Data.OptionalColor

    .PARAMETER BaselineOffset
    Accepts the following type: string

    .PARAMETER Bold
    Accepts the following type: bool

    .PARAMETER FontFamily
    Accepts the following type: string

    .PARAMETER FontSize
    Accepts the following type: Google.Apis.Slides.v1.Data.Dimension

    .PARAMETER ForegroundColor
    Accepts the following type: Google.Apis.Slides.v1.Data.OptionalColor

    .PARAMETER Italic
    Accepts the following type: bool

    .PARAMETER Link
    Accepts the following type: Google.Apis.Slides.v1.Data.Link

    .PARAMETER SmallCaps
    Accepts the following type: bool

    .PARAMETER Strikethrough
    Accepts the following type: bool

    .PARAMETER Underline
    Accepts the following type: bool

    .PARAMETER WeightedFontFamily
    Accepts the following type: Google.Apis.Slides.v1.Data.WeightedFontFamily

    .EXAMPLE
    Add-GSSlideTextStyle -BackgroundColor $backgroundColor -BaselineOffset $baselineOffset -Bold $bold -FontFamily $fontFamily -FontSize $fontSize -ForegroundColor $foregroundColor -Italic $italic -Link $link -SmallCaps $smallCaps -Strikethrough $strikethrough -Underline $underline -WeightedFontFamily $weightedFontFamily
    #>
    [OutputType('Google.Apis.Slides.v1.Data.TextStyle')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Slides.v1.Data.OptionalColor]
        $BackgroundColor,
        [parameter()]
        [string]
        $BaselineOffset,
        [parameter()]
        [bool]
        $Bold,
        [parameter()]
        [string]
        $FontFamily,
        [parameter()]
        [Google.Apis.Slides.v1.Data.Dimension]
        $FontSize,
        [parameter()]
        [Google.Apis.Slides.v1.Data.OptionalColor]
        $ForegroundColor,
        [parameter()]
        [bool]
        $Italic,
        [parameter()]
        [Google.Apis.Slides.v1.Data.Link]
        $Link,
        [parameter()]
        [bool]
        $SmallCaps,
        [parameter()]
        [bool]
        $Strikethrough,
        [parameter()]
        [bool]
        $Underline,
        [parameter()]
        [Google.Apis.Slides.v1.Data.WeightedFontFamily]
        $WeightedFontFamily,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Slides.v1.Data.TextStyle[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Slides.v1.Data.TextStyle'
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
                        $obj = New-Object 'Google.Apis.Slides.v1.Data.TextStyle'
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
