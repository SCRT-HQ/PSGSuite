function Add-GSSheetSourceAndDestination {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.SourceAndDestination object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.SourceAndDestination object.

    .PARAMETER Dimension
    Accepts the following type: [string].

    .PARAMETER FillLength
    Accepts the following type: [int].

    .PARAMETER Source
    Accepts the following type: [Google.Apis.Sheets.v4.Data.GridRange].

    To create this type, use the function Add-GSSheetGridRange or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.GridRange'.

    .EXAMPLE
    Add-GSSheetSourceAndDestination -Dimension $dimension -FillLength $fillLength -Source $source
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.SourceAndDestination')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [string]
        $Dimension,
        [parameter()]
        [int]
        $FillLength,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.GridRange]
        $Source,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.SourceAndDestination[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.SourceAndDestination'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.SourceAndDestination'
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
