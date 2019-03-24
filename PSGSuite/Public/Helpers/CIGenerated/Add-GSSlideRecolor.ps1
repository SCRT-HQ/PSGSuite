function Add-GSSlideRecolor {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Slides.v1.Data.Recolor object.

    .DESCRIPTION
    Creates a Google.Apis.Slides.v1.Data.Recolor object.

    .PARAMETER Name
    Accepts the following type: [string].

    .PARAMETER RecolorStops
    Accepts the following type: [Google.Apis.Slides.v1.Data.ColorStop[]].

    To create this type, use the function Add-GSSlideColorStop or instantiate the type directly via New-Object 'Google.Apis.Slides.v1.Data.ColorStop'.

    .EXAMPLE
    Add-GSSlideRecolor -Name $name -RecolorStops $recolorStops
    #>
    [OutputType('Google.Apis.Slides.v1.Data.Recolor')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [string]
        $Name,
        [parameter()]
        [Google.Apis.Slides.v1.Data.ColorStop[]]
        $RecolorStops,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Slides.v1.Data.Recolor[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Slides.v1.Data.Recolor'
                    foreach ($prop in $PSBoundParameters.Keys | Where-Object {$obj.PSObject.Properties.Name -contains $_}) {
                        switch ($prop) {
                            RecolorStops {
                                $list = New-Object 'System.Collections.Generic.List[Google.Apis.Slides.v1.Data.ColorStop]'
                                foreach ($item in $RecolorStops) {
                                    $list.Add($item)
                                }
                                $obj.RecolorStops = $list
                            }
                            default {
                                $obj.$prop = $PSBoundParameters[$prop]
                            }
                        }
                    }
                    $obj
                }
                InputObject {
                    foreach ($iObj in $InputObject) {
                        $obj = New-Object 'Google.Apis.Slides.v1.Data.Recolor'
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
