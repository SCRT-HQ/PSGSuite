# Get-GSChatMember

## SYNOPSIS
Gets Chat member information

## SYNTAX

### List (Default)
```
Get-GSChatMember -Space <String[]> [<CommonParameters>]
```

### Get
```
Get-GSChatMember -Member <String[]> [<CommonParameters>]
```

## DESCRIPTION
Gets Chat member information

## EXAMPLES

### EXAMPLE 1
```
Get-GSChatMember -Space 'spaces/AAAAMpdlehY'
```

Gets the list of human members in the Chat space specified

## PARAMETERS

### -Member
Resource name of the membership to be retrieved, in the form "spaces/members".

Example: spaces/AAAAMpdlehY/members/105115627578887013105

```yaml
Type: String[]
Parameter Sets: Get
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Space
The resource name of the space for which membership list is to be fetched, in the form "spaces".

Example: spaces/AAAAMpdlehY

```yaml
Type: String[]
Parameter Sets: List
Aliases: Parent, Name

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.HangoutsChat.v1.Data.Membership
## NOTES

## RELATED LINKS
