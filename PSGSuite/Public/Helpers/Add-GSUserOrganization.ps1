function Add-GSUserOrganization {
    <#
    .SYNOPSIS
    Builds a Organization object to use when creating or updating a User

    .DESCRIPTION
    Builds a Organization object to use when creating or updating a User

    .PARAMETER CostCenter
    The cost center of the users department

    .PARAMETER CustomType
    If the external ID type is custom, this property holds the custom type

    .PARAMETER Department
    Department within the organization

    .PARAMETER Description
    Description of the organization

    .PARAMETER Domain
    The domain to which the organization belongs to

    .PARAMETER FullTimeEquivalent
    The full-time equivalent percent within the organization (100000 = 100%).

    .PARAMETER Location
    Location of the organization. This need not be fully qualified address.

    .PARAMETER Name
    Name of the organization

    .PARAMETER Primary
    If it is the user's primary organization

    .PARAMETER Symbol
    Symbol of the organization

    .PARAMETER Title
    Title (designation) of the user in the organization

    .PARAMETER Type
    The type of the organization.

    If using a CustomType

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
    [OutputType('Google.Apis.Admin.Directory.directory_v1.Data.UserOrganization')]
    [CmdletBinding(DefaultParameterSetName = "InputObject")]
    Param
    (
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [String]
        $CostCenter,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [String]
        $CustomType,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [String]
        $Department,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [String]
        $Description,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [String]
        $Domain,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [Int]
        $FullTimeEquivalent,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [String]
        $Location,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [String]
        $Name,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [Switch]
        $Primary,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [String]
        $Symbol,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [String]
        $Title,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [String]
        $Type,
        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ParameterSetName = "InputObject")]
        [Google.Apis.Admin.Directory.directory_v1.Data.UserOrganization[]]
        $InputObject
    )
    Begin {
        $propsToWatch = @(
            'CostCenter'
            'CustomType'
            'Department'
            'Description'
            'Domain'
            'FullTimeEquivalent'
            'Location'
            'Name'
            'Primary'
            'Symbol'
            'Title'
            'Type'
        )
        if ($PSBoundParameters.Keys -contains 'CustomType') {
            $PSBoundParameters['Type'] = 'CUSTOM'
        }
    }
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.UserOrganization'
                    foreach ($prop in $PSBoundParameters.Keys | Where-Object {$obj.PSObject.Properties.Name -contains $_}) {
                        $obj.$prop = $PSBoundParameters[$prop]
                    }
                    $obj
                }
                InputObject {
                    foreach ($iObj in $InputObject) {
                        $obj = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.UserOrganization'
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
