function Add-GSSlideSize {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Slides.v1.Data.Size object.

    .DESCRIPTION
    Creates a Google.Apis.Slides.v1.Data.Size object.

    .PARAMETER Height
    Accepts the following type: [Google.Apis.Slides.v1.Data.Dimension].

    To create this type, use the function Add-GSSlideDimension or instantiate the type directly via New-Object 'Google.Apis.Slides.v1.Data.Dimension'.

    .PARAMETER Width
    Accepts the following type: [Google.Apis.Slides.v1.Data.Dimension].

    To create this type, use the function Add-GSSlideDimension or instantiate the type directly via New-Object 'Google.Apis.Slides.v1.Data.Dimension'.

    .EXAMPLE
    Add-GSSlideSize -Height $height -Width $width
    #>
    [OutputType('Google.Apis.Slides.v1.Data.Size')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Slides.v1.Data.Dimension]
        $Height,
        [parameter()]
        [Google.Apis.Slides.v1.Data.Dimension]
        $Width,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Slides.v1.Data.Size[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Slides.v1.Data.Size'
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
                        $obj = New-Object 'Google.Apis.Slides.v1.Data.Size'
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
