function Add-GSSlideOutline {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Slides.v1.Data.Outline object.

    .DESCRIPTION
    Creates a Google.Apis.Slides.v1.Data.Outline object.

    .PARAMETER DashStyle
    Accepts the following type: string

    .PARAMETER OutlineFill
    Accepts the following type: Google.Apis.Slides.v1.Data.OutlineFill

    .PARAMETER PropertyState
    Accepts the following type: string

    .PARAMETER Weight
    Accepts the following type: Google.Apis.Slides.v1.Data.Dimension

    .EXAMPLE
    Add-GSSlideOutline -DashStyle $dashStyle -OutlineFill $outlineFill -PropertyState $propertyState -Weight $weight
    #>
    [OutputType('Google.Apis.Slides.v1.Data.Outline')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [string]
        $DashStyle,
        [parameter()]
        [Google.Apis.Slides.v1.Data.OutlineFill]
        $OutlineFill,
        [parameter()]
        [string]
        $PropertyState,
        [parameter()]
        [Google.Apis.Slides.v1.Data.Dimension]
        $Weight,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Slides.v1.Data.Outline[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Slides.v1.Data.Outline'
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
                        $obj = New-Object 'Google.Apis.Slides.v1.Data.Outline'
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
