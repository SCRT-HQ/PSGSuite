function Add-GSSlideTableColumnProperties {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Slides.v1.Data.TableColumnProperties object.

    .DESCRIPTION
    Creates a Google.Apis.Slides.v1.Data.TableColumnProperties object.

    .PARAMETER ColumnWidth
    Accepts the following type: [Google.Apis.Slides.v1.Data.Dimension].

    To create this type, use the function Add-GSSlideDimension or instantiate the type directly via New-Object 'Google.Apis.Slides.v1.Data.Dimension'.

    .EXAMPLE
    Add-GSSlideTableColumnProperties -ColumnWidth $columnWidth
    #>
    [OutputType('Google.Apis.Slides.v1.Data.TableColumnProperties')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Slides.v1.Data.Dimension]
        $ColumnWidth,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Slides.v1.Data.TableColumnProperties[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Slides.v1.Data.TableColumnProperties'
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
                        $obj = New-Object 'Google.Apis.Slides.v1.Data.TableColumnProperties'
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
