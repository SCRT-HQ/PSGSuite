# New-GSGmailLabel

## SYNOPSIS
Adds a Gmail label

## SYNTAX

```
New-GSGmailLabel [-Name] <String> [-LabelListVisibility <String>] [-MessageListVisibility <String>]
 [-BackgroundColor <String>] [-TextColor <String>] [-User <String>] [<CommonParameters>]
```

## DESCRIPTION
Adds a Gmail label

## EXAMPLES

### EXAMPLE 1
```
New-GSGmailLabel -Name Label1
```

Adds the label "Label1" to the AdminEmail

## PARAMETERS

### -BackgroundColor
The background color of the label

Options and their corresponding hex code:

    Amethyst            = '#8e63ce'
    BananaMania         = '#fce8b3'
    Bermuda             = '#68dfa9'
    BilobaFlower        = '#b694e8'
    Black               = '#000000'
    BlueRomance         = '#c6f3de'
    BrandyPunch         = '#cf8933'
    BurntSienna         = '#e66550'
    Cadillac            = '#b65775'
    Camelot             = '#83334c'
    CeruleanBlue        = '#285bac'
    ChathamsBlue        = '#1c4587'
    Concrete            = '#f3f3f3'
    CornflowerBlue      = '#4a86e8'
    LightCornflowerBlue = '#6d9eeb'
    CreamCan            = '#f2c960'
    Cupid               = '#fbc8d9'
    DeepBlush           = '#e07798'
    Desert              = '#a46a21'
    DoveGray            = '#666666'
    DustyGray           = '#999999'
    Eucalyptus          = '#2a9c68'
    Flesh               = '#ffd6a2'
    FringyFlower        = '#b9e4d0'
    Gallery             = '#efefef'
    Goldenrod           = '#fad165'
    Illusion            = '#f7a7c0'
    Jewel               = '#1a764d'
    Koromiko            = '#ffbc6b'
    LightMountainMeadow = '#16a766'
    LightShamrock       = '#43d692'
    LuxorGold           = '#aa8831'
    MandysPink          = '#f6c5be'
    MediumPurple        = '#a479e2'
    Meteorite           = '#41236d'
    MoonRaker           = '#d0bcf1'
    LightMoonRaker      = '#e4d7f5'
    MountainMeadow      = '#149e60'
    Oasis               = '#fef1d1'
    OceanGreen          = '#44b984'
    OldGold             = '#d5ae49'
    Perano              = '#a4c2f4'
    PersianPink         = '#f691b3'
    PigPink             = '#fcdee8'
    Pueblo              = '#822111'
    RedOrange           = '#fb4c2f'
    RoyalBlue           = '#3c78d8'
    RoyalPurple         = '#653e9b'
    Salem               = '#0b804b'
    Salomie             = '#fcda83'
    SeaPink             = '#efa093'
    Shamrock            = '#3dc789'
    Silver              = '#cccccc'
    Tabasco             = '#ac2b16'
    Tequila             = '#ffe6c7'
    Thunderbird         = '#cc3a21'
    TropicalBlue        = '#c9daf8'
    TulipTree           = '#eaa041'
    Tundora             = '#434343'
    VistaBlue           = '#89d3b2'
    Watercourse         = '#076239'
    WaterLeaf           = '#a0eac9'
    White               = '#ffffff'
    YellowOrange        = '#ffad47'

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

### -LabelListVisibility
The visibility of the label in the label list in the Gmail web interface.

Acceptable values are:
* "labelHide": Do not show the label in the label list.
* "labelShow": Show the label in the label list.
(Default)
* "labelShowIfUnread": Show the label if there are any unread messages with that label.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: LabelShow
Accept pipeline input: False
Accept wildcard characters: False
```

### -MessageListVisibility
The visibility of messages with this label in the message list in the Gmail web interface.

Acceptable values are:
* "hide": Do not show the label in the message list.
* "show": Show the label in the message list.
(Default)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Show
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the label to add

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

### -TextColor
The text color of the label

Options and their corresponding hex code:

    Amethyst            = '#8e63ce'
    BananaMania         = '#fce8b3'
    Bermuda             = '#68dfa9'
    BilobaFlower        = '#b694e8'
    Black               = '#000000'
    BlueRomance         = '#c6f3de'
    BrandyPunch         = '#cf8933'
    BurntSienna         = '#e66550'
    Cadillac            = '#b65775'
    Camelot             = '#83334c'
    CeruleanBlue        = '#285bac'
    ChathamsBlue        = '#1c4587'
    Concrete            = '#f3f3f3'
    CornflowerBlue      = '#4a86e8'
    LightCornflowerBlue = '#6d9eeb'
    CreamCan            = '#f2c960'
    Cupid               = '#fbc8d9'
    DeepBlush           = '#e07798'
    Desert              = '#a46a21'
    DoveGray            = '#666666'
    DustyGray           = '#999999'
    Eucalyptus          = '#2a9c68'
    Flesh               = '#ffd6a2'
    FringyFlower        = '#b9e4d0'
    Gallery             = '#efefef'
    Goldenrod           = '#fad165'
    Illusion            = '#f7a7c0'
    Jewel               = '#1a764d'
    Koromiko            = '#ffbc6b'
    LightMountainMeadow = '#16a766'
    LightShamrock       = '#43d692'
    LuxorGold           = '#aa8831'
    MandysPink          = '#f6c5be'
    MediumPurple        = '#a479e2'
    Meteorite           = '#41236d'
    MoonRaker           = '#d0bcf1'
    LightMoonRaker      = '#e4d7f5'
    MountainMeadow      = '#149e60'
    Oasis               = '#fef1d1'
    OceanGreen          = '#44b984'
    OldGold             = '#d5ae49'
    Perano              = '#a4c2f4'
    PersianPink         = '#f691b3'
    PigPink             = '#fcdee8'
    Pueblo              = '#822111'
    RedOrange           = '#fb4c2f'
    RoyalBlue           = '#3c78d8'
    RoyalPurple         = '#653e9b'
    Salem               = '#0b804b'
    Salomie             = '#fcda83'
    SeaPink             = '#efa093'
    Shamrock            = '#3dc789'
    Silver              = '#cccccc'
    Tabasco             = '#ac2b16'
    Tequila             = '#ffe6c7'
    Thunderbird         = '#cc3a21'
    TropicalBlue        = '#c9daf8'
    TulipTree           = '#eaa041'
    Tundora             = '#434343'
    VistaBlue           = '#89d3b2'
    Watercourse         = '#076239'
    WaterLeaf           = '#a0eac9'
    White               = '#ffffff'
    YellowOrange        = '#ffad47'

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

### -User
The primary email of the user to add the label to

Defaults to the AdminEmail user

```yaml
Type: String
Parameter Sets: (All)
Aliases: PrimaryEmail, UserKey, Mail

Required: False
Position: Named
Default value: $Script:PSGSuite.AdminEmail
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Gmail.v1.Data.Label
## NOTES

## RELATED LINKS
