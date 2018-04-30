function Update-GSUser {
    <#
    .SYNOPSIS
    Updates a user
    
    .DESCRIPTION
    Updates a user
    
    .PARAMETER User
    The primary email or unique Id of the user to update
    
    .PARAMETER PrimaryEmail
    The new primary email for the user. The previous primary email will become an alias automatically
    
    .PARAMETER GivenName
    The new given (first) name for the user
    
    .PARAMETER FamilyName
    The new family (last) name for the user
    
    .PARAMETER FullName
    The new full name for the user
    
    .PARAMETER Password
    The new password for the user as a SecureString
    
    .PARAMETER ChangePasswordAtNextLogin
    If set, user will need to change their password on their next login
    
    .PARAMETER OrgUnitPath
    The new OrgUnitPath for the user
    
    .PARAMETER Suspended
    If set to $true or passed as a bare switch (-Suspended), user will be suspended. If set to $false, user will be unsuspended. If excluded, user's suspension status will remain as-is
    
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
    
    .PARAMETER CustomSchemas
    Custom user attribute values to add to the user's account. This parameter only accepts a hashtable where the keys are Schema Names and the value for each key is another hashtable, i.e.: 
        @{
            schemaName1 = @{
                fieldName1 = $fieldValue1
                fieldName2 = $fieldValue2
            }
            schemaName2 = @{
                fieldName3 = $fieldValue3
            }
        }

    If you need to CLEAR a custom schema value, simply pass $null as the value(s) for the fieldName in the hashtable, i.e.:
        @{
            schemaName1 = @{
                fieldName1 = $null
                fieldName2 = $null
            }
            schemaName2 = @{
                fieldName3 = $null
            }
        }

    The Custom Schema and it's fields **MUST** exist prior to updating these values for a user otherwise it will return an error.
    
    .EXAMPLE
    Update-GSUser -User john.smith@domain.com -PrimaryEmail johnathan.smith@domain.com -GivenName Johnathan -Suspended:$false
    
    Updates user john.smith@domain.com with a new primary email of "johnathan.smith@domain.com", sets their Given Name to "Johnathan" and unsuspends them. Their previous primary email "john.smith@domain.com" will become an alias on their account automatically
    #>
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [Alias("Id","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $User,
        [parameter(Mandatory = $false)]
        [String]
        $PrimaryEmail,
        [parameter(Mandatory = $false)]
        [String]
        $GivenName,
        [parameter(Mandatory = $false)]
        [String]
        $FamilyName,
        [parameter(Mandatory = $false)]
        [String]
        $FullName,
        [parameter(Mandatory = $false)]
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
            if ($User -ceq 'me') {
                $User = $Script:PSGSuite.AdminEmail
            }
            elseif ($User -notlike "*@*.*") {
                $User = "$($User)@$($Script:PSGSuite.Domain)"
            }
            Write-Verbose "Updating user '$User'"
            $userObj = Get-GSUser $User -Verbose:$false
            $body = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.User'
            $name = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.UserName'
            $nameUpdated = $false
            foreach ($prop in $PSBoundParameters.Keys | Where-Object {$body.PSObject.Properties.Name -contains $_ -or $name.PSObject.Properties.Name -contains $_}) {
                switch ($prop) {
                    PrimaryEmail {
                        if ($PSBoundParameters[$prop] -notlike "*@*.*") {
                            $PSBoundParameters[$prop] = "$($PSBoundParameters[$prop])@$($Script:PSGSuite.Domain)"
                        }
                        $body.$prop = $PSBoundParameters[$prop]
                    }
                    GivenName {
                        $name.$prop = $PSBoundParameters[$prop]
                        $nameUpdated = $true
                    }
                    FamilyName {
                        $name.$prop = $PSBoundParameters[$prop]
                        $nameUpdated = $true
                    }
                    FullName {
                        $name.$prop = $PSBoundParameters[$prop]
                        $nameUpdated = $true
                    }
                    Password {
                        $body.Password = (New-Object PSCredential "user",$Password).GetNetworkCredential().Password
                    }
                    CustomSchemas {
                        $schemaDict = New-Object 'System.Collections.Generic.Dictionary`2[[System.String],[System.Collections.Generic.IDictionary`2[[System.String],[System.Object]]]]'
                        foreach ($schemaName in $CustomSchemas.Keys) {
                            $fieldDict = New-Object 'System.Collections.Generic.Dictionary`2[[System.String],[System.Object]]'
                            $schemaFields = $CustomSchema[$schemaName]
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
            if ($nameUpdated) {
                $body.Name = $name
            }
            $request = $service.Users.Update($body,$userObj.Id)
            $request.Execute() | Select-Object @{N = "User";E = {$_.PrimaryEmail}},*
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