function Add-GSUserSchemaField {
    <#
    .SYNOPSIS
    Builds a UserPhone object to use when creating or updating a Schema

    .DESCRIPTION
    Builds a UserPhone object to use when creating or updating a Schema

    .PARAMETER FieldName
    The name of the field

    .PARAMETER FieldType
    The type of the field.


    * Acceptable values are:
    * "BOOL": Boolean values.
    * "DATE": Dates in ISO-8601 format: http://www.w3.org/TR/NOTE-datetime
    * "DOUBLE": Double-precision floating-point values.
    * "EMAIL": Email addresses.
    * "INT64": 64-bit integer values.
    * "PHONE": Phone numbers.
    * "STRING": String values.

    .PARAMETER Indexed
    Switch specifying whether the field is indexed or not. Default: true

    .PARAMETER MultiValued
    A switch specifying whether this is a multi-valued field or not. Default: false

    .PARAMETER ReadAccessType
    Specifies who can view values of this field. See 'Retrieve users as a non-administrator' for more information: https://developers.google.com/admin-sdk/directory/v1/guides/manage-users#retrieve_users_non_admin

    Note: It may take up to 24 hours for changes to this field to be reflected.

    Acceptable values are:
    * "ADMINS_AND_SELF"
    * "ALL_DOMAIN_USERS"

    .PARAMETER InputObject
    Used for pipeline input of an existing UserSchemaField object to strip the extra attributes and prevent errors.

    .EXAMPLE
    New-GSUserSchema -SchemaName "SDK" -Fields (Add-GSUserSchemaField -FieldName "string" -FieldType STRING -ReadAccessType ADMINS_AND_SELF),(Add-GSUserSchemaField -FieldName "date" -FieldType DATE -ReadAccessType ADMINS_AND_SELF)

    This command will create a schema named "SDK" with two fields, "string" and "date", readable by ADMINS_AND_SELF
    #>
    [OutputType('Google.Apis.Admin.Directory.directory_v1.Data.SchemaFieldSpec')]
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
        try {
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
