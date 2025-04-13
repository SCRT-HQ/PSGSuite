# User Management

This section goes into detail on how to manage users, licenses and custom schemas using this module.

## Getting User Info

### Get-GSUser

This function pulls info for a specific user, including orgUnitPath, aliases, custom schema values, etc.

* Scope(s) required:
    * <https://www.googleapis.com/auth/admin.directory.user>
        * <https://www.googleapis.com/auth/admin.directory.user.readonly>
* Mandatory parameters:
    * User (must be the primary email address of an existing user in the domain)

#### Get-GSUser Syntax

```powershell
Get-GSUser [-User] <string> [-Projection {Basic | Custom | Full}] [-CustomFieldMask <string>] [-ViewType {Admin_View | Domain_Public}] [-Fields <string[]>] [-AccessToken <string>] [-P12KeyPath <string>] [-AppEmail <string>] [-AdminEmail <string>]  [<CommonParameters>]
```

#### Get-GSUser Examples

=== "Get all users"

    ```powershell {linenums="1"}
    Get-GSUser -Filter *
    ```

=== "Get full details for a user"

    ```powershell {linenums="1"}
    $params = @{
        User = 'john.smith@domain.com'
        Projection = 'Full'
        ViewType = 'Admin_View'
    }

    Get-GSUser @params
    ```

=== "Get basic details for a user"

    ```powershell {linenums="1"}
    Get-GSUser john.smith@domain.com
    ```

## Getting User Photos

To get a user's photo, use the `Get-GSUserPhoto` function:

### Get-GSUserPhoto

* Scope(s) required:
    * <https://www.googleapis.com/auth/admin.directory.user>
        * <https://www.googleapis.com/auth/admin.directory.user.readonly>
* Mandatory parameters:
    * User (must be the primary email address of an existing user in the domain)

#### Get-GSUserPhoto Syntax

```powershell
Get-GSUserPhoto [-User] <string> [-AccessToken <string>] [-P12KeyPath <string>] [-AppEmail <string>] [-AdminEmail <string>]  [<CommonParameters>]
```

#### Get-GSUserPhoto Examples

=== "Get a user's photo"

    ```powershell {linenums="1"}
    Get-GSUserPhoto john.smith@domain.com
    ```

## Listing Users

To list all users in the domain or in a specific organizational unit, use the `Get-GSUserList` function:

### Get-GSUserList

* Scope(s) required:
    * <https://www.googleapis.com/auth/admin.directory.user>
        * <https://www.googleapis.com/auth/admin.directory.user.readonly>
* Mandatory parameters:
    * None

#### Get-GSUserList Syntax

```powershell
Get-GSUserList [[-Query] <String[]>] [[-PageSize] <Int32>] [[-OrderBy] <String>] [[-SortOrder] <String>] [[-AccessToken] <String>] [[-P12KeyPath] <String>] [[-AppEmail] <String>] [[-AdminEmail] <String>] [[-CustomerID] <String>] [[-Domain] <String>] [[-Preference] <String>] [<CommonParameters>]
```

#### Get-GSUserList Examples

=== "Get all users in the domain"

    ```powershell {linenums="1"}
    Get-GSUserList
    ```

=== "Get all users in an OU"

    ```powershell {linenums="1"}
    Get-GSUserList -Query "orgUnitPath='/Users/New Hires'"
    ```

=== "Get a specific user in a specific OU"

    ```powershell {linenums="1"}
    Get-GSUserList -MaxResults 300 -Query "orgUnitPath='/Users'","email=john.smith@domain.com"
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

#### New-GSUser Syntax

```powershell {linenums="1"}
New-GSUser [-PrimaryEmail] <String> [-GivenName] <String> [-FamilyName] <String> [-Password] <String> [[-ChangePasswordAtNextLogin] <String>] [[-OrgUnitPath] <String>] [[-Suspended] <String>] [[-IncludeInGlobalAddressList] <String>] [[-IPWhitelisted] <String>] [[-AccessToken] <String>] [[-P12KeyPath] <String>] [[-AppEmail] <String>] [[-AdminEmail] <String>] [<CommonParameters>]
```

#### New-GSUser Examples

=== "Create a new user in the root OU"

    ```powershell {linenums="1"}
    New-GSUser -PrimaryEmail john.smith@domain.com -GivenName John -FamilyName Smith -Password Password123
    ```

=== "Create a new user in a specific OU"

    ```powershell {linenums="1"}
    New-GSUser -PrimaryEmail john.smith@domain.com -GivenName John -FamilyName Smith -Password Password123 -ChangePasswordAtNextLogin True -OrgUnitPath "/Users/New Hires" -IncludeInGlobalAddressList True
    ```

## Updating Users

To update existing users, use the `Update-GSUser` function:

### Update-GSUser

* Scope(s) required:
    * <https://www.googleapis.com/auth/admin.directory.user>
* Mandatory parameters:
    * User (must be the primary email address of an existing user in the domain)

#### Update-GSUser Syntax

```powershell
Update-GSUser [-User] <String> [[-PrimaryEmail] <String>] [[-GivenName] <String>] [[-FamilyName] <String>] [[-Password] <String>] [[-ChangePasswordAtNextLogin] <String>] [[-OrgUnitPath] <String>] [[-Suspended] <String>] [[-IncludeInGlobalAddressList] <String>] [[-IPWhitelisted] <String>] [[-AccessToken] <String>] [[-P12KeyPath] <String>] [[-AppEmail] <String>] [[-AdminEmail] <String>] [<CommonParameters>]
```

#### Update-GSUser Examples

=== "Update a user's email address and name"

```powershell {linenums="1"}
Update-GSUser -User john.smith@domain.com -PrimaryEmail johnathan.smith@domain.com -GivenName Johnathan -Suspended False
```

## Removing Users

To remove users, use the `Remove-GSUser` function:

### Remove-GSUser

* Scope(s) required:
    * <https://www.googleapis.com/auth/admin.directory.user>
* Mandatory parameters:
    * User (must be the primary email address of an existing user in the domain)

#### Remove-GSUser Syntax

```powershell {linenums="1"}
Remove-GSUser [-User] <String> [[-AccessToken] <String>] [[-P12KeyPath] <String>] [[-AppEmail] <String>] [[-AdminEmail] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

#### Remove-GSUser Examples

=== "Attempt to remove a user"

```powershell {linenums="1"}
Remove-GSUser -User john.smith@domain.com -WhatIf
```

=== "Remove a user"

```powershell {linenums="1"}
Remove-GSUser -User john.smith@domain.com -Confirm:$false
```

## Restoring Users

To restore users, use the `Restore-GSUser` function:

### Restore-GSUser

* Scope(s) required:
    * <https://www.googleapis.com/auth/admin.directory.user>
* Mandatory parameters:
    * User (must be the primary email address of an existing user in the domain)
        * OrgUnitPath (the Org Unit path to restore the user to)

#### Restore-GSUser Syntax

```powershell
Restore-GSUser [-User] <String> [-OrgUnitPath] <String> [-AccessToken <String>] [-P12KeyPath <String>] [-AppEmail <String>] [-AdminEmail <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

#### Restore-GSUser Examples

=== "Attempt to restore a user"

```powershell {linenums="1"}
Restore-GSUser -User john.smith@domain.com -OrgUnitPath "/Users" -WhatIf
```

=== "Restore a user"

```powershell {linenums="1"}
Restore-GSUser -User john.smith@domain.com -OrgUnitPath "/Users" -Confirm:$false
```
