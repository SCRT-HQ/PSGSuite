function Get-GSUserSchemaListPrivate {
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
            $result = $request.Execute()
            if ($null -ne $result.SchemasValue) {
                $result.SchemasValue
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