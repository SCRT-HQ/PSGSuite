# Managing Users

This section goes into detail on how to manage users, licenses and custom schemas using this module.

## Getting User Info

### Get-GSUser

_This function pulls info for a specific user, including orgUnitPath, aliases, custom schema values, etc._

* Scope(s) required:
    * <https://www.googleapis.com/auth/admin.directory.user>
        * <https://www.googleapis.com/auth/admin.directory.user.readonly>
* Mandatory parameters:
    * User (must be the primary email address of an existing user in the domain)

#### Examples

```PowerShell tab="Get All Users"
Get-GSUser -Filter *
```

```PowerShell tab=
Get-GSUser -User john.smith@domain.com -Projection Full -ViewType Admin_View
```

```PowerShell tab=
Get-GSUser john.smith@domain.com
```

#### Syntax

```PowerShell tab=
Get-GSUser [-User] <string> [-Projection {Basic | Custom | Full}] [-CustomFieldMask <string>] [-ViewType {Admin_View | Domain_Public}] [-Fields <string[]>] [-AccessToken <string>] [-P12KeyPath <string>] [-AppEmail <string>] [-AdminEmail <string>]  [<CommonParameters>]
```

## Getting User Photos

To get a user's photo, use the `Get-GSUserPhoto` function:

### Get-GSUserPhoto

* Scope(s) required:
    * <https://www.googleapis.com/auth/admin.directory.user>
        * <https://www.googleapis.com/auth/admin.directory.user.readonly>
* Mandatory parameters:
    * User (must be the primary email address of an existing user in the domain)

#### Examples

```PowerShell tab=
Get-GSUserPhoto john.smith@domain.com
```

#### Syntax

```PowerShell tab=
Get-GSUserPhoto [-User] <string> [-AccessToken <string>] [-P12KeyPath <string>] [-AppEmail <string>] [-AdminEmail <string>]  [<CommonParameters>]
```

## Listing Users

To list all users in the domain or in a specific organizational unit, use the `Get-GSUserList` function:

### Get-GSUserList

* Scope(s) required:
    * <https://www.googleapis.com/auth/admin.directory.user>
        * <https://www.googleapis.com/auth/admin.directory.user.readonly>
* Mandatory parameters:
    * _None_

#### Examples

```PowerShell tab=
Get-GSUserList
```

```PowerShell tab=
Get-GSUserList -Query "orgUnitPath='/Users/New Hires'"
```

```PowerShell tab=
Get-GSUserList -MaxResults 300 -Query "orgUnitPath='/Users'","email=john.smith@domain.com"
```

#### Syntax

```PowerShell tab=
Get-GSUserList [[-Query] <String[]>] [[-PageSize] <Int32>] [[-OrderBy] <String>] [[-SortOrder] <String>] [[-AccessToken] <String>] [[-P12KeyPath] <String>] [[-AppEmail] <String>] [[-AdminEmail] <String>] [[-CustomerID] <String>] [[-Domain] <String>] [[-Preference] <String>] [<CommonParameters>]
```

## Creating Users

To create new users, use the `New-GSUser` function:

### New-GSUser

* Scope(s) required:
    * <https://www.googleapis.com/auth/admin.directory.user>
