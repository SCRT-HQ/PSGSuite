function Add-GSSlideOptionalColor {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Slides.v1.Data.OptionalColor object.

    .DESCRIPTION
    Creates a Google.Apis.Slides.v1.Data.OptionalColor object.

    .PARAMETER OpaqueColor
    Accepts the following type: Google.Apis.Slides.v1.Data.OpaqueColor

    .EXAMPLE
    Add-GSSlideOptionalColor -OpaqueColor $opaqueColor
    #>
    [OutputType('Google.Apis.Slides.v1.Data.OptionalColor')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Slides.v1.Data.OpaqueColor]
        $OpaqueColor,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Slides.v1.Data.OptionalColor[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Slides.v1.Data.OptionalColor'
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
                        $obj = New-Object 'Google.Apis.Slides.v1.Data.OptionalColor'
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
