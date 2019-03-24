function Add-GSSlidePageElementProperties {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Slides.v1.Data.PageElementProperties object.

    .DESCRIPTION
    Creates a Google.Apis.Slides.v1.Data.PageElementProperties object.

    .PARAMETER PageObjectId
    Accepts the following type: [string].

    .PARAMETER Size
    Accepts the following type: [Google.Apis.Slides.v1.Data.Size].

    To create this type, use the function Add-GSSlideSize or instantiate the type directly via New-Object 'Google.Apis.Slides.v1.Data.Size'.

    .PARAMETER Transform
    Accepts the following type: [Google.Apis.Slides.v1.Data.AffineTransform].

    To create this type, use the function Add-GSSlideAffineTransform or instantiate the type directly via New-Object 'Google.Apis.Slides.v1.Data.AffineTransform'.

    .EXAMPLE
    Add-GSSlidePageElementProperties -PageObjectId $pageObjectId -Size $size -Transform $transform
    #>
    [OutputType('Google.Apis.Slides.v1.Data.PageElementProperties')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [string]
        $PageObjectId,
        [parameter()]
        [Google.Apis.Slides.v1.Data.Size]
        $Size,
        [parameter()]
        [Google.Apis.Slides.v1.Data.AffineTransform]
        $Transform,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Slides.v1.Data.PageElementProperties[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Slides.v1.Data.PageElementProperties'
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
                        $obj = New-Object 'Google.Apis.Slides.v1.Data.PageElementProperties'
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
