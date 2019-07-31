function Update-GSCustomer {
    <#
    .SYNOPSIS
    Updates a customer using patch semantics.

    .DESCRIPTION
    Updates a customer using patch semantics.

    .PARAMETER CustomerKey
    Id of the Customer to be updated.

    .PARAMETER AlternateEmail
    The customer's secondary contact email address. This email address cannot be on the same domain as the customerDomain.

    .PARAMETER CustomerDomain
    The customer's primary domain name string. Do not include the www prefix when creating a new customer.

    .PARAMETER Language
    The customer's ISO 639-2 language code. The default value is en-US.

    .PARAMETER PhoneNumber
    The customer's contact phone number in E.164 format.

    .PARAMETER PostalAddress
    The customer's postal address information.

    Must be type [Google.Apis.Admin.Directory.directory_v1.Data.CustomerPostalAddress]. Use helper function Add-GSCustomerPostalAddress to create the correct type easily.

    .EXAMPLE
    Get-GSCustomer (Get-GSUser).CustomerId
    #>
    [OutputType('Google.Apis.Admin.Directory.directory_v1.Data.Customer')]
    [CmdletBinding()]
    Param(
        [Parameter(Position = 0,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [Alias('CustomerId')]
        [String]
        $CustomerKey = $Script:PSGSuite.CustomerId,
        [Parameter()]
        [String]
        $AlternateEmail,
        [Parameter()]
        [String]
        $CustomerDomain,
        [Parameter()]
        [String]
        $Language,
        [Parameter()]
        [String]
        $PhoneNumber,
        [Parameter()]
        [Google.Apis.Admin.Directory.directory_v1.Data.CustomerPostalAddress]
        $PostalAddress
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
            $body = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.Customer'
            foreach ($key in $PSBoundParameters.Keys | Where-Object {$body.PSObject.Properties.Name -contains $_}) {
                $body.$key = $PSBoundParameters[$key]
            }
            Write-Verbose "Updating Customer '$CustomerKey'"
            $request = $service.Customers.Patch($body,$CustomerKey)
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
