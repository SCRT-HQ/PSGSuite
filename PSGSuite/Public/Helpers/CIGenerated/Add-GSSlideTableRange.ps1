function Add-GSSlideTableRange {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Slides.v1.Data.TableRange object.

    .DESCRIPTION
    Creates a Google.Apis.Slides.v1.Data.TableRange object.

    .PARAMETER ColumnSpan
    Accepts the following type: [int].

    .PARAMETER Location
    Accepts the following type: [Google.Apis.Slides.v1.Data.TableCellLocation].

    To create this type, use the function Add-GSSlideTableCellLocation or instantiate the type directly via New-Object 'Google.Apis.Slides.v1.Data.TableCellLocation'.

    .PARAMETER RowSpan
    Accepts the following type: [int].

    .EXAMPLE
    Add-GSSlideTableRange -ColumnSpan $columnSpan -Location $location -RowSpan $rowSpan
    #>
    [OutputType('Google.Apis.Slides.v1.Data.TableRange')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [int]
        $ColumnSpan,
        [parameter()]
        [Google.Apis.Slides.v1.Data.TableCellLocation]
        $Location,
        [parameter()]
        [int]
        $RowSpan,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Slides.v1.Data.TableRange[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Slides.v1.Data.TableRange'
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
                        $obj = New-Object 'Google.Apis.Slides.v1.Data.TableRange'
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
