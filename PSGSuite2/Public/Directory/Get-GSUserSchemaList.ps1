function Get-GSUserSchemaList {
    [cmdletbinding()]
    Param( )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.userschema'
            ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        try {
            $request = $service.Schemas.List($Script:PSGSuite.CustomerId)
            $request.Execute() | Select-Object -ExpandProperty SchemasValue
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}