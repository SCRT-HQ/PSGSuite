function Add-GSSlideTableRowProperties {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Slides.v1.Data.TableRowProperties object.

    .DESCRIPTION
    Creates a Google.Apis.Slides.v1.Data.TableRowProperties object.

    .PARAMETER MinRowHeight
    Accepts the following type: Google.Apis.Slides.v1.Data.Dimension

    .EXAMPLE
    Add-GSSlideTableRowProperties -MinRowHeight $minRowHeight
    #>
    [OutputType('Google.Apis.Slides.v1.Data.TableRowProperties')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Slides.v1.Data.Dimension]
        $MinRowHeight,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Slides.v1.Data.TableRowProperties[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Slides.v1.Data.TableRowProperties'
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
                        $obj = New-Object 'Google.Apis.Slides.v1.Data.TableRowProperties'
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
