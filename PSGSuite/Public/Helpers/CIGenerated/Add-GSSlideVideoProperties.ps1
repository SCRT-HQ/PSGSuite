function Add-GSSlideVideoProperties {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Slides.v1.Data.VideoProperties object.

    .DESCRIPTION
    Creates a Google.Apis.Slides.v1.Data.VideoProperties object.

    .PARAMETER AutoPlay
    Accepts the following type: [switch].

    .PARAMETER End
    Accepts the following type: [long].

    .PARAMETER Mute
    Accepts the following type: [switch].

    .PARAMETER Outline
    Accepts the following type: [Google.Apis.Slides.v1.Data.Outline].

    To create this type, use the function Add-GSSlideOutline or instantiate the type directly via New-Object 'Google.Apis.Slides.v1.Data.Outline'.

    .PARAMETER Start
    Accepts the following type: [long].

    .EXAMPLE
    Add-GSSlideVideoProperties -AutoPlay $autoPlay -End $end -Mute $mute -Outline $outline -Start $start
    #>
    [OutputType('Google.Apis.Slides.v1.Data.VideoProperties')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [switch]
        $AutoPlay,
        [parameter()]
        [long]
        $End,
        [parameter()]
        [switch]
        $Mute,
        [parameter()]
        [Google.Apis.Slides.v1.Data.Outline]
        $Outline,
        [parameter()]
        [long]
        $Start,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Slides.v1.Data.VideoProperties[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Slides.v1.Data.VideoProperties'
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
                        $obj = New-Object 'Google.Apis.Slides.v1.Data.VideoProperties'
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
