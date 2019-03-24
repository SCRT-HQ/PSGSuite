function Add-GSSlideTableBorderProperties {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Slides.v1.Data.TableBorderProperties object.

    .DESCRIPTION
    Creates a Google.Apis.Slides.v1.Data.TableBorderProperties object.

    .PARAMETER DashStyle
    Accepts the following type: string

    .PARAMETER TableBorderFill
    Accepts the following type: Google.Apis.Slides.v1.Data.TableBorderFill

    .PARAMETER Weight
    Accepts the following type: Google.Apis.Slides.v1.Data.Dimension

    .EXAMPLE
    Add-GSSlideTableBorderProperties -DashStyle $dashStyle -TableBorderFill $tableBorderFill -Weight $weight
    #>
    [OutputType('Google.Apis.Slides.v1.Data.TableBorderProperties')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [string]
        $DashStyle,
        [parameter()]
        [Google.Apis.Slides.v1.Data.TableBorderFill]
        $TableBorderFill,
        [parameter()]
        [Google.Apis.Slides.v1.Data.Dimension]
        $Weight,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Slides.v1.Data.TableBorderProperties[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Slides.v1.Data.TableBorderProperties'
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
                        $obj = New-Object 'Google.Apis.Slides.v1.Data.TableBorderProperties'
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
