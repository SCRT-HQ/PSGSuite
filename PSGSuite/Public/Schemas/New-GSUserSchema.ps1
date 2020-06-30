function New-GSUserSchema {
    <#
    .SYNOPSIS
    Creates a new user schema

    .DESCRIPTION
    Creates a new user schema

    .PARAMETER SchemaName
    The name of the schema to create

    .PARAMETER Fields
    New schema fields to set

    Expects SchemaFieldSpec objects. You can create these with the helper function Add-GSUserSchemaField, i.e.: Add-GSUserSchemaField -FieldName "date" -FieldType DATE -ReadAccessType ADMINS_AND_SELF

    .EXAMPLE
    New-GSUserSchema -SchemaName "SDK" -Fields (Add-GSUserSchemaField -FieldName "string" -FieldType STRING -ReadAccessType ADMINS_AND_SELF),(Add-GSUserSchemaField -FieldName "date" -FieldType DATE -ReadAccessType ADMINS_AND_SELF)

    This command will create a schema named "SDK" with two fields, "string" and "date", readable by ADMINS_AND_SELF
    #>
    [OutputType('Google.Apis.Admin.Directory.directory_v1.Data.Schema')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true)]
        [String]
        $SchemaName,
        [parameter(Mandatory = $true)]
        [Google.Apis.Admin.Directory.directory_v1.Data.SchemaFieldSpec[]]
        $Fields
    )
    Process {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.userschema'
            ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        }
        $service = New-GoogleService @serviceParams
        try {
            Write-Verbose "Creating schema '$SchemaName'"
            $body = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.Schema'
            foreach ($prop in $PSBoundParameters.Keys | Where-Object {$body.PSObject.Properties.Name -contains $_}) {
                switch ($prop) {
                    Default {
                        $body.$prop = $PSBoundParameters[$prop]
                    }
                }
            }
            $request = $service.Schemas.Insert($body,$Script:PSGSuite.CustomerId)
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
