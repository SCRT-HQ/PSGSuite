function Add-GSSheetEmbeddedObjectPosition {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.EmbeddedObjectPosition object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.EmbeddedObjectPosition object.

    .PARAMETER NewSheet
    Accepts the following type: bool

    .PARAMETER OverlayPosition
    Accepts the following type: Google.Apis.Sheets.v4.Data.OverlayPosition

    .PARAMETER SheetId
    Accepts the following type: int

    .EXAMPLE
    Add-GSSheetEmbeddedObjectPosition -NewSheet $newSheet -OverlayPosition $overlayPosition -SheetId $sheetId
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.EmbeddedObjectPosition')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [bool]
        $NewSheet,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.OverlayPosition]
        $OverlayPosition,
        [parameter()]
        [int]
        $SheetId,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.EmbeddedObjectPosition[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.EmbeddedObjectPosition'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.EmbeddedObjectPosition'
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
