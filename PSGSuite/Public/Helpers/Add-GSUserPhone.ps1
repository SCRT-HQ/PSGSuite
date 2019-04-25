function Add-GSUserPhone {
    <#
    .SYNOPSIS
    Builds a UserPhone object to use when creating or updating a User

    .DESCRIPTION
    Builds a UserPhone object to use when creating or updating a User

    .PARAMETER CustomType
    If the value of type is custom, this property contains the custom type

    .PARAMETER Primary
    Indicates if this is the user's primary phone number. A user may only have one primary phone number

    .PARAMETER Type
    The type of phone number.

    Acceptable values are:
    * "assistant"
    * "callback"
    * "car"
    * "company_main"
    * "custom"
    * "grand_central"
    * "home"
    * "home_fax"
    * "isdn"
    * "main"
    * "mobile"
    * "other"
    * "other_fax"
    * "pager"
    * "radio"
    * "telex"
    * "tty_tdd"
    * "work"
    * "work_fax"
    * "work_mobile"
    * "work_pager"

    .PARAMETER Value
    A human-readable phone number. It may be in any telephone number format

    .PARAMETER InputObject
    Used for pipeline input of an existing UserPhone object to strip the extra attributes and prevent errors

    .EXAMPLE
    $address = Add-GSUserAddress -Country USA -Locality Dallas -PostalCode 75000 Region TX -StreetAddress '123 South St' -Type Work -Primary

    $phone = Add-GSUserPhone -Type Work -Value "(800) 873-0923" -Primary

    $extId = Add-GSUserExternalId -Type Login_Id -Value jsmith2

    $email = Add-GSUserEmail -Type work -Address jsmith@contoso.com

    New-GSUser -PrimaryEmail john.smith@domain.com -GivenName John -FamilyName Smith -Password (ConvertTo-SecureString -String 'Password123' -AsPlainText -Force) -ChangePasswordAtNextLogin -OrgUnitPath "/Users/New Hires" -IncludeInGlobalAddressList -Addresses $address -Phones $phone -ExternalIds $extId -Emails $email

    Creates a user named John Smith and adds their work address, work phone, login_id and alternate non gsuite work email to the user object.
    #>
    [OutputType('Google.Apis.Admin.Directory.directory_v1.Data.UserAddress')]
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [String]
        $CustomType,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [Switch]
        $Primary,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [ValidateSet('assistant', 'callback', 'car', 'company_main', 'custom', 'grand_central', 'home', 'home_fax', 'isdn', 'main', 'mobile', 'other', 'other_fax', 'pager', 'radio', 'telex', 'tty_tdd', 'work', 'work_fax', 'work_mobile', 'work_pager')]
        [String]
        $Type,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [Alias('Phone')]
        [String]
        $Value,
        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ParameterSetName = "InputObject")]
        [Google.Apis.Admin.Directory.directory_v1.Data.UserAddress[]]
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
                    $obj = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.UserPhone'
                    foreach ($prop in $PSBoundParameters.Keys | Where-Object {$obj.PSObject.Properties.Name -contains $_}) {
                        $obj.$prop = $PSBoundParameters[$prop]
                    }
                    $obj
                }
                InputObject {
                    foreach ($iObj in $InputObject) {
                        $obj = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.UserPhone'
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
