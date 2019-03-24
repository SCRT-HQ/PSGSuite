function Add-GSSheetDataFilter {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.DataFilter object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.DataFilter object.

    .PARAMETER A1Range
    Accepts the following type: string

    .PARAMETER DeveloperMetadataLookup
    Accepts the following type: Google.Apis.Sheets.v4.Data.DeveloperMetadataLookup

    .PARAMETER GridRange
    Accepts the following type: Google.Apis.Sheets.v4.Data.GridRange

    .EXAMPLE
    Add-GSSheetDataFilter -A1Range $a1Range -DeveloperMetadataLookup $developerMetadataLookup -GridRange $gridRange
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.DataFilter')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [string]
        $A1Range,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.DeveloperMetadataLookup]
        $DeveloperMetadataLookup,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.GridRange]
        $GridRange,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.DataFilter[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.DataFilter'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.DataFilter'
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
