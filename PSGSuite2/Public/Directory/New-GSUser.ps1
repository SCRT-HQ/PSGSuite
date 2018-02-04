function New-GSUser {
    <#
    .SYNOPSIS
    Creates a new G Suite user
    
    .DESCRIPTION
    Creates a new G Suite user
    
    .PARAMETER PrimaryEmail
    The primary email for the user. If a user with the desired email already exists, a GoogleApiException will be thrown
    
    .PARAMETER GivenName
    The given (first) name of the user
    
    .PARAMETER FamilyName
    The family (last) name of the user
    
    .PARAMETER FullName
    The full name of the user, if different from "$FirstName $LastName"
    
    .PARAMETER Password
    The password for the user. Requires a SecureString
    
    .PARAMETER ChangePasswordAtNextLogin
    If set, user will need to change their password on their first login
    
    .PARAMETER OrgUnitPath
    The OrgUnitPath to create the user in
    
    .PARAMETER Suspended
    If set, user will be created in a suspended state
    
    .PARAMETER Addresses
    The address objects of the user

    This parameter expects a 'Google.Apis.Admin.Directory.directory_v1.Data.UserAddress[]' object type. You can create objects of this type easily by using the function 'Add-GSUserAddress'
    
    .PARAMETER Phones
    The phone objects of the user

    This parameter expects a 'Google.Apis.Admin.Directory.directory_v1.Data.UserPhone[]' object type. You can create objects of this type easily by using the function 'Add-GSUserPhone'
    
    .PARAMETER ExternalIds
    The externalId objects of the user

    This parameter expects a 'Google.Apis.Admin.Directory.directory_v1.Data.UserExternalId[]' object type. You can create objects of this type easily by using the function 'Add-GSUserExternalId'
    
    .PARAMETER IncludeInGlobalAddressList
    Indicates if the user's profile is visible in the G Suite global address list when the contact sharing feature is enabled for the domain. For more information about excluding user profiles, see the administration help center: http://support.google.com/a/bin/answer.py?answer=1285988
    
    .PARAMETER IpWhitelisted
    	If true, the user's IP address is white listed: http://support.google.com/a/bin/answer.py?answer=60752
    
    .EXAMPLE
    New-GSUser -PrimaryEmail john.smith@domain.com -GivenName John -FamilyName Smith -Password (ConvertTo-SecureString -String 'Password123' -AsPlainText -Force) -ChangePasswordAtNextLogin -OrgUnitPath "/Users/New Hires" -IncludeInGlobalAddressList

    Creates a user named "John Smith" in the OrgUnit '/Users/New Hires'
    #>
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0)]
        [String]
        $PrimaryEmail,
        [parameter(Mandatory = $true)]
        [String]
        $GivenName,
        [parameter(Mandatory = $true)]
        [String]
        $FamilyName,
        [parameter(Mandatory = $false)]
        [String]
        $FullName,
        [parameter(Mandatory = $true)]
        [SecureString]
        $Password,
        [parameter(Mandatory = $false)]
        [Switch]
        $ChangePasswordAtNextLogin,
        [parameter(Mandatory = $false)]
        [String]
        $OrgUnitPath,
        [parameter(Mandatory = $false)]
        [Switch]
        $Suspended,
        [parameter(Mandatory = $false)]
        [Google.Apis.Admin.Directory.directory_v1.Data.UserAddress[]]
        $Addresses,
        [parameter(Mandatory = $false)]
        [Google.Apis.Admin.Directory.directory_v1.Data.UserPhone[]]
        $Phones,
        [parameter(Mandatory = $false)]
        [Google.Apis.Admin.Directory.directory_v1.Data.UserExternalId[]]
        $ExternalIds,
        [parameter(Mandatory = $false)]
        [Switch]
        $IncludeInGlobalAddressList,
        [parameter(Mandatory = $false)]
        [Switch]
        $IpWhitelisted
    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.user'
            ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        try {
            Write-Verbose "Creating user '$PrimaryEmail'"
            $body = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.User'
            $name = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.UserName' -Property @{
                GivenName  = $GivenName
                FamilyName = $FamilyName
            }
            if ($PSBoundParameters.Keys -contains 'FullName') {
                $name.FullName = $FullName
            }
            else {
                $name.FullName = "$GivenName $FamilyName"
            }
            $body.Name = $name
            foreach ($prop in $PSBoundParameters.Keys | Where-Object {$body.PSObject.Properties.Name -contains $_}) {
                switch ($prop) {
                    PrimaryEmail {
                        if ($PSBoundParameters[$prop] -notlike "*@*.*") {
                            $PSBoundParameters[$prop] = "$($PSBoundParameters[$prop])@$($Script:PSGSuite.Domain)"
                        }
                        $body.$prop = $PSBoundParameters[$prop]
                    }
                    Password {
                        $body.Password = (New-Object PSCredential "user",$Password).GetNetworkCredential().Password
                    }
                    Default {
                        $body.$prop = $PSBoundParameters[$prop]
                    }
                }
            }
            $request = $service.Users.Insert($body)
            $request.Execute()
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}