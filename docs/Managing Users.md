# Managing Users
This section goes into detail on how to manage users, licenses and custom schemas using this module.

* [User Management](https://github.com/nferrell/PSGSuite/wiki/Managing-Users#user-management)
    * [Getting User Info](https://github.com/nferrell/PSGSuite/wiki/Managing-Users#getting-user-info)
    * [Getting User Photos](https://github.com/nferrell/PSGSuite/wiki/Managing-Users#getting-user-photos)
    * [Listing Users](https://github.com/nferrell/PSGSuite/wiki/Managing-Users#listing-users)
    * [Creating Users](https://github.com/nferrell/PSGSuite/wiki/Managing-Users#creating-users)
    * [Updating Users](https://github.com/nferrell/PSGSuite/wiki/Managing-Users#updating-users)
    * [Removing Users](https://github.com/nferrell/PSGSuite/wiki/Managing-Users#removing-users)
    * [Restoring Users](https://github.com/nferrell/PSGSuite/wiki/Managing-Users#restoring-users)
* [License Management](https://github.com/nferrell/PSGSuite/wiki/Managing-Users#license-management)
    * [Getting License Info](https://github.com/nferrell/PSGSuite/wiki/Managing-Users#getting-license-info)
    * [Listing Licenses](https://github.com/nferrell/PSGSuite/wiki/Managing-Users#listing-licenses)
    * [Removing Licenses](https://github.com/nferrell/PSGSuite/wiki/Managing-Users#removing-licenses)
    * [Setting Licenses](https://github.com/nferrell/PSGSuite/wiki/Managing-Users#setting-licenses)
    * [Updating Licenses](https://github.com/nferrell/PSGSuite/wiki/Managing-Users#updating-license)
* [Custom Schema Management](https://github.com/nferrell/PSGSuite/wiki/Managing-Users#custom-schema-management)
    * [Getting Custom Schema Info](https://github.com/nferrell/PSGSuite/wiki/Managing-Users#getting-custom-schema-info)
    * [Listing Custom Schemas](https://github.com/nferrell/PSGSuite/wiki/Managing-Users#listing-custom-schemas)
    * [Creating Custom Schemas](https://github.com/nferrell/PSGSuite/wiki/Managing-Users#creating-custom-schemas)
    * [Removing Schemas](https://github.com/nferrell/PSGSuite/wiki/Managing-Users#removing-schemas)
    * [Updating Schemas](https://github.com/nferrell/PSGSuite/wiki/Managing-Users#updating-schemas)

***


# User Management

## Getting User Info
### Get-GSUser
_This function pulls info for a specific user, including orgUnitPath, aliases, custom schema values, etc._
* Scope(s) required:
	* https://www.googleapis.com/auth/admin.directory.user
        * https://www.googleapis.com/auth/admin.directory.user.readonly
* Mandatory parameters:
	* User (must be the primary email address of an existing user in the domain)

_Examples_
* `Get-GSUser -User john.smith@domain.com -Projection Full -ViewType Admin_View`
* `Get-GSUser john.smith@domain.com`

_Syntax_
```
Get-GSUser [-User] <string> [-Projection {Basic | Custom | Full}] [-CustomFieldMask <string>] [-ViewType {Admin_View | Domain_Public}] [-Fields <string[]>] [-AccessToken <string>] [-P12KeyPath <string>] [-AppEmail <string>] [-AdminEmail <string>]  [<CommonParameters>]
```


## Getting User Photos
To get a user's photo, use the _Get-GSUserPhoto_ function:

### Get-GSUserPhoto
* Scope(s) required:
	* https://www.googleapis.com/auth/admin.directory.user
        * https://www.googleapis.com/auth/admin.directory.user.readonly
* Mandatory parameters:
	* User (must be the primary email address of an existing user in the domain)

_Examples_
* `Get-GSUserPhoto john.smith@domain.com`

_Syntax_
```
Get-GSUserPhoto [-User] <string> [-AccessToken <string>] [-P12KeyPath <string>] [-AppEmail <string>] [-AdminEmail <string>]  [<CommonParameters>]
```


## Listing Users
To list all users in the domain or in a specific organizational unit, use the _Get-GSUserList_ function:

### Get-GSUserList
* Scope(s) required:
	* https://www.googleapis.com/auth/admin.directory.user
        * https://www.googleapis.com/auth/admin.directory.user.readonly
* Mandatory parameters:
	* _None_

_Examples_
* `Get-GSUserList -Verbose`
* `Get-GSUserList -Query "orgUnitPath='/Users/New Hires'" -Verbose`
* `Get-GSUserList -MaxResults 300 -Query "orgUnitPath='/Users'","email=john.smith@domain.com" -Verbose`


_Syntax_
```
Get-GSUserList [[-Query] <String[]>] [[-PageSize] <Int32>] [[-OrderBy] <String>] [[-SortOrder] <String>] [[-AccessToken] <String>] [[-P12KeyPath] <String>] [[-AppEmail] <String>] [[-AdminEmail] <String>] [[-CustomerID] <String>] [[-Domain] <String>] [[-Preference] <String>] [<CommonParameters>]
```


## Creating Users
To create new users, use the _New-GSUser_ function:

### New-GSUser
* Scope(s) required:
	* https://www.googleapis.com/auth/admin.directory.user
* Mandatory parameters:
	* PrimaryEmail (user's primary email, must be unique to the domain)
	* GivenName (user's first name)
	* FamilyName (user's last name)
	* Password (user's initial password)

_Examples_
* `New-GSUser -PrimaryEmail john.smith@domain.com -GivenName John -FamilyName Smith -Password Password123`
* `New-GSUser -PrimaryEmail john.smith@domain.com -GivenName John -FamilyName Smith -Password Password123 -ChangePasswordAtNextLogin True -OrgUnitPath "/Users/New Hires" -IncludeInGlobalAddressList True`


_Syntax_
```
New-GSUser [-PrimaryEmail] <String> [-GivenName] <String> [-FamilyName] <String> [-Password] <String> [[-ChangePasswordAtNextLogin] <String>] [[-OrgUnitPath] <String>] [[-Suspended] <String>] [[-IncludeInGlobalAddressList] <String>] [[-IPWhitelisted] <String>] [[-AccessToken] <String>] [[-P12KeyPath] <String>] [[-AppEmail] <String>] [[-AdminEmail] <String>] [<CommonParameters>]
```


## Updating Users
To update existing users, use the _Update-GSUser_ function:

### Update-GSUser
* Scope(s) required:
	* https://www.googleapis.com/auth/admin.directory.user
* Mandatory parameters:
	* User (must be the primary email address of an existing user in the domain)

_Examples_
* `Update-GSUser -User john.smith@domain.com -PrimaryEmail johnathan.smith@domain.com -GivenName Johnathan -Suspended False`


_Syntax_
```
Update-GSUser [-User] <String> [[-PrimaryEmail] <String>] [[-GivenName] <String>] [[-FamilyName] <String>] [[-Password] <String>] [[-ChangePasswordAtNextLogin] <String>] [[-OrgUnitPath] <String>] [[-Suspended] <String>] [[-IncludeInGlobalAddressList] <String>] [[-IPWhitelisted] <String>] [[-AccessToken] <String>] [[-P12KeyPath] <String>] [[-AppEmail] <String>] [[-AdminEmail] <String>] [<CommonParameters>]
```


## Removing Users
To remove users, use the _Remove-GSUser_ function:

### Remove-GSUser
* Scope(s) required:
	* https://www.googleapis.com/auth/admin.directory.user
* Mandatory parameters:
	* User (must be the primary email address of an existing user in the domain)

_Examples_
* `Remove-GSUser -User john.smith@domain.com -WhatIf`
* `Remove-GSUser -User john.smith@domain.com -Confirm:$false`


_Syntax_
```
Remove-GSUser [-User] <String> [[-AccessToken] <String>] [[-P12KeyPath] <String>] [[-AppEmail] <String>] [[-AdminEmail] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```


## Restoring Users
To undelete users, use the _Restore-GSUser_ function:

### Restore-GSUser
* Scope(s) required:
	* https://www.googleapis.com/auth/admin.directory.user
* Mandatory parameters:
	* User (must be the primary email address of an existing user in the domain)
        * OrgUnitPath (the Org Unit path to restore the user to)

_Examples_
* `Restore-GSUser -User john.smith@domain.com -OrgUnitPath "/Users" -WhatIf`
* `Restore-GSUser -User john.smith@domain.com -OrgUnitPath "/Users" -Confirm:$false`


_Syntax_
```
Restore-GSUser [-User] <String> [-OrgUnitPath] <String> [-AccessToken <String>] [-P12KeyPath <String>] [-AppEmail <String>] [-AdminEmail <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```


***


# License Management

## Getting License Info
To get license info, use the _Get-GSLicenseInfo_ function:

### Get-GSLicenseInfo
* Scope(s) required:
	* https://www.googleapis.com/auth/admin.directory.user
* Mandatory parameters:
	* User (must be the primary email address of an existing user in the domain)
        * Either of the following:
            * CheckAllLicenseTypes (checks each license type and returns what's currently assigned to the user)
            * License <type> (checks for a specific license, returning that license info if so)

_Examples_
* `Get-GSLicenseInfo -User john.smith@domain.com -CheckAllLicenseTypes`
* `Get-GSLicenseInfo -User john.smith@domain.com -License Google-Vault-Former-Employee`

_Syntax_
```
Get-GSLicenseInfo -User <string> -CheckAllLicenseTypes [-AccessToken <string>] [-P12KeyPath <string>] [-AppEmail <string>] [-AdminEmail <string>]  [<CommonParameters>]

Get-GSLicenseInfo -User <string> -License {Google-Apps-Unlimited | Google-Apps-For-Business | Google-Apps-For-Postini | Google-Apps-Lite | Google-Drive-storage-20GB | Google-Drive-storage-50GB | Google-Drive-storage-200GB | Google-Drive-storage-400GB | Google-Drive-storage-1TB | Google-Drive-storage-2TB | Google-Drive-storage-4TB | Google-Drive-storage-8TB | Google-Drive-storage-16TB | Google-Vault | Google-Vault-Former-Employee} [-AccessToken <string>] [-P12KeyPath <string>] [-AppEmail <string>] [-AdminEmail <string>]  [<CommonParameters>]
```


## Listing Licenses
To list all licenses in the domain, use the _Get-GSLicenseList_ function:

### Get-GSLicenseList
* Scope(s) required:
	* https://www.googleapis.com/auth/admin.directory.user
* Mandatory parameters:
	* User (must be the primary email address of an existing user in the domain)

_Examples_
* `Get-GSLicenseList `

_Syntax_
```

```


## Removing Licenses
To remove licenses, use the _Remove-GSLicense_ function:

### Remove-GSLicense
* Scope(s) required:
	* https://www.googleapis.com/auth/admin.directory.user
* Mandatory parameters:
	* User (must be the primary email address of an existing user in the domain)

_Examples_
* `Remove-GSLicense `

_Syntax_
```

```


## Setting Licenses
To set licenses, use the _Set-GSLicense_ function:

### Set-GSLicense
* Scope(s) required:
	* https://www.googleapis.com/auth/admin.directory.user
* Mandatory parameters:
	* User (must be the primary email address of an existing user in the domain)

_Examples_
* `Set-GSLicense `

_Syntax_
```

```


## Updating Licenses
To update licenses, use the _Update-GSLicense_ function:

### Update-GSLicense
* Scope(s) required:
	* https://www.googleapis.com/auth/admin.directory.user
* Mandatory parameters:
	* User (must be the primary email address of an existing user in the domain)

_Examples_
* `Update-GSLicense `

_Syntax_
```

```


***


# Custom Schema Management

## Getting Custom Schema Info
To get info about a specific custom schema, use the _Get-GSUserSchemaInfo_ function:

### Get-GSUserSchemaInfo
* Scope(s) required:
	* https://www.googleapis.com/auth/admin.directory.user
* Mandatory parameters:
	* User (must)

_Examples_
* `Get-GSUserSchemaInfo `

_Syntax_
```

```


## Listing Custom Schemas
To list all custom schemas, use the _Get-GSUserSchemaList_ function:

### Get-GSUserSchemaList
* Scope(s) required:
	* https://www.googleapis.com/auth/admin.directory.user
* Mandatory parameters:
	* User (must)

_Examples_
* `Get-GSUserSchemaList `

_Syntax_
```

```


## Creating Custom Schemas
To create custom schemas, use the _New-GSUserSchema_ function:

### New-GSUserSchema
* Scope(s) required:
	* https://www.googleapis.com/auth/admin.directory.user
* Mandatory parameters:
	* User (must)

_Examples_
* `New-GSUserSchema `

_Syntax_
```

```


## Removing Custom Schemas
To remove custom schemas, use the _Remove-GSUserSchema_ function:

### Remove-GSUserSchema
* Scope(s) required:
	* https://www.googleapis.com/auth/admin.directory.user
* Mandatory parameters:
	* User (must)

_Examples_
* `Remove-GSUserSchema `

_Syntax_
```

```


## Updating Custom Schemas
To update custom schemas, use the _Update-GSUserSchema_ function:

### Update-GSUserSchema
* Scope(s) required:
	* https://www.googleapis.com/auth/admin.directory.user
* Mandatory parameters:
	* User (must)

_Examples_
* `Update-GSUserSchema `

_Syntax_
```

```
