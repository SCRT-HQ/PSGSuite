function Add-GSSheetNumberFormat {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.NumberFormat object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.NumberFormat object.

    .PARAMETER Pattern
    Accepts the following type: string

    .PARAMETER Type
    Accepts the following type: string

    .EXAMPLE
    Add-GSSheetNumberFormat -Pattern $pattern -Type $type
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.NumberFormat')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [string]
        $Pattern,
        [parameter()]
        [string]
        $Type,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.NumberFormat[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.NumberFormat'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.NumberFormat'
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
