function Add-GSSheetPivotGroupValueMetadata {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.PivotGroupValueMetadata object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.PivotGroupValueMetadata object.

    .PARAMETER Collapsed
    Accepts the following type: [switch].

    .PARAMETER Value
    Accepts the following type: [Google.Apis.Sheets.v4.Data.ExtendedValue].

    To create this type, use the function Add-GSSheetExtendedValue or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.ExtendedValue'.

    .EXAMPLE
    Add-GSSheetPivotGroupValueMetadata -Collapsed $collapsed -Value $value
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.PivotGroupValueMetadata')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [switch]
        $Collapsed,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.ExtendedValue]
        $Value,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.PivotGroupValueMetadata[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.PivotGroupValueMetadata'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.PivotGroupValueMetadata'
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
