function Add-GSUserLocation {
    <#
    .SYNOPSIS
    Builds a Location object to use when creating or updating a User

    .DESCRIPTION
    Builds a Location object to use when creating or updating a User

    .PARAMETER Area
    Textual location. This is most useful for display purposes to concisely describe the location. For example, "Mountain View, CA", "Near Seattle", "US-NYC-9TH 9A209A"

    .PARAMETER BuildingId
    Building Identifier.

    .PARAMETER CustomType
    Custom Type.

    .PARAMETER DeskCode
    Most specific textual code of individual desk location.

    .PARAMETER 	FloorName
    Floor name/number.

    .PARAMETER 	FloorSection
    Floor section. More specific location within the floor. For example, if a floor is divided into sections "A", "B", and "C", this field would identify one of those values.

    .PARAMETER Type
    Each entry can have a type which indicates standard types of that entry. For example location could be of types default and desk. In addition to standard type, an entry can have a custom type and can give it any name. Such types should have "custom" as type and also have a customType value.

    Acceptable values are:
    * "custom"
    * "default"
    * "desk"

    .PARAMETER InputObject
    Used for pipeline input of an existing Location object to strip the extra attributes and prevent errors

    .EXAMPLE
    Add-GSUserLocation -Area "Bellevue, WA" -BuildingId '30' -CustomType "LemonadeStand" -Type custom

    Adds a custom user location.
    #>
    [OutputType('Google.Apis.Admin.Directory.directory_v1.Data.UserLocation')]
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [String]
        $Area,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [String]
        $BuildingId,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [String]
        $CustomType,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [String]
        $DeskCode,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [String]
        $FloorName,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [String]
        $FloorSection,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [ValidateSet('custom', 'default', 'desk')]
        [String]
        $Type,
        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ParameterSetName = "InputObject")]
        [Google.Apis.Admin.Directory.directory_v1.Data.UserLocation[]]
        $InputObject
    )
    Begin {
        $propsToWatch = @(
            'Area'
            'BuildingId'
            'CustomType'
            'DeskCode'
            'FloorName'
            'FloorSection'
            'Type'
        )
    }
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.UserLocation'
                    foreach ($prop in $PSBoundParameters.Keys | Where-Object {$obj.PSObject.Properties.Name -contains $_}) {
                        $obj.$prop = $PSBoundParameters[$prop]
                    }
                    $obj
                }
                InputObject {
                    foreach ($iObj in $InputObject) {
                        $obj = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.UserLocation'
                        foreach ($prop in $iObj.PSObject.Properties.Name | Where-Object {$obj.PSObject.Properties.Name -contains $_ -and $propsToWatch -contains $_}) {
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
