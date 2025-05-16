# Custom Schemas Management

## Getting Custom Schema Info

To get info about a specific custom schema, use the `Get-GSUserSchema` function:

### Get-GSUserSchema

* Scope(s) required:
    * <https://www.googleapis.com/auth/admin.directory.user>

#### Get-GSUserSchema Syntax

```powershell
Get-GSUserSchema [[-SchemaId] <string[]>] [<CommonParameters>]
```

#### Get-GSUserSchema Examples

=== "Get all custom schemas"

    ```powershell {linenums="1"}
    Get-GSUserSchema
    ```

=== "Get a specific custom schema"

    ```powershell {linenums="1"}
    Get-GSUserSchema -SchemaId $schemaId
    ```

## Creating Custom Schemas

To create custom schemas, use the `New-GSUserSchema` function:

### New-GSUserSchema

* Scope(s) required:
    * <https://www.googleapis.com/auth/admin.directory.user>

#### New-GSUserSchema Syntax

```powershell
New-GSUserSchema [-SchemaName] <string> [-Fields] <SchemaFieldSpec[]> [<CommonParameters>]
```

#### New-GSUserSchema Examples

=== "Create a new custom schema"

    ```powershell {linenums="1"}
    New-GSUserSchema
    ```

## Removing Custom Schemas

To remove custom schemas, use the `Remove-GSUserSchema` function:

### Remove-GSUserSchema

* Scope(s) required:
    * <https://www.googleapis.com/auth/admin.directory.user>

#### Remove-GSUserSchema Syntax

```powershell
Remove-GSUserSchema [[-SchemaId] <string[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

#### Remove-GSUserSchema Examples

=== "Remove a specific custom schema"

    ```powershell {linenums="1"}
    Remove-GSUserSchema
    ```

## Updating Custom Schemas

To update custom schemas, use the `Update-GSUserSchema` function:

### Update-GSUserSchema

* Scope(s) required:
    * <https://www.googleapis.com/auth/admin.directory.user>

#### Update-GSUserSchema Syntax

```powershell
Update-GSUserSchema [-SchemaId] <string> [-SchemaName <string>] [-Fields <SchemaFieldSpec[]>] [<CommonParameters>]
```

#### Update-GSUserSchema Example

=== "Update a specific custom schema"

    ```powershell {linenums="1"}
    Update-GSUserSchema -SchemaId $schemaId
    ```
