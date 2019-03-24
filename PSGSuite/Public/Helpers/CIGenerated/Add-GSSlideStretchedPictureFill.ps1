function Add-GSSlideStretchedPictureFill {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Slides.v1.Data.StretchedPictureFill object.

    .DESCRIPTION
    Creates a Google.Apis.Slides.v1.Data.StretchedPictureFill object.

    .PARAMETER ContentUrl
    Accepts the following type: [string].

    .PARAMETER Size
    Accepts the following type: [Google.Apis.Slides.v1.Data.Size].

    To create this type, use the function Add-GSSlideSize or instantiate the type directly via New-Object 'Google.Apis.Slides.v1.Data.Size'.

    .EXAMPLE
    Add-GSSlideStretchedPictureFill -ContentUrl $contentUrl -Size $size
    #>
    [OutputType('Google.Apis.Slides.v1.Data.StretchedPictureFill')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [string]
        $ContentUrl,
        [parameter()]
        [Google.Apis.Slides.v1.Data.Size]
        $Size,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Slides.v1.Data.StretchedPictureFill[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Slides.v1.Data.StretchedPictureFill'
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
                        $obj = New-Object 'Google.Apis.Slides.v1.Data.StretchedPictureFill'
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
