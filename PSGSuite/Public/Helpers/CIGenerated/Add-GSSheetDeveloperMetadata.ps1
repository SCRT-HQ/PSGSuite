function Add-GSSheetDeveloperMetadata {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.DeveloperMetadata object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.DeveloperMetadata object.

    .PARAMETER Location
    Accepts the following type: Google.Apis.Sheets.v4.Data.DeveloperMetadataLocation

    .PARAMETER MetadataId
    Accepts the following type: int

    .PARAMETER MetadataKey
    Accepts the following type: string

    .PARAMETER MetadataValue
    Accepts the following type: string

    .PARAMETER Visibility
    Accepts the following type: string

    .EXAMPLE
    Add-GSSheetDeveloperMetadata -Location $location -MetadataId $metadataId -MetadataKey $metadataKey -MetadataValue $metadataValue -Visibility $visibility
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.DeveloperMetadata')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.DeveloperMetadataLocation]
        $Location,
        [parameter()]
        [int]
        $MetadataId,
        [parameter()]
        [string]
        $MetadataKey,
        [parameter()]
        [string]
        $MetadataValue,
        [parameter()]
        [string]
        $Visibility,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.DeveloperMetadata[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.DeveloperMetadata'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.DeveloperMetadata'
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
