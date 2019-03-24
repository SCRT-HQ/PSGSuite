function Add-GSSlideTableCellProperties {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Slides.v1.Data.TableCellProperties object.

    .DESCRIPTION
    Creates a Google.Apis.Slides.v1.Data.TableCellProperties object.

    .PARAMETER ContentAlignment
    Accepts the following type: string

    .PARAMETER TableCellBackgroundFill
    Accepts the following type: Google.Apis.Slides.v1.Data.TableCellBackgroundFill

    .EXAMPLE
    Add-GSSlideTableCellProperties -ContentAlignment $contentAlignment -TableCellBackgroundFill $tableCellBackgroundFill
    #>
    [OutputType('Google.Apis.Slides.v1.Data.TableCellProperties')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [string]
        $ContentAlignment,
        [parameter()]
        [Google.Apis.Slides.v1.Data.TableCellBackgroundFill]
        $TableCellBackgroundFill,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Slides.v1.Data.TableCellProperties[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Slides.v1.Data.TableCellProperties'
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
                        $obj = New-Object 'Google.Apis.Slides.v1.Data.TableCellProperties'
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
