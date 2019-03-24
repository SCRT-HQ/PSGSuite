function Add-GSSheetTextRotation {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.TextRotation object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.TextRotation object.

    .PARAMETER Angle
    Accepts the following type: int

    .PARAMETER Vertical
    Accepts the following type: bool

    .EXAMPLE
    Add-GSSheetTextRotation -Angle $angle -Vertical $vertical
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.TextRotation')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [int]
        $Angle,
        [parameter()]
        [bool]
        $Vertical,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.TextRotation[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.TextRotation'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.TextRotation'
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
