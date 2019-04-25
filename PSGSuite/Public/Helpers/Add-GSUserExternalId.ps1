function Add-GSUserExternalId {
    <#
    .SYNOPSIS
    Builds a UserExternalId object to use when creating or updating a User

    .DESCRIPTION
    Builds a UserExternalId object to use when creating or updating a User

    .PARAMETER CustomType
    If the external ID type is custom, this property holds the custom type

    .PARAMETER Type
    The type of the ID.

    Acceptable values are:
    * "account"
    * "custom"
    * "customer"
    * "login_id"
    * "network"
    * "organization": For example, Employee ID.

    .PARAMETER Value
    The value of the ID

    .PARAMETER InputObject
    Used for pipeline input of an existing UserExternalId object to strip the extra attributes and prevent errors

    .EXAMPLE
    $address = Add-GSUserAddress -Country USA -Locality Dallas -PostalCode 75000 Region TX -StreetAddress '123 South St' -Type Work -Primary

    $phone = Add-GSUserPhone -Type Work -Value "(800) 873-0923" -Primary

    $extId = Add-GSUserExternalId -Type Login_Id -Value jsmith2

    $email = Add-GSUserEmail -Type work -Address jsmith@contoso.com

    New-GSUser -PrimaryEmail john.smith@domain.com -GivenName John -FamilyName Smith -Password (ConvertTo-SecureString -String 'Password123' -AsPlainText -Force) -ChangePasswordAtNextLogin -OrgUnitPath "/Users/New Hires" -IncludeInGlobalAddressList -Addresses $address -Phones $phone -ExternalIds $extId -Emails $email

    Creates a user named John Smith and adds their work address, work phone, login_id and alternate non gsuite work email to the user object.
    #>
    [OutputType('Google.Apis.Admin.Directory.directory_v1.Data.UserExternalId')]
    [CmdletBinding(DefaultParameterSetName = "InputObject")]
    Param
    (
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [String]
        $CustomType,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [ValidateSet('account', 'custom', 'customer', 'login_id', 'network', 'organization')]
        [String]
        $Type,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [Alias('ExternalId')]
        [String]
        $Value,
        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ParameterSetName = "InputObject")]
        [Google.Apis.Admin.Directory.directory_v1.Data.UserExternalId[]]
        $InputObject
    )
    Begin {
        $propsToWatch = @(
            'CustomType'
            'Type'
            'Value'
        )
    }
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.UserExternalId'
                    foreach ($prop in $PSBoundParameters.Keys | Where-Object {$obj.PSObject.Properties.Name -contains $_}) {
                        $obj.$prop = $PSBoundParameters[$prop]
                    }
                    $obj
                }
                InputObject {
                    foreach ($iObj in $InputObject) {
                        $obj = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.UserExternalId'
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