* Mandatory parameters:
    * PrimaryEmail (user's primary email, must be unique to the domain)
    * GivenName (user's first name)
    * FamilyName (user's last name)
    * Password (user's initial password)

#### Examples

```PowerShell tab=
New-GSUser -PrimaryEmail john.smith@domain.com -GivenName John -FamilyName Smith -Password Password123
```

```PowerShell tab=
New-GSUser -PrimaryEmail john.smith@domain.com -GivenName John -FamilyName Smith -Password Password123 -ChangePasswordAtNextLogin True -OrgUnitPath "/Users/New Hires" -IncludeInGlobalAddressList True
```

#### Syntax

```PowerShell tab=
New-GSUser [-PrimaryEmail] <String> [-GivenName] <String> [-FamilyName] <String> [-Password] <String> [[-ChangePasswordAtNextLogin] <String>] [[-OrgUnitPath] <String>] [[-Suspended] <String>] [[-IncludeInGlobalAddressList] <String>] [[-IPWhitelisted] <String>] [[-AccessToken] <String>] [[-P12KeyPath] <String>] [[-AppEmail] <String>] [[-AdminEmail] <String>] [<CommonParameters>]
```

## Updating Users

To update existing users, use the `Update-GSUser` function:

### Update-GSUser

* Scope(s) required:
    * <https://www.googleapis.com/auth/admin.directory.user>
* Mandatory parameters:
    * User (must be the primary email address of an existing user in the domain)

#### Examples

```PowerShell tab=
Update-GSUser -User john.smith@domain.com -PrimaryEmail johnathan.smith@domain.com -GivenName Johnathan -Suspended False
```

#### Syntax

```PowerShell tab=
Update-GSUser [-User] <String> [[-PrimaryEmail] <String>] [[-GivenName] <String>] [[-FamilyName] <String>] [[-Password] <String>] [[-ChangePasswordAtNextLogin] <String>] [[-OrgUnitPath] <String>] [[-Suspended] <String>] [[-IncludeInGlobalAddressList] <String>] [[-IPWhitelisted] <String>] [[-AccessToken] <String>] [[-P12KeyPath] <String>] [[-AppEmail] <String>] [[-AdminEmail] <String>] [<CommonParameters>]
```

## Removing Users

To remove users, use the `Remove-GSUser` function:

### Remove-GSUser

* Scope(s) required:
    * <https://www.googleapis.com/auth/admin.directory.user>
* Mandatory parameters:
    * User (must be the primary email address of an existing user in the domain)

#### Examples

```PowerShell tab=
Remove-GSUser -User john.smith@domain.com -WhatIf
```

```PowerShell tab=
Remove-GSUser -User john.smith@domain.com -Confirm:$false
```

#### Syntax

```PowerShell tab=
Remove-GSUser [-User] <String> [[-AccessToken] <String>] [[-P12KeyPath] <String>] [[-AppEmail] <String>] [[-AdminEmail] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## Restoring Users

To undelete users, use the `Restore-GSUser` function:

### Restore-GSUser

* Scope(s) required:
    * <https://www.googleapis.com/auth/admin.directory.user>
* Mandatory parameters:
    * User (must be the primary email address of an existing user in the domain)
        * OrgUnitPath (the Org Unit path to restore the user to)

#### Examples

```PowerShell tab=
Restore-GSUser -User john.smith@domain.com -OrgUnitPath "/Users" -WhatIf
```

```PowerShell tab=
Restore-GSUser -User john.smith@domain.com -OrgUnitPath "/Users" -Confirm:$false
```

#### Syntax

```PowerShell tab=
Restore-GSUser [-User] <String> [-OrgUnitPath] <String> [-AccessToken <String>] [-P12KeyPath <String>] [-AppEmail <String>] [-AdminEmail <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

***

## Getting License Info

To get license info, use the `Get-GSUserLicense` function:

### Get-GSUserLicense

* Scope(s) required:
    * <https://www.googleapis.com/auth/admin.directory.user>
* Mandatory parameters:
    * User (must be the primary email address of an existing user in the domain)

#### Examples

```PowerShell tab=
Get-GSUserLicense -User john.smith@domain.com
```

```PowerShell tab=
Get-GSUserLicense -User john.smith@domain.com -License Google-Vault-Former-Employee
```

#### Syntax

```PowerShell tab=
Get-GSUserLicense [-License <string>] [-ProductID <string[]>] [-PageSize <int>] [-Limit <int>] [<CommonParameters>]

Get-GSUserLicense [[-User] <string[]>] [-License <string>] [<CommonParameters>]
```

#### Listing All Licenses

To list all licenses in the domain, use the `Get-GSUserLicense` function with no additional parameters

## Removing Licenses

To remove licenses, use the `Remove-GSUserLicense` function:

### Remove-GSUserLicense

* Scope(s) required:
    * <https://www.googleapis.com/auth/admin.directory.user>
* Mandatory parameters:
    * User (must be the primary email address of an existing user in the domain)

#### Examples

```PowerShell tab=
Remove-GSUserLicense
```

#### Syntax

```PowerShell tab=
Remove-GSUserLicense [-User] <string[]> [-License] <string> [-WhatIf] [-Confirm] [<CommonParameters>]
```


## Setting Licenses

To set licenses, use the `Set-GSUserLicense` function:

### Set-GSUserLicense

* Scope(s) required:
    * <https://www.googleapis.com/auth/admin.directory.user>
* Mandatory parameters:
    * User (must be the primary email address of an existing user in the domain)

#### Examples

```PowerShell tab=
Set-GSUserLicense -User joe.smith@domain.com -License Google-Vault-Former-Employee
```

#### Syntax

```PowerShell tab=

Set-GSUserLicense [-User] <string[]> [-License] <string> [<CommonParameters>]

```

## Updating Licenses

To update licenses, use the `Update-GSUserLicense` function:

### Update-GSUserLicense

* Scope(s) required:
    * <https://www.googleapis.com/auth/admin.directory.user>
* Mandatory parameters:
    * User (must be the primary email address of an existing user in the domain)

#### Examples

```PowerShell tab=
Update-GSUserLicense -User joe.smith@domain.com -License Google-Vault-Former-Employee
```

#### Syntax

```PowerShell tab=
Update-GSUserLicense [[-User] <string[]>] [-License <string>] [<CommonParameters>]
```

***

## Getting Custom Schema Info

To get info about a specific custom schema, use the `Get-GSUserSchema` function:

### Get-GSUserSchema

* Scope(s) required:
    * <https://www.googleapis.com/auth/admin.directory.user>

#### Examples

```PowerShell tab=
Get-GSUserSchema -SchemaId $schemaId
```

#### Syntax

```PowerShell tab=
Get-GSUserSchema [[-SchemaId] <string[]>] [<CommonParameters>]
```

## Listing Custom Schemas

To list all custom schemas, use the `Get-GSUserSchema` function and do not specify a SchemaId:

#### Examples

```PowerShell tab=
Get-GSUserSchema
```

## Creating Custom Schemas

To create custom schemas, use the `New-GSUserSchema` function:

### New-GSUserSchema

* Scope(s) required:
    * <https://www.googleapis.com/auth/admin.directory.user>

#### Examples

```PowerShell tab=
New-GSUserSchema
```

#### Syntax

```PowerShell tab=
New-GSUserSchema [-SchemaName] <string> [-Fields] <SchemaFieldSpec[]> [<CommonParameters>]
```

## Removing Custom Schemas

To remove custom schemas, use the `Remove-GSUserSchema` function:

### Remove-GSUserSchema

* Scope(s) required:
    * <https://www.googleapis.com/auth/admin.directory.user>

#### Examples

```PowerShell tab=
Remove-GSUserSchema
```

#### Syntax

```PowerShell tab=
Remove-GSUserSchema [[-SchemaId] <string[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## Updating Custom Schemas

To update custom schemas, use the `Update-GSUserSchema` function:

### Update-GSUserSchema

* Scope(s) required:
    * <https://www.googleapis.com/auth/admin.directory.user>

#### Examples

```PowerShell tab=
Update-GSUserSchema
```

#### Syntax

```PowerShell tab=
Update-GSUserSchema [-SchemaId] <string> [-SchemaName <string>] [-Fields <SchemaFieldSpec[]>] [<CommonParameters>]
```
