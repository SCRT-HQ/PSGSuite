function Add-GSSlideThemeColorPair {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Slides.v1.Data.ThemeColorPair object.

    .DESCRIPTION
    Creates a Google.Apis.Slides.v1.Data.ThemeColorPair object.

    .PARAMETER Color
    Accepts the following type: [Google.Apis.Slides.v1.Data.RgbColor].

    To create this type, use the function Add-GSSlideRgbColor or instantiate the type directly via New-Object 'Google.Apis.Slides.v1.Data.RgbColor'.

    .PARAMETER Type
    Accepts the following type: [string].

    .EXAMPLE
    Add-GSSlideThemeColorPair -Color $color -Type $type
    #>
    [OutputType('Google.Apis.Slides.v1.Data.ThemeColorPair')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Slides.v1.Data.RgbColor]
        $Color,
        [parameter()]
        [string]
        $Type,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Slides.v1.Data.ThemeColorPair[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Slides.v1.Data.ThemeColorPair'
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
                        $obj = New-Object 'Google.Apis.Slides.v1.Data.ThemeColorPair'
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
