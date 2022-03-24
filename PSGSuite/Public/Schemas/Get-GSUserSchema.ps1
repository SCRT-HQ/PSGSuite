function Get-GSUserSchema {
    <#
    .SYNOPSIS
    Gets custom user schema info

    .DESCRIPTION
    Gets custom user schema info

    .PARAMETER SchemaId
    The Id or Name of the user schema you would like to return info for. If excluded, gets the full list of user schemas

    .EXAMPLE
    Get-GSUserSchema

    Gets the list of custom user schemas
    #>
    [OutputType('Google.Apis.Admin.Directory.directory_v1.Data.Schema')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [Alias('Schema')]
        [String[]]
        $SchemaId
    )
    Process {
        if ($PSBoundParameters.Keys -contains 'SchemaId') {
            $serviceParams = @{
                Scope       = 'https://www.googleapis.com/auth/admin.directory.userschema'
                ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
            }
            $service = New-GoogleService @serviceParams
        }
        try {
            if ($PSBoundParameters.Keys -contains 'SchemaId') {
                foreach ($S in $SchemaId) {
                    Write-Verbose "Getting schema Id '$S'"
                    $request = $service.Schemas.Get($Script:PSGSuite.CustomerId,$S)
                    $request.Execute()
                }
            }
            else {
                Get-GSUserSchemaListPrivate @PSBoundParameters
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
