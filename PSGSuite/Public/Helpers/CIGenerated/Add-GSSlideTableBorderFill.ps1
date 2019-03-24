function Add-GSSlideTableBorderFill {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Slides.v1.Data.TableBorderFill object.

    .DESCRIPTION
    Creates a Google.Apis.Slides.v1.Data.TableBorderFill object.

    .PARAMETER SolidFill
    Accepts the following type: [Google.Apis.Slides.v1.Data.SolidFill].

    To create this type, use the function Add-GSSlideSolidFill or instantiate the type directly via New-Object 'Google.Apis.Slides.v1.Data.SolidFill'.

    .EXAMPLE
    Add-GSSlideTableBorderFill -SolidFill $solidFill
    #>
    [OutputType('Google.Apis.Slides.v1.Data.TableBorderFill')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Slides.v1.Data.SolidFill]
        $SolidFill,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Slides.v1.Data.TableBorderFill[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Slides.v1.Data.TableBorderFill'
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
                        $obj = New-Object 'Google.Apis.Slides.v1.Data.TableBorderFill'
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
