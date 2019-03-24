function Add-GSSheetNamedRange {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.NamedRange object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.NamedRange object.

    .PARAMETER Name
    Accepts the following type: [string].

    .PARAMETER NamedRangeId
    Accepts the following type: [string].

    .PARAMETER Range
    Accepts the following type: [Google.Apis.Sheets.v4.Data.GridRange].

    To create this type, use the function Add-GSSheetGridRange or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.GridRange'.

    .EXAMPLE
    Add-GSSheetNamedRange -Name $name -NamedRangeId $namedRangeId -Range $range
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.NamedRange')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [string]
        $Name,
        [parameter()]
        [string]
        $NamedRangeId,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.GridRange]
        $Range,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.NamedRange[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.NamedRange'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.NamedRange'
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
