# Set-PSGSuiteConfig

## SYNOPSIS
Creates or updates a config

## SYNTAX

```
Set-PSGSuiteConfig [[-ConfigName] <String>] [[-P12KeyPath] <String>] [[-P12Key] <Byte[]>]
 [[-ClientSecretsPath] <String>] [[-ClientSecrets] <String>] [[-AppEmail] <String>] [[-AdminEmail] <String>]
 [[-CustomerID] <String>] [[-Domain] <String>] [[-Preference] <String>] [[-ServiceAccountClientID] <String>]
 [[-Webhook] <Hashtable[]>] [[-Space] <Hashtable[]>] [[-Scope] <String>] [-SetAsDefaultConfig] [-NoImport]
 [<CommonParameters>]
```

## DESCRIPTION
Creates or updates a config

## EXAMPLES

### EXAMPLE 1
```
Set-PSGSuiteConfig -ConfigName "personal" -P12KeyPath C:\Keys\PersonalKey.p12 -AppEmail "myProjectName@myProject.iam.gserviceaccount.com" -AdminEmail "admin@domain.com" -CustomerID "C83030001" -Domain "domain.com" -Preference CustomerID -ServiceAccountClientID 1175798883298324983498 -SetAsDefaultConfig
```

This builds a config names "personal" and sets it as the default config

## PARAMETERS

### -AdminEmail
The email of the Google Admin running the functions.
This will typically be your email.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -AppEmail
The application email from the Google Developer's Console.
This typically looks like the following:

myProjectName@myProject.iam.gserviceaccount.com

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ClientSecrets
The string contents of the Client Secrets JSON file downloaded from the Google Developer's Console.
Using the ClientSecrets JSON will prompt the user to complete OAuth2 authentication in their browser on the first run and store the retrieved Refresh and Access tokens in the user's home directory.
If P12KeyPath is also specified, ClientSecrets will be ignored.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ClientSecretsPath
The path to the Client Secrets JSON file downloaded from the Google Developer's Console.
Using the ClientSecrets JSON will prompt the user to complete OAuth2 authentication in their browser on the first run and store the retrieved Refresh and Access tokens in the user's home directory.
The config will auto-update with this value after running any command, if ClientSecretsPath is filled and this value is not already present.
If P12KeyPath is also specified, ClientSecretsPath will be ignored.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ConfigName
The friendly name for the config you are creating or updating

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $Script:ConfigName
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -CustomerID
The Customer ID for your customer.
If unknown, you can retrieve it by running Get-GSUser after creating a base config with at least either the P12KeyPath or ClientSecretsPath, the AppEmail and the AdminEmail.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Domain
The domain that you primarily manage for this CustomerID

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -NoImport
The default behavior when using Set-PSGSuiteConfig is that the new/updated config is imported as active.
If -NoImport is passed, this saves the config but retains the previously loaded config as active.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -P12Key
The P12Key in byte array format.
If the actual P12Key is present on the config, the P12KeyPath is not needed.
The config will auto-update with this value after running any command, if P12KeyPath is filled and this value is not already present.

```yaml
Type: Byte[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -P12KeyPath
The path to the P12 Key file downloaded from the Google Developer's Console.
If both P12KeyPath and ClientSecretsPath are specified, P12KeyPath takes precedence.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Preference
Some functions allow you to specify whether you are running in the context of the customer or a specific domain in the customer's realm.
This allows you to set your preference.

Available values are:
* CustomerID
* Domain

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Scope
The scope at which you would like to set this config.

Available values are:
* Machine (this would create the config in a location accessible by all users on the machine)
* Enterprise (this would create the config in the Roaming AppData folder for the user or it's *nix equivalent)
* User (this would create the config in the Local AppData folder for the user or it's *nix equivalent)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 14
Default value: $script:ConfigScope
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServiceAccountClientID
The Service Account's Client ID from the Google Developer's Console.
This is optional and is only used as a reference for yourself to prevent needing to check the Developer's Console for the ID when verifying API Client Access.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SetAsDefaultConfig
If passed, sets the ConfigName as the default config to load on module import

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Space
Chat spaces to add to the config.

```yaml
Type: Hashtable[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Webhook
Chat Webhooks to add to the config.

```yaml
Type: Hashtable[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
