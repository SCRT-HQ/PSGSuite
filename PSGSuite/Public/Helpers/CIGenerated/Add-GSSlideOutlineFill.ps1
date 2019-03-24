function Add-GSSlideOutlineFill {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Slides.v1.Data.OutlineFill object.

    .DESCRIPTION
    Creates a Google.Apis.Slides.v1.Data.OutlineFill object.

    .PARAMETER SolidFill
    Accepts the following type: Google.Apis.Slides.v1.Data.SolidFill

    .EXAMPLE
    Add-GSSlideOutlineFill -SolidFill $solidFill
    #>
    [OutputType('Google.Apis.Slides.v1.Data.OutlineFill')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Slides.v1.Data.SolidFill]
        $SolidFill,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Slides.v1.Data.OutlineFill[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Slides.v1.Data.OutlineFill'
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
                        $obj = New-Object 'Google.Apis.Slides.v1.Data.OutlineFill'
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
