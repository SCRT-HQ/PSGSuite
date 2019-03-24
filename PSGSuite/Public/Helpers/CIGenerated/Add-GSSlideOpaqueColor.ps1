function Add-GSSlideOpaqueColor {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Slides.v1.Data.OpaqueColor object.

    .DESCRIPTION
    Creates a Google.Apis.Slides.v1.Data.OpaqueColor object.

    .PARAMETER RgbColor
    Accepts the following type: Google.Apis.Slides.v1.Data.RgbColor

    .PARAMETER ThemeColor
    Accepts the following type: string

    .EXAMPLE
    Add-GSSlideOpaqueColor -RgbColor $rgbColor -ThemeColor $themeColor
    #>
    [OutputType('Google.Apis.Slides.v1.Data.OpaqueColor')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Slides.v1.Data.RgbColor]
        $RgbColor,
        [parameter()]
        [string]
        $ThemeColor,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Slides.v1.Data.OpaqueColor[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Slides.v1.Data.OpaqueColor'
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
                        $obj = New-Object 'Google.Apis.Slides.v1.Data.OpaqueColor'
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
