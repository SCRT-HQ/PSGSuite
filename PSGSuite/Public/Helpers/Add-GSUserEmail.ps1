function Add-GSUserEmail {
    <#
    .SYNOPSIS
    Builds a Email object to use when creating or updating a User

    .DESCRIPTION
    Builds a Email object to use when creating or updating a User

    .PARAMETER Address
    The user's email address. Also serves as the email ID. This value can be the user's primary email address or an alias.

    .PARAMETER CustomType
    If the value of type is custom, this property contains the custom type.

    .PARAMETER Primary
    Indicates if this is the user's primary email. Only one entry can be marked as primary.

    .PARAMETER Type
    The type of the email account.

    Acceptable values are:
    * "custom"
    * "home"
    * "other"
    * "work"

    .PARAMETER InputObject
    Used for pipeline input of an existing Email object to strip the extra attributes and prevent errors

    .EXAMPLE
    $address = Add-GSUserAddress -Country USA -Locality Dallas -PostalCode 75000 Region TX -StreetAddress '123 South St' -Type Work -Primary

    $phone = Add-GSUserPhone -Type Work -Value "(800) 873-0923" -Primary

    $extId = Add-GSUserExternalId -Type Login_Id -Value jsmith2

    $email = Add-GSUserEmail -Type work -Address jsmith@contoso.com

    New-GSUser -PrimaryEmail john.smith@domain.com -GivenName John -FamilyName Smith -Password (ConvertTo-SecureString -String 'Password123' -AsPlainText -Force) -ChangePasswordAtNextLogin -OrgUnitPath "/Users/New Hires" -IncludeInGlobalAddressList -Addresses $address -Phones $phone -ExternalIds $extId -Emails $email

    Creates a user named John Smith and adds their work address, work phone, login_id and alternate non gsuite work email to the user object.
    #>
    [OutputType('Google.Apis.Admin.Directory.directory_v1.Data.UserEmail')]
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [String]
        $Address,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [String]
        $CustomType,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [Switch]
        $Primary,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [ValidateSet('custom', 'home', 'other', 'work')]
        [String]
        $Type,
        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ParameterSetName = "InputObject")]
        [Google.Apis.Admin.Directory.directory_v1.Data.UserEmail[]]
        $InputObject
    )
    Begin {
        $propsToWatch = @(
            'Address'
            'CustomType'
            'Type'
        )
    }
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.UserEmail'
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
                        $obj = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.UserEmail'
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
