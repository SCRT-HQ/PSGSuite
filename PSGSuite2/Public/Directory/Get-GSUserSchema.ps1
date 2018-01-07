function Get-GSUserSchema {
    [cmdletbinding()]
    [Alias('Get-GSUserSchemaInfo')]
    Param
    (
        [parameter(Mandatory = $false,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [Alias('Schema')]
        [String[]]
        $SchemaId
    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.userschema'
            ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        }
        if ($PSBoundParameters.Keys -contains 'SchemaId') {
            $service = New-GoogleService @serviceParams
        }
    }
    Process {
        try {
            if ($PSBoundParameters.Keys -contains 'SchemaId') {
                foreach ($S in $SchemaId) {
                    $request = $service.Schemas.Get($Script:PSGSuite.CustomerId,$S)
                    $request.Execute()
                }
            }
            else {
                Get-GSUserSchemaList
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}