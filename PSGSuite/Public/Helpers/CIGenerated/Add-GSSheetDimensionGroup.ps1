function Add-GSSheetDimensionGroup {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.DimensionGroup object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.DimensionGroup object.

    .PARAMETER Collapsed
    Accepts the following type: [switch].

    .PARAMETER Depth
    Accepts the following type: [int].

    .PARAMETER Range
    Accepts the following type: [Google.Apis.Sheets.v4.Data.DimensionRange].

    To create this type, use the function Add-GSSheetDimensionRange or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.DimensionRange'.

    .EXAMPLE
    Add-GSSheetDimensionGroup -Collapsed $collapsed -Depth $depth -Range $range
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.DimensionGroup')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [switch]
        $Collapsed,
        [parameter()]
        [int]
        $Depth,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.DimensionRange]
        $Range,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.DimensionGroup[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.DimensionGroup'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.DimensionGroup'
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
