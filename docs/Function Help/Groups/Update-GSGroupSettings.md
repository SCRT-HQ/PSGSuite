# Update-GSGroupSettings

## SYNOPSIS
Updates the settings for a group while retaining excluded, already existing settings

## SYNTAX

```
Update-GSGroupSettings [-Identity] <String[]> [-Name <String>] [-Description <String>] [-ArchiveOnly]
 [-AllowExternalMembers] [-AllowGoogleCommunication] [-AllowWebPosting] [-CustomFooterText <String>]
 [-CustomReplyToAddress <String>] [-DefaultMessageDenyNotificationText <String>] [-Email <String>]
 [-EnableCollaborativeInbox] [-IncludeCustomFooter] [-IncludeInGlobalAddressList] [-IsArchived]
 [-MaxMessageBytes <Int32>] [-MembersCanPostAsTheGroup] [-MessageDisplayFont <String>]
 [-MessageModerationLevel <String>] [-ReplyTo <String>] [-SendMessageDenyNotification] [-ShowInGroupDirectory]
 [-SpamModerationLevel <String>] [-WhoCanAdd <String>] [-WhoCanContactOwner <String>]
 [-WhoCanDiscoverGroup <String>] [-WhoCanInvite <String>] [-WhoCanJoin <String>] [-WhoCanLeaveGroup <String>]
 [-WhoCanPostMessage <String>] [-WhoCanViewGroup <String>] [-WhoCanViewMembership <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Updates the settings for a group while retaining excluded, already existing settings

## EXAMPLES

### EXAMPLE 1
```
Updates-GSGroupSettings admins,hr-notifications -AllowExternalMembers:$false -WhoCanPostMessage ALL_OWNERS_CAN_POST
```

Updates the group settings for both admins@domain.com and hr-notifications@domain.com to deny external members and limit posting to only group owners

## PARAMETERS

### -AllowExternalMembers
Are external members allowed to join the group

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

### -AllowGoogleCommunication
Is google allowed to contact admins

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

### -AllowWebPosting
If posting from web is allowed

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

### -ArchiveOnly
If the group is archive only

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

### -CustomFooterText
Custom footer text

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CustomReplyToAddress
Default email to which reply to any message should go

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DefaultMessageDenyNotificationText
Default message deny notification message

```yaml
Type: String
Parameter Sets: (All)
Aliases: MessageDenyNotificationText

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
The new description of the group

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Email
Email id of the group

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnableCollaborativeInbox
Specifies whether the collaborative inbox functionality will be turned on or off for the group.

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

### -Identity
The primary email or unique Id of the group to update

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: GroupEmail, Group

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -IncludeCustomFooter
Whether to include custom footer

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

### -IncludeInGlobalAddressList
If this groups should be included in global address list or not

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

### -IsArchived
If the contents of the group are archived

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

### -MaxMessageBytes
Maximum message size allowed

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -MembersCanPostAsTheGroup
Can members post using the group email address

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

### -MessageDisplayFont
Default message display font

Available values are:
* "DEFAULT_FONT"
* "FIXED_WIDTH_FONT"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MessageModerationLevel
Moderation level for messages

Available values are:
* "MODERATE_ALL_MESSAGES"
* "MODERATE_NON_MEMBERS"
* "MODERATE_NEW_MEMBERS"
* "MODERATE_NONE"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The new name of the group

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReplyTo
Who should the default reply to a message go to

Available values are:
* "REPLY_TO_CUSTOM"
* "REPLY_TO_SENDER"
* "REPLY_TO_LIST"
* "REPLY_TO_OWNER"
* "REPLY_TO_IGNORE"
* "REPLY_TO_MANAGERS"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SendMessageDenyNotification
Should the member be notified if his message is denied by owner

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

### -ShowInGroupDirectory
Is the group listed in groups directory

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

### -SpamModerationLevel
Moderation level for messages detected as spam

Available values are:
* "ALLOW"
* "MODERATE"
* "SILENTLY_MODERATE"
* "REJECT"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhoCanAdd
Permissions to add members

Available values are:
* "ALL_MANAGERS_CAN_ADD"
* "ALL_MEMBERS_CAN_ADD"
* "NONE_CAN_ADD"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhoCanContactOwner
Permission to contact owner of the group via web UI

Available values are:
* "ANYONE_CAN_CONTACT"
* "ALL_IN_DOMAIN_CAN_CONTACT"
* "ALL_MEMBERS_CAN_CONTACT"
* "ALL_MANAGERS_CAN_CONTACT"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhoCanDiscoverGroup
Specifies the set of users for whom this group is discoverable.
Available values are:
* "ANYONE_CAN_DISCOVER"
* "ALL_IN_DOMAIN_CAN_DISCOVER"
* "ALL_MEMBERS_CAN_DISCOVER"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhoCanInvite
Permissions to invite members.
Available values are:
* "ALL_MEMBERS_CAN_INVITE"
* "ALL_MANAGERS_CAN_INVITE"
* "NONE_CAN_INVITE"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhoCanJoin
Permissions to join the group.
Available values are:
* "ANYONE_CAN_JOIN"
* "ALL_IN_DOMAIN_CAN_JOIN"
* "INVITED_CAN_JOIN"
* "CAN_REQUEST_TO_JOIN"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhoCanLeaveGroup
Permission to leave the group.

Available values are:
* "ALL_MANAGERS_CAN_LEAVE"
* "ALL_MEMBERS_CAN_LEAVE"
* "NONE_CAN_LEAVE"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhoCanPostMessage
Permissions to post messages to the group.

Available values are:
* "NONE_CAN_POST"
* "ALL_MANAGERS_CAN_POST"
* "ALL_MEMBERS_CAN_POST"
* "ALL_OWNERS_CAN_POST"
* "ALL_IN_DOMAIN_CAN_POST"
* "ANYONE_CAN_POST"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhoCanViewGroup
Permissions to view group.

Available values are:
* "ANYONE_CAN_VIEW"
* "ALL_IN_DOMAIN_CAN_VIEW"
* "ALL_MEMBERS_CAN_VIEW"
* "ALL_MANAGERS_CAN_VIEW"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhoCanViewMembership
Permissions to view membership.

Available values are:
* "ALL_IN_DOMAIN_CAN_VIEW"
* "ALL_MEMBERS_CAN_VIEW"
* "ALL_MANAGERS_CAN_VIEW"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Groupssettings.v1.Data.Groups
## NOTES

## RELATED LINKS
