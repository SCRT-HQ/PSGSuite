function Add-GSSheetTextFormat {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.TextFormat object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.TextFormat object.

    .PARAMETER Bold
    Accepts the following type: bool

    .PARAMETER FontFamily
    Accepts the following type: string

    .PARAMETER FontSize
    Accepts the following type: int

    .PARAMETER ForegroundColor
    Accepts the following type: Google.Apis.Sheets.v4.Data.Color

    .PARAMETER Italic
    Accepts the following type: bool

    .PARAMETER Strikethrough
    Accepts the following type: bool

    .PARAMETER Underline
    Accepts the following type: bool

    .EXAMPLE
    Add-GSSheetTextFormat -Bold $bold -FontFamily $fontFamily -FontSize $fontSize -ForegroundColor $foregroundColor -Italic $italic -Strikethrough $strikethrough -Underline $underline
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.TextFormat')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [bool]
        $Bold,
        [parameter()]
        [string]
        $FontFamily,
        [parameter()]
        [int]
        $FontSize,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.Color]
        $ForegroundColor,
        [parameter()]
        [bool]
        $Italic,
        [parameter()]
        [bool]
        $Strikethrough,
        [parameter()]
        [bool]
        $Underline,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.TextFormat[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.TextFormat'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.TextFormat'
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
