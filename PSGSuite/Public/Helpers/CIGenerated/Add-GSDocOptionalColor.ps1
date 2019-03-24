function Add-GSDocOptionalColor {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Docs.v1.Data.OptionalColor object.

    .DESCRIPTION
    Creates a Google.Apis.Docs.v1.Data.OptionalColor object.

    .PARAMETER Color
    Accepts the following type: [Google.Apis.Docs.v1.Data.Color].

    To create this type, use the function Add-GSDocColor or instantiate the type directly via New-Object 'Google.Apis.Docs.v1.Data.Color'.

    .EXAMPLE
    Add-GSDocOptionalColor -Color $color
    #>
    [OutputType('Google.Apis.Docs.v1.Data.OptionalColor')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Docs.v1.Data.Color]
        $Color,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Docs.v1.Data.OptionalColor[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Docs.v1.Data.OptionalColor'
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
                        $obj = New-Object 'Google.Apis.Docs.v1.Data.OptionalColor'
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
