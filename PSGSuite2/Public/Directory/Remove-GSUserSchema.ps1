function Remove-GSUserSchema {
    [cmdletbinding(SupportsShouldProcess = $true,ConfirmImpact = "High")]
    Param
    (
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [Alias('Schema','SchemaKey','SchemaId')]
        [String[]]
        $SchemaName
    )
    Begin {
        if ($PSBoundParameters.Keys -contains 'SchemaName') {
            $serviceParams = @{
                Scope       = 'https://www.googleapis.com/auth/admin.directory.user.userschema'
                ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
            }
            $service = New-GoogleService @serviceParams
        }
    }
    Process {
        try {
            if ($PSBoundParameters.Keys -contains 'SchemaName') {
                foreach ($S in $SchemaName) {
                    if ($PSCmdlet.ShouldProcess("Deleting User Schema '$S'")) {
                        Write-Verbose "Deleting User Schema '$S'"
                        $request = $service.Schemas.Delete($Script:PSGSuite.CustomerID,$S)
                        $request.Execute()
                        Write-Verbose "User Schema '$S' has been successfully deleted"
                    }
                }
            }
            else {
                Get-GSUserSchema | Remove-GSUserSchema
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}