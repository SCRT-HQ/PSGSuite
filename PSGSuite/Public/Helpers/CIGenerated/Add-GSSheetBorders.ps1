function Add-GSSheetBorders {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.Borders object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.Borders object.

    .PARAMETER Bottom
    Accepts the following type: [Google.Apis.Sheets.v4.Data.Border].

    To create this type, use the function Add-GSSheetBorder or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.Border'.

    .PARAMETER Left
    Accepts the following type: [Google.Apis.Sheets.v4.Data.Border].

    To create this type, use the function Add-GSSheetBorder or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.Border'.

    .PARAMETER Right
    Accepts the following type: [Google.Apis.Sheets.v4.Data.Border].

    To create this type, use the function Add-GSSheetBorder or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.Border'.

    .PARAMETER Top
    Accepts the following type: [Google.Apis.Sheets.v4.Data.Border].

    To create this type, use the function Add-GSSheetBorder or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.Border'.

    .EXAMPLE
    Add-GSSheetBorders -Bottom $bottom -Left $left -Right $right -Top $top
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Borders')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.Border]
        $Bottom,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.Border]
        $Left,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.Border]
        $Right,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.Border]
        $Top,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.Borders[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.Borders'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.Borders'
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
