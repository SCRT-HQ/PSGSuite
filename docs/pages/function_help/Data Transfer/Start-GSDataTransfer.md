# Start-GSDataTransfer

## SYNOPSIS
Starts a Data Transfer from one user to another

## SYNTAX

```
Start-GSDataTransfer [-OldOwnerUserId] <String> [-NewOwnerUserId] <String> [-ApplicationId] <String>
 [-PrivacyLevel <String[]>] [-ReleaseResources] [<CommonParameters>]
```

## DESCRIPTION
Starts a Data Transfer from one user to another

## EXAMPLES

### EXAMPLE 1
```
Start-GSDataTransfer -OldOwnerUserId joe -NewOwnerUserId mark -ApplicationId 55656082996 -PrivacyLevel SHARED,PRIVATE
```

Transfers all of Joe's data to Mark

## PARAMETERS

### -ApplicationId
The application Id that you would like to transfer data for

```yaml
Type: String
Parameter Sets: (All)
Aliases: id

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -NewOwnerUserId
The email or unique Id of the owner you are transferring data *TO*

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OldOwnerUserId
The email or unique Id of the owner you are transferring data *FROM*

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PrivacyLevel
The privacy level for the data you'd like to transfer

*Valid for Drive & Docs data transfers only.*

Available values are:
* "SHARED": all shared content owned by the user
* "PRIVATE": all private (unshared) content owned by the user

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReleaseResources
If true, releases Calendar resources booked by the OldOwner to the NewOwner.

*Valid for Calendar data transfers only.*

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Admin.DataTransfer.datatransfer_v1.Data.DataTransfer
## NOTES

## RELATED LINKS
