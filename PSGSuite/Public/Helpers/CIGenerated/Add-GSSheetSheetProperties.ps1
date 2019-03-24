function Add-GSSheetSheetProperties {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.SheetProperties object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.SheetProperties object.

    .PARAMETER GridProperties
    Accepts the following type: [Google.Apis.Sheets.v4.Data.GridProperties].

    To create this type, use the function Add-GSSheetGridProperties or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.GridProperties'.

    .PARAMETER Hidden
    Accepts the following type: [switch].

    .PARAMETER Index
    Accepts the following type: [int].

    .PARAMETER RightToLeft
    Accepts the following type: [switch].

    .PARAMETER SheetId
    Accepts the following type: [int].

    .PARAMETER SheetType
    Accepts the following type: [string].

    .PARAMETER TabColor
    Accepts the following type: [Google.Apis.Sheets.v4.Data.Color].

    To create this type, use the function Add-GSSheetColor or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.Color'.

    .PARAMETER Title
    Accepts the following type: [string].

    .EXAMPLE
    Add-GSSheetSheetProperties -GridProperties $gridProperties -Hidden $hidden -Index $index -RightToLeft $rightToLeft -SheetId $sheetId -SheetType $sheetType -TabColor $tabColor -Title $title
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.SheetProperties')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.GridProperties]
        $GridProperties,
        [parameter()]
        [switch]
        $Hidden,
        [parameter()]
        [int]
        $Index,
        [parameter()]
        [switch]
        $RightToLeft,
        [parameter()]
        [int]
        $SheetId,
        [parameter()]
        [string]
        $SheetType,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.Color]
        $TabColor,
        [parameter()]
        [string]
        $Title,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.SheetProperties[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.SheetProperties'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.SheetProperties'
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
