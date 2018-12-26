function Set-GSUserSchema {
    <#
    .SYNOPSIS
    Hard-sets a schema's configuration

    .DESCRIPTION
    Hard-sets a schema's configuration

    .PARAMETER SchemaId
    The unique Id of the schema to set

    .PARAMETER SchemaName
    The new schema name

    .PARAMETER Fields
    New schema fields to set

    Expects SchemaFieldSpec objects. You can create these with the helper function Add-GSUserSchemaField, i.e.: Add-GSUserSchemaField -FieldName "date" -FieldType DATE -ReadAccessType ADMINS_AND_SELF

    .EXAMPLE
    Set-GSUserSchema -SchemaId "9804800jfl08917304j" -SchemaName "SDK_2" -Fields (Add-GSUserSchemaField -FieldName "string2" -FieldType STRING -ReadAccessType ADMINS_AND_SELF)

    This command will set the schema Id '9804800jfl08917304j' with the name "SDK_2" and one field "string2" readable by ADMINS_AND_SELF
    #>
    [OutputType('Google.Apis.Admin.Directory.directory_v1.Data.Schema')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [Alias('Schema')]
        [String]
        $SchemaId,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [String]
        $SchemaName,
        [parameter(Mandatory = $false)]
        [Google.Apis.Admin.Directory.directory_v1.Data.SchemaFieldSpec[]]
        $Fields
    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.userschema'
            ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        try {
            Write-Verbose "Setting schema '$SchemaId'"
            $schemaObj = Get-GSUserSchema -Schema $SchemaId -Verbose:$false
            $body = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.Schema'
            foreach ($prop in $PSBoundParameters.Keys | Where-Object {$body.PSObject.Properties.Name -contains $_}) {
                $body.$prop = $PSBoundParameters[$prop]
            }
            $request = $service.Schemas.Update($body,$Script:PSGSuite.CustomerId,$schemaObj.SchemaId)
            $request.Execute()
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
