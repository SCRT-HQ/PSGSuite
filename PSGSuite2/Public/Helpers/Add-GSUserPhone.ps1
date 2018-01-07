function Add-GSUserPhone {
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $false,ParameterSetName = "Fields")]
        [String]
        $CustomType,
        [Parameter(Mandatory = $false,ParameterSetName = "Fields")]
        [Switch]
        $Primary,
        [Parameter(Mandatory = $false,ParameterSetName = "Fields")]
        [String]
        $Type,
        [Parameter(Mandatory = $false,ParameterSetName = "Fields")]
        [Alias('Phone')]
        [String]
        $Value,
        [Parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Admin.Directory.directory_v1.Data.UserAddress[]]
        $InputObject
    )
    Begin {
        $propsToWatch = @(
            'CustomType'
            'Type'
            'Value'
        )
    }
    Process {
        switch ($PSCmdlet.ParameterSetName) {
            Fields {
                $obj = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.UserPhone'
                foreach ($prop in $PSBoundParameters.Keys | Where-Object {$obj.PSObject.Properties.Name -contains $_}) {
                    $obj.$prop = $PSBoundParameters[$prop]
                }
                $obj
            }
            InputObject {
                foreach ($iObj in $InputObject) {
                    $obj = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.UserPhone'
                    foreach ($prop in $iObj.PSObject.Properties.Name | Where-Object {$obj.PSObject.Properties.Name -contains $_ -and $propsToWatch -contains $_}) {
                        $obj.$prop = $iObj.$prop
                    }
                    $obj
                }
            }
        }
    }
}