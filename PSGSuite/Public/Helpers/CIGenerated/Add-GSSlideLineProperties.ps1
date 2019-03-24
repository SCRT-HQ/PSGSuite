function Add-GSSlideLineProperties {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Slides.v1.Data.LineProperties object.

    .DESCRIPTION
    Creates a Google.Apis.Slides.v1.Data.LineProperties object.

    .PARAMETER DashStyle
    Accepts the following type: [string].

    .PARAMETER EndArrow
    Accepts the following type: [string].

    .PARAMETER EndConnection
    Accepts the following type: [Google.Apis.Slides.v1.Data.LineConnection].

    To create this type, use the function Add-GSSlideLineConnection or instantiate the type directly via New-Object 'Google.Apis.Slides.v1.Data.LineConnection'.

    .PARAMETER LineFill
    Accepts the following type: [Google.Apis.Slides.v1.Data.LineFill].

    To create this type, use the function Add-GSSlideLineFill or instantiate the type directly via New-Object 'Google.Apis.Slides.v1.Data.LineFill'.

    .PARAMETER Link
    Accepts the following type: [Google.Apis.Slides.v1.Data.Link].

    To create this type, use the function Add-GSSlideLink or instantiate the type directly via New-Object 'Google.Apis.Slides.v1.Data.Link'.

    .PARAMETER StartArrow
    Accepts the following type: [string].

    .PARAMETER StartConnection
    Accepts the following type: [Google.Apis.Slides.v1.Data.LineConnection].

    To create this type, use the function Add-GSSlideLineConnection or instantiate the type directly via New-Object 'Google.Apis.Slides.v1.Data.LineConnection'.

    .PARAMETER Weight
    Accepts the following type: [Google.Apis.Slides.v1.Data.Dimension].

    To create this type, use the function Add-GSSlideDimension or instantiate the type directly via New-Object 'Google.Apis.Slides.v1.Data.Dimension'.

    .EXAMPLE
    Add-GSSlideLineProperties -DashStyle $dashStyle -EndArrow $endArrow -EndConnection $endConnection -LineFill $lineFill -Link $link -StartArrow $startArrow -StartConnection $startConnection -Weight $weight
    #>
    [OutputType('Google.Apis.Slides.v1.Data.LineProperties')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [string]
        $DashStyle,
        [parameter()]
        [string]
        $EndArrow,
        [parameter()]
        [Google.Apis.Slides.v1.Data.LineConnection]
        $EndConnection,
        [parameter()]
        [Google.Apis.Slides.v1.Data.LineFill]
        $LineFill,
        [parameter()]
        [Google.Apis.Slides.v1.Data.Link]
        $Link,
        [parameter()]
        [string]
        $StartArrow,
        [parameter()]
        [Google.Apis.Slides.v1.Data.LineConnection]
        $StartConnection,
        [parameter()]
        [Google.Apis.Slides.v1.Data.Dimension]
        $Weight,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Slides.v1.Data.LineProperties[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Slides.v1.Data.LineProperties'
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
                        $obj = New-Object 'Google.Apis.Slides.v1.Data.LineProperties'
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
