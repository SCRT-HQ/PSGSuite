function Add-GSSheetPadding {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.Padding object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.Padding object.

    .PARAMETER Bottom
    Accepts the following type: [int].

    .PARAMETER Left
    Accepts the following type: [int].

    .PARAMETER Right
    Accepts the following type: [int].

    .PARAMETER Top
    Accepts the following type: [int].

    .EXAMPLE
    Add-GSSheetPadding -Bottom $bottom -Left $left -Right $right -Top $top
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Padding')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [int]
        $Bottom,
        [parameter()]
        [int]
        $Left,
        [parameter()]
        [int]
        $Right,
        [parameter()]
        [int]
        $Top,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.Padding[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.Padding'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.Padding'
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
