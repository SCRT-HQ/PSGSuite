function Add-GSSheetDimensionProperties {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.DimensionProperties object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.DimensionProperties object.

    .PARAMETER DeveloperMetadata
    Accepts the following type: System.Collections.Generic.IList[Google.Apis.Sheets.v4.Data.DeveloperMetadata][]

    .PARAMETER HiddenByFilter
    Accepts the following type: bool

    .PARAMETER HiddenByUser
    Accepts the following type: bool

    .PARAMETER PixelSize
    Accepts the following type: int

    .EXAMPLE
    Add-GSSheetDimensionProperties -DeveloperMetadata $developerMetadata -HiddenByFilter $hiddenByFilter -HiddenByUser $hiddenByUser -PixelSize $pixelSize
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.DimensionProperties')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [System.Collections.Generic.IList[Google.Apis.Sheets.v4.Data.DeveloperMetadata][]]
        $DeveloperMetadata,
        [parameter()]
        [bool]
        $HiddenByFilter,
        [parameter()]
        [bool]
        $HiddenByUser,
        [parameter()]
        [int]
        $PixelSize,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.DimensionProperties[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.DimensionProperties'
                    foreach ($prop in $PSBoundParameters.Keys | Where-Object {$obj.PSObject.Properties.Name -contains $_}) {
                        switch ($prop) {
                            DeveloperMetadata {
                                $list = New-Object 'System.Collections.Generic.List[System.Collections.Generic.IList[Google.Apis.Sheets.v4.Data.DeveloperMetadata]]'
                                foreach ($item in $DeveloperMetadata) {
                                    $list.Add($item)
                                }
                                $obj.DeveloperMetadata = $list
                            }
                            default {
                                $obj.$prop = $PSBoundParameters[$prop]
                            }
                        }
                    }
                    $obj
                }
                InputObject {
                    foreach ($iObj in $InputObject) {
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.DimensionProperties'
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
