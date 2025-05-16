# Get-GSChatConfig

## SYNOPSIS
Returns the specified Chat space and webhook dictionaries from the PSGSuite config to use with Send-GSChatMessage

## SYNTAX

### Webhooks (Default)
```
Get-GSChatConfig [[-WebhookName] <String[]>] [[-ConfigName] <String[]>] [<CommonParameters>]
```

### Spaces
```
Get-GSChatConfig [[-SpaceName] <String[]>] [[-ConfigName] <String[]>] [<CommonParameters>]
```

## DESCRIPTION
Returns the specified Chat space and webhook dictionaries from the PSGSuite config to use with Send-GSChatMessage

## EXAMPLES

### EXAMPLE 1
```
Send-GSChatMessage -Text "Testing webhook" -Webhook (Get-GSChatConfig MyRoom)
```

Sends a Chat message with text to the Webhook Url named 'MyRoom' found in the config

## PARAMETERS

### -ConfigName
The name of the Config to return the Chat config items from

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SpaceName
The key that the Space ID is stored as in the Config.
If left blank, returns the full Chat configuration from the Config

```yaml
Type: String[]
Parameter Sets: Spaces
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WebhookName
The key that the Webhook Url is stored as in the Config.
If left blank, returns the full Chat configuration from the Config

```yaml
Type: String[]
Parameter Sets: Webhooks
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
