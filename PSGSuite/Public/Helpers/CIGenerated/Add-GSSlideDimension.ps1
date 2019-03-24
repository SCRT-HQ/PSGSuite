function Add-GSSlideDimension {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Slides.v1.Data.Dimension object.

    .DESCRIPTION
    Creates a Google.Apis.Slides.v1.Data.Dimension object.

    .PARAMETER Magnitude
    Accepts the following type: [double].

    .PARAMETER Unit
    Accepts the following type: [string].

    .EXAMPLE
    Add-GSSlideDimension -Magnitude $magnitude -Unit $unit
    #>
    [OutputType('Google.Apis.Slides.v1.Data.Dimension')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [double]
        $Magnitude,
        [parameter()]
        [string]
        $Unit,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Slides.v1.Data.Dimension[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Slides.v1.Data.Dimension'
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
                        $obj = New-Object 'Google.Apis.Slides.v1.Data.Dimension'
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
