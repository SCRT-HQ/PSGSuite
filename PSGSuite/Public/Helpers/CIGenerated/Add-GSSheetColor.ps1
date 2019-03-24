function Add-GSSheetColor {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.Color object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.Color object.

    .PARAMETER Alpha
    Accepts the following type: [float].

    .PARAMETER Blue
    Accepts the following type: [float].

    .PARAMETER Green
    Accepts the following type: [float].

    .PARAMETER Red
    Accepts the following type: [float].

    .EXAMPLE
    Add-GSSheetColor -Alpha $alpha -Blue $blue -Green $green -Red $red
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Color')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [float]
        $Alpha,
        [parameter()]
        [float]
        $Blue,
        [parameter()]
        [float]
        $Green,
        [parameter()]
        [float]
        $Red,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.Color[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.Color'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.Color'
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
