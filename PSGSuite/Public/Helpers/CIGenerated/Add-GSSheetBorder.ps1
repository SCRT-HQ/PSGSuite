function Add-GSSheetBorder {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.Border object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.Border object.

    .PARAMETER Color
    Accepts the following type: [Google.Apis.Sheets.v4.Data.Color].

    To create this type, use the function Add-GSSheetColor or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.Color'.

    .PARAMETER Style
    Accepts the following type: [string].

    .PARAMETER Width
    Accepts the following type: [int].

    .EXAMPLE
    Add-GSSheetBorder -Color $color -Style $style -Width $width
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Border')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.Color]
        $Color,
        [parameter()]
        [string]
        $Style,
        [parameter()]
        [int]
        $Width,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.Border[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.Border'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.Border'
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
