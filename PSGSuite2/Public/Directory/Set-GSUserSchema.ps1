function Set-GSUserSchema {
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
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}