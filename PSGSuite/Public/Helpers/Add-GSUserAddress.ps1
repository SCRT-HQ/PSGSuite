function Add-GSUserAddress {
    <#
    .SYNOPSIS
    Builds a UserAddress object to use when creating or updating a User

    .DESCRIPTION
    Builds a UserAddress object to use when creating or updating a User

    .PARAMETER Country
    Country

    .PARAMETER CountryCode
    The country code. Uses the ISO 3166-1 standard: http://www.iso.org/iso/iso-3166-1_decoding_table

    .PARAMETER CustomType
    If the address type is custom, this property contains the custom value

    .PARAMETER ExtendedAddress
    For extended addresses, such as an address that includes a sub-region

    .PARAMETER Formatted
    A full and unstructured postal address. This is not synced with the structured address fields

    .PARAMETER Locality
    The town or city of the address

    .PARAMETER PoBox
    The post office box, if present

    .PARAMETER PostalCode
    The ZIP or postal code, if applicable

    .PARAMETER Primary
    If this is the user's primary address. The addresses list may contain only one primary address

    .PARAMETER Region
    The abbreviated province or state

    .PARAMETER SourceIsStructured
    Indicates if the user-supplied address was formatted. Formatted addresses are not currently supported

    .PARAMETER StreetAddress
    The street address, such as 1600 Amphitheatre Parkway. Whitespace within the string is ignored; however, newlines are significant

    .PARAMETER Type
    The address type.

    Acceptable values are:
    * "custom"
    * "home"
    * "other"
    * "work"

    .PARAMETER InputObject
    Used for pipeline input of an existing UserAddress object to strip the extra attributes and prevent errors

    .EXAMPLE
    $address = Add-GSUserAddress -Country USA -Locality Dallas -PostalCode 75000 Region TX -StreetAddress '123 South St' -Type Work -Primary

    $phone = Add-GSUserPhone -Type Work -Value "(800) 873-0923" -Primary

    $extId = Add-GSUserExternalId -Type Login_Id -Value jsmith2

    $email = Add-GSUserEmail -Type work -Address jsmith@contoso.com

    New-GSUser -PrimaryEmail john.smith@domain.com -GivenName John -FamilyName Smith -Password (ConvertTo-SecureString -String 'Password123' -AsPlainText -Force) -ChangePasswordAtNextLogin -OrgUnitPath "/Users/New Hires" -IncludeInGlobalAddressList -Addresses $address -Phones $phone -ExternalIds $extId -Emails $email

    Creates a user named John Smith and adds their work address, work phone, login_id and alternate non gsuite work email to the user object.
    #>
    [OutputType('Google.Apis.Admin.Directory.directory_v1.Data.UserAddress')]
    [CmdletBinding(DefaultParameterSetName = "InputObject")]
    Param
    (
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [String]
        $Country,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [String]
        $CountryCode,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [String]
        $CustomType,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [String]
        $ExtendedAddress,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [String]
        $Formatted,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [Alias('Town', 'City')]
        [String]
        $Locality,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [String]
        $PoBox,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [String]
        $PostalCode,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [Switch]
        $Primary,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [Alias('State', 'Province')]
        [String]
        $Region,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [Switch]
        $SourceIsStructured,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [String]
        $StreetAddress,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [ValidateSet('custom', 'home', 'other', 'work')]
        [String]
        $Type,
        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ParameterSetName = "InputObject")]
        [Google.Apis.Admin.Directory.directory_v1.Data.UserAddress[]]
        $InputObject
    )
    Begin {
        $propsToWatch = @(
            'Country'
            'CountryCode'
            'CustomType'
            'ExtendedAddress'
            'Formatted'
            'Locality'
            'PoBox'
            'PostalCode'
            'Primary'
            'Region'
            'SourceIsStructured'
            'StreetAddress'
            'Type'
        )
    }
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.UserAddress'
                    foreach ($prop in $PSBoundParameters.Keys | Where-Object {$obj.PSObject.Properties.Name -contains $_}) {
                        if ($prop -eq 'Type') {
                            $obj.$prop = $PSBoundParameters[$prop].ToLower()
                        }
                        else {
                            $obj.$prop = $PSBoundParameters[$prop]
                        }
                    }
                    $obj
                }
                InputObject {
                    foreach ($iObj in $InputObject) {
                        $obj = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.UserAddress'
                        foreach ($prop in $iObj.PSObject.Properties.Name | Where-Object {$obj.PSObject.Properties.Name -contains $_ -and $propsToWatch -contains $_}) {
                            $obj.$prop = $iObj.$prop
                        }
                        $obj
                    }
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
