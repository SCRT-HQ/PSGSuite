function Update-GSGmailLabel {
    <#
    .SYNOPSIS
    Updates Gmail label information for the specified labelid

    .DESCRIPTION
    Updates Gmail label information for the specified labelid

    .PARAMETER LabelId
    The unique Id of the label to update.  Required.

    .PARAMETER User
    The user to update label information for

    Defaults to the AdminEmail user

    .EXAMPLE
    Update-GSGmailLabel -User user@domain.com -LabelId Label_79 -BackgroundColor Black -TextColor Bermuda

    Updates the specified Gmail label with new background and text colors
    #>
    [cmdletbinding(DefaultParameterSetName = "Fields")]
    Param
    (
        [parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true, ParameterSetName = "Fields")]
        [Alias("Id")]
        [string[]]
        $LabelId,
        [parameter(Mandatory = $false, Position = 1)]
        [ValidateSet("labelHide","labelShow","labelShowIfUnread")]
        [string]
        $LabelListVisibility,
        [parameter(Mandatory = $false, Position = 2)]
        [ValidateSet("hide","show")]
        [string]
        $MessageListVisibility,
        [parameter(Mandatory = $false, Position = 3)]
        [string]
        $Name,
        [parameter(Mandatory = $false)]
        [ValidateSet('Amethyst','BananaMania','Bermuda','BilobaFlower','Black','BlueRomance','BrandyPunch','BurntSienna','Cadillac','Camelot','CeruleanBlue','ChathamsBlue','Concrete','CornflowerBlue','CreamCan','Cupid','DeepBlush','Desert','DoveGray','DustyGray','Eucalyptus','Flesh','FringyFlower','Gallery','Goldenrod','Illusion','Jewel','Koromiko','LightCornflowerBlue','LightMoonRaker','LightMountainMeadow','LightShamrock','LuxorGold','MandysPink','MediumPurple','Meteorite','MoonRaker','MountainMeadow','Oasis','OceanGreen','OldGold','Perano','PersianPink','PigPink','Pueblo','RedOrange','RoyalBlue','RoyalPurple','Salem','Salomie','SeaPink','Shamrock','Silver','Tabasco','Tequila','Thunderbird','TropicalBlue','TulipTree','Tundora','VistaBlue','Watercourse','WaterLeaf','White','YellowOrange')]
        [string]
        $BackgroundColor,
        [parameter(Mandatory = $false)]
        [ValidateSet('Amethyst','BananaMania','Bermuda','BilobaFlower','Black','BlueRomance','BrandyPunch','BurntSienna','Cadillac','Camelot','CeruleanBlue','ChathamsBlue','Concrete','CornflowerBlue','CreamCan','Cupid','DeepBlush','Desert','DoveGray','DustyGray','Eucalyptus','Flesh','FringyFlower','Gallery','Goldenrod','Illusion','Jewel','Koromiko','LightCornflowerBlue','LightMoonRaker','LightMountainMeadow','LightShamrock','LuxorGold','MandysPink','MediumPurple','Meteorite','MoonRaker','MountainMeadow','Oasis','OceanGreen','OldGold','Perano','PersianPink','PigPink','Pueblo','RedOrange','RoyalBlue','RoyalPurple','Salem','Salomie','SeaPink','Shamrock','Silver','Tabasco','Tequila','Thunderbird','TropicalBlue','TulipTree','Tundora','VistaBlue','Watercourse','WaterLeaf','White','YellowOrange')]
        [string]
        $TextColor,
        [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = "Fields")]
        [Alias("PrimaryEmail", "UserKey", "Mail")]
        [ValidateNotNullOrEmpty()]
        [string]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = "InputObject")]
        [Google.Apis.Gmail.v1.Data.Label]
        $InputObject
    )
    Begin {
        $colorDict = @{
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
        }
    }
    Process {
        switch ($PSCmdlet.ParameterSetName) {
            InputObject {
                $U = $InputObject.User
                $labels = @($InputObject.Id)
            }
            Fields {
                $U = $User
                $labels = $LabelId
            }
        }
        if ($U -ceq 'me') {
            $U = $Script:PSGSuite.AdminEmail
        }
        elseif ($U -notlike "*@*.*") {
            $U = "$($U)@$($Script:PSGSuite.Domain)"
        }
        $serviceParams = @{
            Scope       = 'https://mail.google.com'
            ServiceType = 'Google.Apis.Gmail.v1.GmailService'
            User        = $U
        }
        $service = New-GoogleService @serviceParams
        try {
            $body = New-Object 'Google.Apis.Gmail.v1.Data.Label'
            foreach ($prop in $PSBoundParameters.Keys | Where-Object {$body.PSObject.Properties.Name -contains $_}) {
                $body.$prop = $PSBoundParameters[$prop]
            }
            if ($PSBoundParameters.Keys -contains 'BackgroundColor' -or $PSBoundParameters.Keys -contains 'TextColor') {
                $color = New-Object 'Google.Apis.Gmail.v1.Data.LabelColor'
                foreach ($prop in $PSBoundParameters.Keys | Where-Object {$color.PSObject.Properties.Name -contains $_}) {
                    $color.$prop = $colorDict[$PSBoundParameters[$prop]]
                }
                $body.Color = $color
            }
            foreach ($label in $labels) {
                Write-Verbose "Updating Label Id '$label' for user '$U'"
                $request = $service.Users.Labels.Patch($body, $U, $label)
                $request.Execute() | Add-Member -MemberType NoteProperty -Name 'User' -Value $U -PassThru
            }
        }
        catch {
            if ($ErrorActionPreference -eq 'Stop') {
                $PSCmdlet.ThrowTerminatingError($_)
            }
            else {
                Write-Error $_
            }
        }
    }
}
