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

    .PARAMETER Emails
    The email objects of the user

    This parameter expects a 'Google.Apis.Admin.Directory.directory_v1.Data.UserEmail[]' object type. You can create objects of this type easily by using the function 'Add-GSUserEmail'

    .PARAMETER ExternalIds
    The externalId objects of the user

    This parameter expects a 'Google.Apis.Admin.Directory.directory_v1.Data.UserExternalId[]' object type. You can create objects of this type easily by using the function 'Add-GSUserExternalId'

    To CLEAR all values for a user, pass `$null` as the value for this parameter.

    .PARAMETER Ims
    The IM objects of the user

    This parameter expects a 'Google.Apis.Admin.Directory.directory_v1.Data.UserIm[]' object type. You can create objects of this type easily by using the function 'Add-GSUserIm'

    To CLEAR all values for a user, pass `$null` as the value for this parameter.

    .PARAMETER Locations
    The Location objects of the user

    This parameter expects a 'Google.Apis.Admin.Directory.directory_v1.Data.UserLocation[]' object type. You can create objects of this type easily by using the function 'Add-GSUserLocation'

    To CLEAR all values for a user, pass `$null` as the value for this parameter.

    .PARAMETER Organizations
    The organization objects of the user

    This parameter expects a 'Google.Apis.Admin.Directory.directory_v1.Data.UserOrganization[]' object type. You can create objects of this type easily by using the function 'Add-GSUserOrganization'

    To CLEAR all values for a user, pass `$null` as the value for this parameter.

    .PARAMETER Relations
    A list of the user's relationships to other users.

    This parameter expects a 'Google.Apis.Admin.Directory.directory_v1.Data.UserRelation[]' object type. You can create objects of this type easily by using the function 'Add-GSUserRelation'

    To CLEAR all values for a user, pass `$null` as the value for this parameter.

    .PARAMETER Phones
    The phone objects of the user

    This parameter expects a 'Google.Apis.Admin.Directory.directory_v1.Data.UserPhone[]' object type. You can create objects of this type easily by using the function 'Add-GSUserPhone'

    To CLEAR all values for a user, pass `$null` as the value for this parameter.

    .PARAMETER IncludeInGlobalAddressList
    Indicates if the user's profile is visible in the G Suite global address list when the contact sharing feature is enabled for the domain. For more information about excluding user profiles, see the administration help center: http://support.google.com/a/bin/answer.py?answer=1285988

    .PARAMETER IpWhitelisted
    If true, the user's IP address is white listed: http://support.google.com/a/bin/answer.py?answer=60752

    .PARAMETER IsAdmin
    If true, the user will be made a SuperAdmin. If $false, the user will have SuperAdmin privileges revoked.

    Requires confirmation.

    .PARAMETER CustomSchemas
    Custom user attribute values to add to the user's account. This parameter only accepts a hashtable where the keys are Schema Names and the value for each key is another hashtable, i.e.:

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

    The Custom Schema and it's fields **MUST** exist prior to updating these values for a user otherwise it will return an error.

    .EXAMPLE
    Update-GSUser -User john.smith@domain.com -PrimaryEmail johnathan.smith@domain.com -GivenName Johnathan -Suspended:$false

    Updates user john.smith@domain.com with a new primary email of "johnathan.smith@domain.com", sets their Given Name to "Johnathan" and unsuspends them. Their previous primary email "john.smith@domain.com" will become an alias on their account automatically
    #>
    [OutputType('Google.Apis.Admin.Directory.directory_v1.Data.User')]
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    Param
    (
        [parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
        [Alias("Id", "UserKey", "Mail")]
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
        [Google.Apis.Admin.Directory.directory_v1.Data.UserEmail[]]
        $Emails,
        [parameter(Mandatory = $false)]
        [Google.Apis.Admin.Directory.directory_v1.Data.UserExternalId[]]
        $ExternalIds,
        [parameter(Mandatory = $false)]
        [Google.Apis.Admin.Directory.directory_v1.Data.UserIm[]]
        $Ims,
        [parameter(Mandatory = $false)]
        [Google.Apis.Admin.Directory.directory_v1.Data.UserLocation[]]
        $Locations,
        [parameter(Mandatory = $false)]
        [Google.Apis.Admin.Directory.directory_v1.Data.UserOrganization[]]
        $Organizations,
        [parameter(Mandatory = $false)]
        [Google.Apis.Admin.Directory.directory_v1.Data.UserRelation[]]
        $Relations,
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
        [Switch]
        $IsAdmin,
        [parameter(Mandatory = $false)]
        [ValidateScript( {
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
        foreach ($U in $User) {
            try {
                if ($U -ceq 'me') {
                    $U = $Script:PSGSuite.AdminEmail
                }
                elseif ($U -notlike "*@*.*") {
                    $U = "$($U)@$($Script:PSGSuite.Domain)"
                }
                if ($PSCmdlet.ShouldProcess("Updating user '$U'")) {
                    Write-Verbose "Updating user '$U'"
                    $userObj = Get-GSUser $U -Verbose:$false
                    $body = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.User'
                    $name = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.UserName'
                    $nameUpdated = $false
                    $toClear = @{ }
                    foreach ($prop in $PSBoundParameters.Keys | Where-Object { $body.PSObject.Properties.Name -contains $_ -or $name.PSObject.Properties.Name -contains $_ }) {
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
                                $body.Password = (New-Object PSCredential "user", $Password).GetNetworkCredential().Password
                            }
                            CustomSchemas {
                                $schemaDict = New-Object 'System.Collections.Generic.Dictionary`2[[System.String],[System.Collections.Generic.IDictionary`2[[System.String],[System.Object]]]]'
                                foreach ($schemaName in $CustomSchemas.Keys) {
                                    $fieldDict = New-Object 'System.Collections.Generic.Dictionary`2[[System.String],[System.Object]]'
                                    $schemaFields = $CustomSchemas[$schemaName]
                                    $schemaFields.Keys | ForEach-Object {
                                        $fieldDict.Add($_, $schemaFields[$_])
                                    }
                                    $schemaDict.Add($schemaName, $fieldDict)
                                }
                                $body.CustomSchemas = $schemaDict
                            }
                            Emails {
                                $emailList = New-Object 'System.Collections.Generic.List`1[Google.Apis.Admin.Directory.directory_v1.Data.UserEmail]'
                                foreach ($email in $Emails) {
                                    $emailList.Add($email)
                                }
                                $body.Emails = $emailList
                            }
                            ExternalIds {
                                if ($null -ne $ExternalIds) {
                                    $extIdList = New-Object 'System.Collections.Generic.List`1[Google.Apis.Admin.Directory.directory_v1.Data.UserExternalId]'
                                    foreach ($extId in $ExternalIds) {
                                        $extIdList.Add($extId)
                                    }
                                    $body.ExternalIds = $extIdList
                                }
                                else {
                                    $toClear['externalIds'] = $null
                                }
                            }
                            Ims {
                                if ($null -ne $Ims) {
                                    $imList = New-Object 'System.Collections.Generic.List`1[Google.Apis.Admin.Directory.directory_v1.Data.UserIm]'
                                    foreach ($im in $Ims) {
                                        $imList.Add($im)
                                    }
                                    $body.Ims = $imList
                                }
                                else {
                                    $toClear['ims'] = $null
                                }
                            }
                            Locations {
                                if ($null -ne $Locations) {
                                    $locationList = New-Object 'System.Collections.Generic.List`1[Google.Apis.Admin.Directory.directory_v1.Data.UserLocation]'
                                    foreach ($loc in $Locations) {
                                        $locationList.Add($loc)
                                    }
                                    $body.Locations = $locationList
                                }
                                else {
                                    $toClear['locations'] = $null
                                }
                            }
                            Organizations {
                                if ($null -ne $Organizations) {
                                    $orgList = New-Object 'System.Collections.Generic.List`1[Google.Apis.Admin.Directory.directory_v1.Data.UserOrganization]'
                                    foreach ($organization in $Organizations) {
                                        $orgList.Add($organization)
                                    }
                                    $body.Organizations = $orgList
                                }
                                else {
                                    $toClear['organizations'] = $null
                                }
                            }
                            Relations {
                                if ($null -ne $Relations) {
                                    $relList = New-Object 'System.Collections.Generic.List`1[Google.Apis.Admin.Directory.directory_v1.Data.UserRelation]'
                                    foreach ($relation in $Relations) {
                                        $relList.Add($relation)
                                    }
                                    $body.Relations = $relList
                                }
                                else {
                                    $toClear['relations'] = $null
                                }
                            }
                            Phones {
                                if ($null -ne $Phones) {
                                    $phoneList = New-Object 'System.Collections.Generic.List`1[Google.Apis.Admin.Directory.directory_v1.Data.UserPhone]'
                                    foreach ($phone in $Phones) {
                                        $phoneList.Add($phone)
                                    }
                                    $body.Phones = $phoneList
                                }
                                else {
                                    $toClear['phones'] = $null
                                }
                            }
                            IsAdmin {
                                if ($userObj.IsAdmin -eq $PSBoundParameters[$prop]) {
                                    Write-Verbose "User '$U' already has IsAdmin set to '$($userObj.IsAdmin)'"
                                }
                                else {
                                    if ($PSCmdlet.ShouldProcess("Updating user '$U' to IsAdmin '$($PSBoundParameters[$prop])'")) {
                                        Write-Verbose "Updating user '$U' to IsAdmin '$($PSBoundParameters[$prop])'"
                                        $adminBody = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.UserMakeAdmin' -Property @{
                                            Status = $PSBoundParameters[$prop]
                                        }
                                        $request = $service.Users.MakeAdmin($adminBody, $userObj.Id)
                                        $request.Execute()
                                    }
                                }
                            }
                            Default {
                                $body.$prop = $PSBoundParameters[$prop]
                            }
                        }
                    }
                    if ($nameUpdated) {
                        $body.Name = $name
                    }
                    $request = $service.Users.Update($body, $userObj.Id)
                    $request.Execute() | Add-Member -MemberType NoteProperty -Name 'User' -Value $U -PassThru
                    if ($toClear.Keys.Count) {
                        $header = @{
                            Authorization = "Bearer $(Get-GSToken -Scopes "https://www.googleapis.com/auth/admin.directory.user" -Verbose:$false)"
                        }
                        $uri = [Uri]"https://www.googleapis.com/admin/directory/v1/users/$U"
                        Write-Verbose "Clearing out all values for User '$U' on the following properties: [ $($toClear.Keys -join ", ") ]"
                        $null = Invoke-RestMethod -Method Put -Uri $uri -Headers $header -Body $($toClear | ConvertTo-Json -Depth 5 -Compress) -ContentType 'application/json' -Verbose:$false -ErrorAction Stop
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
}
