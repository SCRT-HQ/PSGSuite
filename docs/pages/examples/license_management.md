# License Management

## Getting License Info

To get license info, use the `Get-GSUserLicense` function:

### Get-GSUserLicense

* Scope(s) required:
    * <https://www.googleapis.com/auth/admin.directory.user>
* Mandatory parameters:
    * User (must be the primary email address of an existing user in the domain)

#### Get-GSUserLicense Syntax

```powershell
Get-GSUserLicense [-License <string>] [-ProductID <string[]>] [-PageSize <int>] [-Limit <int>] [<CommonParameters>]
```

```powershell
Get-GSUserLicense [[-User] <string[]>] [-License <string>] [<CommonParameters>]
```

#### Get-GSUserLicense Examples

=== "Get all licenses in the domain"

    ```powershell {linenums="1"}
    Get-GSUserLicense
    ```

=== "Get a user's license info"

    ```powershell {linenums="1"}
    Get-GSUserLicense -User john.smith@domain.com
    ```

=== "Get a user's license info for a specific product"

    ```powershell {linenums="1"}
    Get-GSUserLicense -User john.smith@domain.com -License Google-Vault-Former-Employee
    ```

## Removing Licenses

To remove licenses, use the `Remove-GSUserLicense` function:

### Remove-GSUserLicense

* Scope(s) required:
    * <https://www.googleapis.com/auth/admin.directory.user>
* Mandatory parameters:
    * User (must be the primary email address of an existing user in the domain)

#### Remove-GSUserLicense Syntax

```powershell
Remove-GSUserLicense [-User] <string[]> [-License] <string> [-WhatIf] [-Confirm] [<CommonParameters>]
```

#### Remove-GSUserLicense Examples

=== "Remove a user's license"

    ```powershell {linenums="1"}
    Remove-GSUserLicense
    ```

## Setting Licenses

To set licenses, use the `Set-GSUserLicense` function:

### Set-GSUserLicense

* Scope(s) required:
    * <https://www.googleapis.com/auth/admin.directory.user>
* Mandatory parameters:
    * User (must be the primary email address of an existing user in the domain)

#### Set-GSUserLicense Syntax

```powershell
Set-GSUserLicense [-User] <string[]> [-License] <string> [<CommonParameters>]
```

#### Set-GSUserLicense Examples

=== "Set a user's license"
    ```powershell {linenums="1"}
    Set-GSUserLicense -User joe.smith@domain.com -License Google-Vault-Former-Employee
    ```

## Updating Licenses

To update licenses, use the `Update-GSUserLicense` function:

### Update-GSUserLicense

* Scope(s) required:
    * <https://www.googleapis.com/auth/admin.directory.user>
* Mandatory parameters:
    * User (must be the primary email address of an existing user in the domain)

#### Update-GSUserLicense Syntax

```powershell
Update-GSUserLicense [[-User] <string[]>] [-License <string>] [<CommonParameters>]
```

#### Update-GSUserLicense Examples

=== "Update a user's license"

```powershell {linenums="1"}
Update-GSUserLicense -User joe.smith@domain.com -License Google-Vault-Former-Employee
```
