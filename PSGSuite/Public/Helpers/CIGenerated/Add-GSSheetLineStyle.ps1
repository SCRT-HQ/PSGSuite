function Add-GSSheetLineStyle {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.LineStyle object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.LineStyle object.

    .PARAMETER Type
    Accepts the following type: string

    .PARAMETER Width
    Accepts the following type: int

    .EXAMPLE
    Add-GSSheetLineStyle -Type $type -Width $width
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.LineStyle')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [string]
        $Type,
        [parameter()]
        [int]
        $Width,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.LineStyle[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.LineStyle'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.LineStyle'
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
