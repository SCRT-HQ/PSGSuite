function Add-GSSlideCropProperties {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Slides.v1.Data.CropProperties object.

    .DESCRIPTION
    Creates a Google.Apis.Slides.v1.Data.CropProperties object.

    .PARAMETER Angle
    Accepts the following type: float

    .PARAMETER BottomOffset
    Accepts the following type: float

    .PARAMETER LeftOffset
    Accepts the following type: float

    .PARAMETER RightOffset
    Accepts the following type: float

    .PARAMETER TopOffset
    Accepts the following type: float

    .EXAMPLE
    Add-GSSlideCropProperties -Angle $angle -BottomOffset $bottomOffset -LeftOffset $leftOffset -RightOffset $rightOffset -TopOffset $topOffset
    #>
    [OutputType('Google.Apis.Slides.v1.Data.CropProperties')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [float]
        $Angle,
        [parameter()]
        [float]
        $BottomOffset,
        [parameter()]
        [float]
        $LeftOffset,
        [parameter()]
        [float]
        $RightOffset,
        [parameter()]
        [float]
        $TopOffset,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Slides.v1.Data.CropProperties[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Slides.v1.Data.CropProperties'
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
                        $obj = New-Object 'Google.Apis.Slides.v1.Data.CropProperties'
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
