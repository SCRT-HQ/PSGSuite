function Add-GSSheetDeveloperMetadataLookup {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.DeveloperMetadataLookup object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.DeveloperMetadataLookup object.

    .PARAMETER LocationMatchingStrategy
    Accepts the following type: [string].

    .PARAMETER LocationType
    Accepts the following type: [string].

    .PARAMETER MetadataId
    Accepts the following type: [int].

    .PARAMETER MetadataKey
    Accepts the following type: [string].

    .PARAMETER MetadataLocation
    Accepts the following type: [Google.Apis.Sheets.v4.Data.DeveloperMetadataLocation].

    To create this type, use the function Add-GSSheetDeveloperMetadataLocation or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.DeveloperMetadataLocation'.

    .PARAMETER MetadataValue
    Accepts the following type: [string].

    .PARAMETER Visibility
    Accepts the following type: [string].

    .EXAMPLE
    Add-GSSheetDeveloperMetadataLookup -LocationMatchingStrategy $locationMatchingStrategy -LocationType $locationType -MetadataId $metadataId -MetadataKey $metadataKey -MetadataLocation $metadataLocation -MetadataValue $metadataValue -Visibility $visibility
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.DeveloperMetadataLookup')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [string]
        $LocationMatchingStrategy,
        [parameter()]
        [string]
        $LocationType,
        [parameter()]
        [int]
        $MetadataId,
        [parameter()]
        [string]
        $MetadataKey,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.DeveloperMetadataLocation]
        $MetadataLocation,
        [parameter()]
        [string]
        $MetadataValue,
        [parameter()]
        [string]
        $Visibility,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.DeveloperMetadataLookup[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.DeveloperMetadataLookup'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.DeveloperMetadataLookup'
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
