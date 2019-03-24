function Add-GSSheetBasicChartAxis {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.BasicChartAxis object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.BasicChartAxis object.

    .PARAMETER Format
    Accepts the following type: [Google.Apis.Sheets.v4.Data.TextFormat].

    To create this type, use the function Add-GSSheetTextFormat or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.TextFormat'.

    .PARAMETER Position
    Accepts the following type: [string].

    .PARAMETER Title
    Accepts the following type: [string].

    .PARAMETER TitleTextPosition
    Accepts the following type: [Google.Apis.Sheets.v4.Data.TextPosition].

    To create this type, use the function Add-GSSheetTextPosition or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.TextPosition'.

    .EXAMPLE
    Add-GSSheetBasicChartAxis -Format $format -Position $position -Title $title -TitleTextPosition $titleTextPosition
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.BasicChartAxis')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.TextFormat]
        $Format,
        [parameter()]
        [string]
        $Position,
        [parameter()]
        [string]
        $Title,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.TextPosition]
        $TitleTextPosition,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.BasicChartAxis[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.BasicChartAxis'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.BasicChartAxis'
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
