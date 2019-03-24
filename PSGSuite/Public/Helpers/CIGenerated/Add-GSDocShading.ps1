function Add-GSDocShading {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Docs.v1.Data.Shading object.

    .DESCRIPTION
    Creates a Google.Apis.Docs.v1.Data.Shading object.

    .PARAMETER BackgroundColor
    Accepts the following type: Google.Apis.Docs.v1.Data.OptionalColor

    .EXAMPLE
    Add-GSDocShading -BackgroundColor $backgroundColor
    #>
    [OutputType('Google.Apis.Docs.v1.Data.Shading')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Docs.v1.Data.OptionalColor]
        $BackgroundColor,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Docs.v1.Data.Shading[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Docs.v1.Data.Shading'
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
                        $obj = New-Object 'Google.Apis.Docs.v1.Data.Shading'
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
