function Get-GSCustomer {
    <#
    .SYNOPSIS
    Retrieves a customer

    .DESCRIPTION
    Retrieves a customer

    .PARAMETER CustomerKey
    Id of the Customer to be retrieved

    .EXAMPLE
    Get-GSCustomer (Get-GSUser).CustomerId
    #>
    [OutputType('Google.Apis.Admin.Directory.directory_v1.Data.Customer')]
    [CmdletBinding()]
    Param(
        [Parameter(Position = 0,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [Alias('CustomerId')]
        [String]
        $CustomerKey = $Script:PSGSuite.CustomerId
    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.customer'
            ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        try {
            Write-Verbose "Getting Customer '$CustomerKey'"
            $request = $service.Customers.Get($CustomerKey)
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
