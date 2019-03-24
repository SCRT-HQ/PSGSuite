function Add-GSSlideRgbColor {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Slides.v1.Data.RgbColor object.

    .DESCRIPTION
    Creates a Google.Apis.Slides.v1.Data.RgbColor object.

    .PARAMETER Blue
    Accepts the following type: [float].

    .PARAMETER Green
    Accepts the following type: [float].

    .PARAMETER Red
    Accepts the following type: [float].

    .EXAMPLE
    Add-GSSlideRgbColor -Blue $blue -Green $green -Red $red
    #>
    [OutputType('Google.Apis.Slides.v1.Data.RgbColor')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [float]
        $Blue,
        [parameter()]
        [float]
        $Green,
        [parameter()]
        [float]
        $Red,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Slides.v1.Data.RgbColor[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Slides.v1.Data.RgbColor'
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
                        $obj = New-Object 'Google.Apis.Slides.v1.Data.RgbColor'
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
