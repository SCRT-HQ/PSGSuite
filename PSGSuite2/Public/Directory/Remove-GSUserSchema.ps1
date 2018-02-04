function Remove-GSUserSchema {
    <#
    .SYNOPSIS
    Removes a custom user schema
    
    .DESCRIPTION
    Removes a custom user schema
    
    .PARAMETER SchemaId
    The SchemaId or SchemaName to remove. If excluded, all Custom User Schemas for the customer will be removed    
    .EXAMPLE
    Remove-GSUserSchema 2SV

    Removes the custom user schema named '2SV'
    #>
    [cmdletbinding(SupportsShouldProcess = $true,ConfirmImpact = "High")]
    Param
    (
        [parameter(Mandatory = $false,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [Alias('Schema','SchemaKey','SchemaName')]
        [String[]]
        $SchemaId
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
            if ($PSBoundParameters.Keys -contains 'SchemaId') {
                foreach ($S in $SchemaId) {
                    if ($PSCmdlet.ShouldProcess("Deleting User Schema '$S'")) {
                        Write-Verbose "Deleting User Schema '$S'"
                        $request = $service.Schemas.Delete($Script:PSGSuite.CustomerID,$S)
                        $request.Execute()
                        Write-Verbose "User Schema '$S' has been successfully deleted"
                    }
                }
            }
            else {
                if ($PSCmdlet.ShouldProcess("Deleting ALL User Schemas")) {
                    Write-Verbose "Deleting ALL User Schemas"
                    Get-GSUserSchema -Verbose:$false | ForEach-Object {
                        $request = $service.Schemas.Delete($Script:PSGSuite.CustomerID,$_.SchemaId)
                        $request.Execute()
                        Write-Verbose "User Schema '$($_.SchemaId)' has been successfully deleted"
                    }
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}