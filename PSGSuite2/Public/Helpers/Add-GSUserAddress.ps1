function Add-GSUserAddress {
    [CmdletBinding(DefaultParameterSetName = "InputObject")]
    Param
    (
        [Parameter(Mandatory = $false,ParameterSetName = "Fields")]
        [String]
        $Country,
        [Parameter(Mandatory = $false,ParameterSetName = "Fields")]
        [String]
        $CountryCode,
        [Parameter(Mandatory = $false,ParameterSetName = "Fields")]
        [String]
        $CustomType,
        [Parameter(Mandatory = $false,ParameterSetName = "Fields")]
        [String]
        $ExtendedAddress,
        [Parameter(Mandatory = $false,ParameterSetName = "Fields")]
        [String]
        $Formatted,
        [Parameter(Mandatory = $false,ParameterSetName = "Fields")]
        [String]
        $Locality,
        [Parameter(Mandatory = $false,ParameterSetName = "Fields")]
        [String]
        $PoBox,
        [Parameter(Mandatory = $false,ParameterSetName = "Fields")]
        [String]
        $PostalCode,
        [Parameter(Mandatory = $false,ParameterSetName = "Fields")]
        [Switch]
        $Primary,
        [Parameter(Mandatory = $false,ParameterSetName = "Fields")]
        [String]
        $Region,
        [Parameter(Mandatory = $false,ParameterSetName = "Fields")]
        [Switch]
        $SourceIsStructured,
        [Parameter(Mandatory = $false,ParameterSetName = "Fields")]
        [String]
        $StreetAddress,
        [Parameter(Mandatory = $false,ParameterSetName = "Fields")]
        [String]
        $Type,
        [Parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Admin.Directory.directory_v1.Data.UserAddress[]]
        $InputObject
    )
    Begin {
        $propsToWatch = @(
            'Country'
            'CountryCode'
            'CustomType'
            'ExtendedAddress'
            'Formatted'
            'Locality'
            'PoBox'
            'PostalCode'
            'Primary'
            'Region'
            'SourceIsStructured'
            'StreetAddress'
            'Type'
        )
    }
    Process {
        switch ($PSCmdlet.ParameterSetName) {
            Fields {
                $obj = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.UserAddress'
                foreach ($prop in $PSBoundParameters.Keys | Where-Object {$obj.PSObject.Properties.Name -contains $_}) {
                    $obj.$prop = $PSBoundParameters[$prop]
                }
                $obj
            }
            InputObject {
                foreach ($iObj in $InputObject) {
                    $obj = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.UserAddress'
                    foreach ($prop in $iObj.PSObject.Properties.Name | Where-Object {$obj.PSObject.Properties.Name -contains $_ -and $propsToWatch -contains $_}) {
                        $obj.$prop = $iObj.$prop
                    }
                    $obj
                }
            }
        }
    }
}