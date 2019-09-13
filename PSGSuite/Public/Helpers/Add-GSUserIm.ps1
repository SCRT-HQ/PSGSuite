function Add-GSUserIm {
    <#
    .SYNOPSIS
    Builds an IM object to use when creating or updating a User

    .DESCRIPTION
    Builds an IM object to use when creating or updating a User

    .PARAMETER CustomProtocol
    If the protocol value is custom_protocol, this property holds the custom protocol's string.

    .PARAMETER CustomType
    If the value of type is custom, this property contains the custom type.

    .PARAMETER Im
    The user's IM network ID.

    .PARAMETER Primary
    If this is the user's primary IM. Only one entry in the IM list can have a value of true.

    .PARAMETER Protocol
    An IM protocol identifies the IM network. The value can be a custom network or the standard network.

    Acceptable values are:
    * "aim": AOL Instant Messenger protocol
    * "custom_protocol": A custom IM network protocol
    * "gtalk": Google Talk protocol
    * "icq": ICQ protocol
    * "jabber": Jabber protocol
    * "msn": MSN Messenger protocol
    * "net_meeting": Net Meeting protocol
    * "qq": QQ protocol
    * "skype": Skype protocol
    * "yahoo": Yahoo Messenger protocol


"aim","custom_protocol","gtalk","icq","jabber","msn","net_meeting","qq","skype","yahoo"

    .PARAMETER Type
    The type of the IM account.

    Acceptable values are:
    * "custom"
    * "home"
    * "other"
    * "work"

    .PARAMETER InputObject
    Used for pipeline input of an existing IM object to strip the extra attributes and prevent errors

    .EXAMPLE
    $address = Add-GSUserAddress -Country USA -Locality Dallas -PostalCode 75000 Region TX -StreetAddress '123 South St' -Type Work -Primary

    $phone = Add-GSUserPhone -Type Work -Value "(800) 873-0923" -Primary

    $extId = Add-GSUserExternalId -Type Login_Id -Value jsmith2

    $email = Add-GSUserEmail -Type work -Address jsmith@contoso.com

    $im = Add-GSUserIm -Type work -Protocol custom_protocol -CustomProtocol spark -Im jsmithertons100

    New-GSUser -PrimaryEmail john.smith@domain.com -GivenName John -FamilyName Smith -Password (ConvertTo-SecureString -String 'Password123' -AsPlainText -Force) -ChangePasswordAtNextLogin -OrgUnitPath "/Users/New Hires" -IncludeInGlobalAddressList -Addresses $address -Phones $phone -ExternalIds $extId -Emails $email -Ims $im

    Creates a user named John Smith and adds their work address, work phone, IM, login_id and alternate non gsuite work email to the user object.
    #>
    [OutputType('Google.Apis.Admin.Directory.directory_v1.Data.UserIm')]
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [String]
        $CustomProtocol,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [String]
        $CustomType,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [String]
        $Im,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [Switch]
        $Primary,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [ValidateSet("aim","custom_protocol","gtalk","icq","jabber","msn","net_meeting","qq","skype","yahoo")]
        [String]
        $Protocol,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [ValidateSet('custom', 'home', 'other', 'work')]
        [String]
        $Type,
        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ParameterSetName = "InputObject")]
        [Google.Apis.Admin.Directory.directory_v1.Data.UserIm[]]
        $InputObject
    )
    Begin {
        $propsToWatch = @(
            'CustomProtocol'
            'CustomType'
            'Im'
            'Primary'
            'Protocol'
            'Type'
        )
    }
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.UserIm'
                    foreach ($prop in $PSBoundParameters.Keys | Where-Object {$obj.PSObject.Properties.Name -contains $_}) {
                        if ($prop -in @('Type','Protocol')) {
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
                        $obj = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.UserIm'
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
