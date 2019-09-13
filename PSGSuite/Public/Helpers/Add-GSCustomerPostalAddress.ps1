function Add-GSCustomerPostalAddress {
    <#
    .SYNOPSIS
    Builds a PostalAddress object to use when creating or updating a Customer

    .DESCRIPTION
    Builds a PostalAddress object to use when creating or updating a Customer

    .PARAMETER AddressLine1
    A customer's physical address. The address can be composed of one to three lines.

    .PARAMETER AddressLine2
    Address line 2 of the address.

    .PARAMETER AddressLine3
    Address line 3 of the address.

    .PARAMETER ContactName
    The customer contact's name.

    .PARAMETER CountryCode
    The country code. Uses the ISO 3166-1 standard: http://www.iso.org/iso/iso-3166-1_decoding_table

    .PARAMETER Locality
    Name of the locality. An example of a locality value is the city of San Francisco.

    .PARAMETER OrganizationName
    The company or company division name.

    .PARAMETER PostalCode
    The postal code. A postalCode example is a postal zip code such as 10009. This is in accordance with - http://portablecontacts.net/draft-spec.html#address_element.

    .PARAMETER Region
    Name of the region. An example of a region value is NY for the state of New York.

    .PARAMETER InputObject
    Used for pipeline input of an existing UserAddress object to strip the extra attributes and prevent errors

    .EXAMPLE
    Add-GSCustomerPostalAddress -AddressLine1 '123 Front St' -AddressLine2 'Los Angeles, CA 90210' -ContactName 'Jim'
    #>
    [OutputType('Google.Apis.Admin.Directory.directory_v1.Data.CustomerPostalAddress')]
    [CmdletBinding(DefaultParameterSetName = "InputObject")]
    Param
    (
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [String]
        $AddressLine1,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [String]
        $AddressLine2,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [String]
        $AddressLine3,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [String]
        $ContactName,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [String]
        $CountryCode,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [Alias('Town', 'City')]
        [String]
        $Locality,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [String]
        $OrganizationName,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [String]
        $PostalCode,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [Alias('State', 'Province')]
        [String]
        $Region,
        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ParameterSetName = "InputObject")]
        [Google.Apis.Admin.Directory.directory_v1.Data.CustomerPostalAddress]
        $InputObject
    )
    Begin {
        $propsToWatch = @(
            'AddressLine1'
            'AddressLine2'
            'AddressLine3'
            'ContactName'
            'CountryCode'
            'Locality'
            'OrganizationName'
            'PostalCode'
            'Region'
        )
    }
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.CustomerPostalAddress'
                    foreach ($prop in $PSBoundParameters.Keys | Where-Object {$obj.PSObject.Properties.Name -contains $_}) {
                        $obj.$prop = $PSBoundParameters[$prop]
                    }
                    $obj
                }
                InputObject {
                    $obj = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.CustomerPostalAddress'
                    foreach ($prop in $InputObject.PSObject.Properties.Name | Where-Object {$obj.PSObject.Properties.Name -contains $_ -and $propsToWatch -contains $_}) {
                        $obj.$prop = $InputObject.$prop
                    }
                    $obj
                }
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
