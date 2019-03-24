function Add-GSSheetDimensionProperties {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.DimensionProperties object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.DimensionProperties object.

    .PARAMETER DeveloperMetadata
    Accepts the following type: [Google.Apis.Sheets.v4.Data.DeveloperMetadata[]].

    To create this type, use the function Add-GSSheetDeveloperMetadata or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.DeveloperMetadata'.

    .PARAMETER HiddenByFilter
    Accepts the following type: [switch].

    .PARAMETER HiddenByUser
    Accepts the following type: [switch].

    .PARAMETER PixelSize
    Accepts the following type: [int].

    .EXAMPLE
    Add-GSSheetDimensionProperties -DeveloperMetadata $developerMetadata -HiddenByFilter $hiddenByFilter -HiddenByUser $hiddenByUser -PixelSize $pixelSize
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.DimensionProperties')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.DeveloperMetadata[]]
        $DeveloperMetadata,
        [parameter()]
        [switch]
        $HiddenByFilter,
        [parameter()]
        [switch]
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
                                $list = New-Object 'System.Collections.Generic.List[Google.Apis.Sheets.v4.Data.DeveloperMetadata]'
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
