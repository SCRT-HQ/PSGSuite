function Add-GSSlideSolidFill {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Slides.v1.Data.SolidFill object.

    .DESCRIPTION
    Creates a Google.Apis.Slides.v1.Data.SolidFill object.

    .PARAMETER Alpha
    Accepts the following type: [float].

    .PARAMETER Color
    Accepts the following type: [Google.Apis.Slides.v1.Data.OpaqueColor].

    To create this type, use the function Add-GSSlideOpaqueColor or instantiate the type directly via New-Object 'Google.Apis.Slides.v1.Data.OpaqueColor'.

    .EXAMPLE
    Add-GSSlideSolidFill -Alpha $alpha -Color $color
    #>
    [OutputType('Google.Apis.Slides.v1.Data.SolidFill')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [float]
        $Alpha,
        [parameter()]
        [Google.Apis.Slides.v1.Data.OpaqueColor]
        $Color,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Slides.v1.Data.SolidFill[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Slides.v1.Data.SolidFill'
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
                        $obj = New-Object 'Google.Apis.Slides.v1.Data.SolidFill'
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
