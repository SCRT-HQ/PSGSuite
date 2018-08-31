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
    
    .PARAMETER ExternalIds
    The externalId objects of the user

    This parameter expects a 'Google.Apis.Admin.Directory.directory_v1.Data.UserExternalId[]' object type. You can create objects of this type easily by using the function 'Add-GSUserExternalId'
    
    .PARAMETER Organizations
    The organization objects of the user

    This parameter expects a 'Google.Apis.Admin.Directory.directory_v1.Data.UserOrganization[]' object type. You can create objects of this type easily by using the function 'Add-GSUserOrganization'
    
    .PARAMETER Phones
    The phone objects of the user

    This parameter expects a 'Google.Apis.Admin.Directory.directory_v1.Data.UserPhone[]' object type. You can create objects of this type easily by using the function 'Add-GSUserPhone'
    
    .PARAMETER IncludeInGlobalAddressList
    Indicates if the user's profile is visible in the G Suite global address list when the contact sharing feature is enabled for the domain. For more information about excluding user profiles, see the administration help center: http://support.google.com/a/bin/answer.py?answer=1285988
    
    .PARAMETER IpWhitelisted
    If true, the user's IP address is white listed: http://support.google.com/a/bin/answer.py?answer=60752
    
    .PARAMETER CustomSchemas
    Custom user attribute values to add to the user's account. 
    
    The Custom Schema and it's fields **MUST** exist prior to updating these values for a user otherwise it will return an error.
    
    This parameter only accepts a hashtable where the keys are Schema Names and the value for each key is another hashtable, i.e.: 

        Update-GSUser -User john.smith@domain.com -CustomSchemas @{
            schemaName1 = @{
                fieldName1 = $fieldValue1
                fieldName2 = $fieldValue2
            }
            schemaName2 = @{
                fieldName3 = $fieldValue3
            }
        }

    If you need to CLEAR a custom schema value, simply pass $null as the value(s) for the fieldName in the hashtable, i.e.:

        Update-GSUser -User john.smith@domain.com -CustomSchemas @{
            schemaName1 = @{
                fieldName1 = $null
                fieldName2 = $null
            }
            schemaName2 = @{
                fieldName3 = $null
            }
        }
    
    .EXAMPLE
    $address = Add-GSUserAddress -Country USA -Locality Dallas -PostalCode 75000 Region TX -StreetAddress '123 South St' -Type Work -Primary

    $phone = Add-GSUserPhone -Type Work -Value "(800) 873-0923" -Primary

    $extId = Add-GSUserExternalId -Type Login_Id -Value jsmith2
    
    New-GSUser -PrimaryEmail john.smith@domain.com -GivenName John -FamilyName Smith -Password (ConvertTo-SecureString -String 'Password123' -AsPlainText -Force) -ChangePasswordAtNextLogin -OrgUnitPath "/Users/New Hires" -IncludeInGlobalAddressList -Addresses $address -Phones $phone -ExternalIds $extId

    Creates a user named John Smith and adds their work address, work phone and login_id to the user object
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
        [Google.Apis.Admin.Directory.directory_v1.Data.UserExternalId[]]
        $ExternalIds,
        [parameter(Mandatory = $false)]
        [Google.Apis.Admin.Directory.directory_v1.Data.UserOrganization[]]
        $Organizations,
        [parameter(Mandatory = $false)]
        [Google.Apis.Admin.Directory.directory_v1.Data.UserPhone[]]
        $Phones,
        [parameter(Mandatory = $false)]
        [Switch]
        $IncludeInGlobalAddressList,
        [parameter(Mandatory = $false)]
        [Switch]
        $IpWhitelisted,
        [parameter(Mandatory = $false)]
        [ValidateScript({
            $hash = $_
            foreach ($schemaName in $hash.Keys) {
                if ($hash[$schemaName].GetType().Name -ne 'Hashtable') {
                    throw "The CustomSchemas parameter only accepts a hashtable where the value of the top-level keys must also be a hashtable. The key '$schemaName' has a value of type '$($hash[$schemaName].GetType().Name)'"
                    $valid = $false
                }
                else {
                    $valid = $true
                }
            }
            $valid
        })]
        [Hashtable]
        $CustomSchemas
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
                    ExternalIds {
                        $extIdList = New-Object 'System.Collections.Generic.List`1[Google.Apis.Admin.Directory.directory_v1.Data.UserExternalId]'
                        foreach ($extId in $ExternalIds) {
                            $extIdList.Add($extId)
                        }
                        $body.ExternalIds = $extIdList
                    }
                    Organizations {
                        $orgList = New-Object 'System.Collections.Generic.List`1[Google.Apis.Admin.Directory.directory_v1.Data.UserOrganization]'
                        foreach ($organization in $Organizations) {
                            $orgList.Add($organization)
                        }
                        $body.Organizations = $orgList
                    }
                    Phones {
                        $phoneList = New-Object 'System.Collections.Generic.List`1[Google.Apis.Admin.Directory.directory_v1.Data.UserPhone]'
                        foreach ($phone in $Phones) {
                            $phoneList.Add($phone)
                        }
                        $body.Phones = $phoneList
                    }
                    CustomSchemas {
                        $schemaDict = New-Object 'System.Collections.Generic.Dictionary`2[[System.String],[System.Collections.Generic.IDictionary`2[[System.String],[System.Object]]]]'
                        foreach ($schemaName in $CustomSchemas.Keys) {
                            $fieldDict = New-Object 'System.Collections.Generic.Dictionary`2[[System.String],[System.Object]]'
                            $schemaFields = $CustomSchemas[$schemaName]
                            $schemaFields.Keys | ForEach-Object {
                                $fieldDict.Add($_,$schemaFields[$_])
                            }
                            $schemaDict.Add($schemaName,$fieldDict)
                        }
                        $body.CustomSchemas = $schemaDict
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
            if ($ErrorActionPreference -eq 'Stop') {
                $PSCmdlet.ThrowTerminatingError($_)
            }
            else {
                Write-Error $_
            }
        }
    }
}