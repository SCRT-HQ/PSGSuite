function Add-GSUserSchemaField {
    [CmdletBinding(DefaultParameterSetName = "InputObject")]
    Param
    (
        [Parameter(Mandatory = $false,ParameterSetName = "Fields")]
        [String]
        $FieldName,
        [Parameter(Mandatory = $false,ParameterSetName = "Fields")]
        [ValidateSet("BOOL","DATE","DOUBLE","EMAIL","INT64","PHONE","STRING")]
        [String]
        $FieldType = "STRING",
        [Parameter(Mandatory = $false,ParameterSetName = "Fields")]
        [Switch]
        $Indexed,
        [Parameter(Mandatory = $false,ParameterSetName = "Fields")]
        [Switch]
        $MultiValued,
        [Parameter(Mandatory = $false,ParameterSetName = "Fields")]
        [ValidateSet("ADMINS_AND_SELF","ALL_DOMAIN_USERS")]
        [String]
        $ReadAccessType = "ADMINS_AND_SELF",
        [Parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Admin.Directory.directory_v1.Data.SchemaFieldSpec[]]
        $InputObject
    )
    Begin {
        $propsToWatch = @(
            'FieldName'
            'FieldType'
            'Indexed'
            'MultiValued'
            'ReadAccessType'
        )
    }
    Process {
        switch ($PSCmdlet.ParameterSetName) {
            Fields {
                $obj = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.SchemaFieldSpec'
                foreach ($prop in $PSBoundParameters.Keys | Where-Object {$obj.PSObject.Properties.Name -contains $_}) {
                    $obj.$prop = $PSBoundParameters[$prop]
                }
                $obj
            }
            InputObject {
                foreach ($iObj in $InputObject) {
                    $obj = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.SchemaFieldSpec'
                    foreach ($prop in $iObj.PSObject.Properties.Name | Where-Object {$obj.PSObject.Properties.Name -contains $_ -and $propsToWatch -contains $_}) {
                        $obj.$prop = $iObj.$prop
                    }
                    $obj
                }
            }
        }
    }
}