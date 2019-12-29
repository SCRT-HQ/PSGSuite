function Set-GSGroupSettings {
    <#
    .SYNOPSIS
    Hard-sets the settings for a group

    .DESCRIPTION
    Hard-sets the settings for a group

    .PARAMETER Identity
    The primary email or unique Id of the group to set

    .PARAMETER Name
    The new name of the group

    .PARAMETER Description
    The new description of the group

    .PARAMETER ArchiveOnly
    If the group is archive only

    .PARAMETER AllowExternalMembers
    Are external members allowed to join the group

    .PARAMETER AllowGoogleCommunication
    Is google allowed to contact admins

    .PARAMETER AllowWebPosting
    If posting from web is allowed

    .PARAMETER CustomFooterText
    Custom footer text

    .PARAMETER CustomReplyToAddress
    Default email to which reply to any message should go

    .PARAMETER DefaultMessageDenyNotificationText
    Default message deny notification message

    .PARAMETER Email
    Email id of the group

    .PARAMETER IncludeCustomFooter
    Whether to include custom footer

    .PARAMETER IncludeInGlobalAddressList
    If this groups should be included in global address list or not

    .PARAMETER IsArchived
    If the contents of the group are archived

    .PARAMETER MaxMessageBytes
    Maximum message size allowed

    .PARAMETER MembersCanPostAsTheGroup
    Can members post using the group email address

    .PARAMETER MessageDisplayFont
    Default message display font

    Available values are:
    * "DEFAULT_FONT"
    * "FIXED_WIDTH_FONT"

    .PARAMETER MessageModerationLevel
    Moderation level for messages

    Available values are:
    * "MODERATE_ALL_MESSAGES"
    * "MODERATE_NON_MEMBERS"
    * "MODERATE_NEW_MEMBERS"
    * "MODERATE_NONE"

    .PARAMETER ReplyTo
    Who should the default reply to a message go to

    Available values are:
    * "REPLY_TO_CUSTOM"
    * "REPLY_TO_SENDER"
    * "REPLY_TO_LIST"
    * "REPLY_TO_OWNER"
    * "REPLY_TO_IGNORE"
    * "REPLY_TO_MANAGERS"

    .PARAMETER SendMessageDenyNotification
    Should the member be notified if his message is denied by owner

    .PARAMETER ShowInGroupDirectory
    Is the group listed in groups directory

    .PARAMETER SpamModerationLevel
    Moderation level for messages detected as spam

    Available values are:
    * "ALLOW"
    * "MODERATE"
    * "SILENTLY_MODERATE"
    * "REJECT"

    .PARAMETER WhoCanAdd
    Permissions to add members

    Available values are:
    * "ALL_MANAGERS_CAN_ADD"
    * "ALL_MEMBERS_CAN_ADD"
    * "NONE_CAN_ADD"

    .PARAMETER WhoCanContactOwner
    Permission to contact owner of the group via web UI

    Available values are:
    * "ANYONE_CAN_CONTACT"
    * "ALL_IN_DOMAIN_CAN_CONTACT"
    * "ALL_MEMBERS_CAN_CONTACT"
    * "ALL_MANAGERS_CAN_CONTACT"

    .PARAMETER WhoCanInvite
    Permissions to invite members.
    Available values are:
    * "ALL_MEMBERS_CAN_INVITE"
    * "ALL_MANAGERS_CAN_INVITE"
    * "NONE_CAN_INVITE"

    .PARAMETER WhoCanJoin
    Permissions to join the group.
    Available values are:
    * "ANYONE_CAN_JOIN"
    * "ALL_IN_DOMAIN_CAN_JOIN"
    * "INVITED_CAN_JOIN"
    * "CAN_REQUEST_TO_JOIN"

    .PARAMETER WhoCanLeaveGroup
    Permission to leave the group.

    Available values are:
    * "ALL_MANAGERS_CAN_LEAVE"
    * "ALL_MEMBERS_CAN_LEAVE"
    * "NONE_CAN_LEAVE"

    .PARAMETER WhoCanPostMessage
    Permissions to post messages to the group.

    Available values are:
    * "NONE_CAN_POST"
    * "ALL_MANAGERS_CAN_POST"
    * "ALL_MEMBERS_CAN_POST"
    * "ALL_OWNERS_CAN_POST"
    * "ALL_IN_DOMAIN_CAN_POST"
    * "ANYONE_CAN_POST"

    .PARAMETER WhoCanViewGroup
    Permissions to view group.

    Available values are:
    * "ANYONE_CAN_VIEW"
    * "ALL_IN_DOMAIN_CAN_VIEW"
    * "ALL_MEMBERS_CAN_VIEW"
    * "ALL_MANAGERS_CAN_VIEW"

    .PARAMETER WhoCanViewMembership
    Permissions to view membership.

    Available values are:
    * "ALL_IN_DOMAIN_CAN_VIEW"
    * "ALL_MEMBERS_CAN_VIEW"
    * "ALL_MANAGERS_CAN_VIEW"

    .EXAMPLE
    Set-GSGroupSettings admins,hr-notifications -AllowExternalMembers:$false -WhoCanPostMessage ALL_OWNERS_CAN_POST

    Sets the group settings for both admins@domain.com and hr-notifications@domain.com to deny external members and limit posting to only group owners
    #>
    [OutputType('Google.Apis.Groupssettings.v1.Data.Groups')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias('GroupEmail','Group')]
        [String[]]
        $Identity,
        [parameter(Mandatory = $false)]
        [String]
        $Name,
        [parameter(Mandatory = $false)]
        [String]
        $Description,
        [parameter(Mandatory = $false)]
        [Switch]
        $ArchiveOnly,
        [parameter(Mandatory = $false)]
        [Switch]
        $AllowExternalMembers,
        [parameter(Mandatory = $false)]
        [Switch]
        $AllowGoogleCommunication,
        [parameter(Mandatory = $false)]
        [Switch]
        $AllowWebPosting,
        [parameter(Mandatory = $false)]
        [ValidateScript( {$_.length -le 1000})]
        [String]
        $CustomFooterText,
        [parameter(Mandatory = $false)]
        [String]
        $CustomReplyToAddress,
        [parameter(Mandatory = $false)]
        [Alias('MessageDenyNotificationText')]
        [ValidateScript( {$_.length -le 10000})]
        [String]
        $DefaultMessageDenyNotificationText,
        [parameter(Mandatory = $false)]
        [String]
        $Email,
        [parameter(Mandatory = $false)]
        [Switch]
        $IncludeCustomFooter,
        [parameter(Mandatory = $false)]
        [Switch]
        $IncludeInGlobalAddressList,
        [parameter(Mandatory = $false)]
        [Switch]
        $IsArchived,
        [parameter(Mandatory = $false)]
        [int]
        $MaxMessageBytes,
        [parameter(Mandatory = $false)]
        [Switch]
        $MembersCanPostAsTheGroup,
        [parameter(Mandatory = $false)]
        [ValidateSet("DEFAULT_FONT","FIXED_WIDTH_FONT")]
        [String]
        $MessageDisplayFont,
        [parameter(Mandatory = $false)]
        [ValidateSet("MODERATE_ALL_MESSAGES","MODERATE_NEW_MEMBERS","MODERATE_NONE","MODERATE_NON_MEMBERS")]
        [String]
        $MessageModerationLevel,
        [parameter(Mandatory = $false)]
        [ValidateSet("REPLY_TO_CUSTOM","REPLY_TO_IGNORE","REPLY_TO_LIST","REPLY_TO_MANAGERS","REPLY_TO_OWNER","REPLY_TO_SENDER")]
        [String]
        $ReplyTo,
        [parameter(Mandatory = $false)]
        [Switch]
        $SendMessageDenyNotification,
        [parameter(Mandatory = $false)]
        [Switch]
        $ShowInGroupDirectory,
        [parameter(Mandatory = $false)]
        [ValidateSet("ALLOW","MODERATE","SILENTLY_MODERATE","REJECT")]
        [String]
        $SpamModerationLevel,
        [parameter(Mandatory = $false)]
        [ValidateSet("ALL_MEMBERS_CAN_ADD","ALL_MANAGERS_CAN_ADD","NONE_CAN_ADD")]
        [String]
        $WhoCanAdd,
        [parameter(Mandatory = $false)]
        [ValidateSet("ALL_IN_DOMAIN_CAN_CONTACT","ALL_MANAGERS_CAN_CONTACT","ALL_MEMBERS_CAN_CONTACT","ANYONE_CAN_CONTACT")]
        [String]
        $WhoCanContactOwner,
        [parameter(Mandatory = $false)]
        [ValidateSet("ALL_MANAGERS_CAN_INVITE","ALL_MEMBERS_CAN_INVITE","NONE_CAN_INVITE")]
        [String]
        $WhoCanInvite,
        [parameter(Mandatory = $false)]
        [ValidateSet("ALL_IN_DOMAIN_CAN_JOIN","ANYONE_CAN_JOIN","CAN_REQUEST_TO_JOIN","INVITED_CAN_JOIN")]
        [String]
        $WhoCanJoin,
        [parameter(Mandatory = $false)]
        [ValidateSet("ALL_MANAGERS_CAN_LEAVE","ALL_MEMBERS_CAN_LEAVE","NONE_CAN_LEAVE")]
        [String]
        $WhoCanLeaveGroup,
        [parameter(Mandatory = $false)]
        [ValidateSet("ALL_IN_DOMAIN_CAN_POST","ALL_MANAGERS_CAN_POST","ALL_MEMBERS_CAN_POST","ANYONE_CAN_POST","NONE_CAN_POST")]
        [String]
        $WhoCanPostMessage,
        [parameter(Mandatory = $false)]
        [ValidateSet("ALL_IN_DOMAIN_CAN_VIEW","ALL_MANAGERS_CAN_VIEW","ALL_MEMBERS_CAN_VIEW","ANYONE_CAN_VIEW")]
        [String]
        $WhoCanViewGroup,
        [parameter(Mandatory = $false)]
        [ValidateSet("ALL_IN_DOMAIN_CAN_VIEW","ALL_MANAGERS_CAN_VIEW","ALL_MEMBERS_CAN_VIEW")]
        [String]
        $WhoCanViewMembership
    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/apps.groups.settings'
            ServiceType = 'Google.Apis.Groupssettings.v1.GroupssettingsService'
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        try {
            foreach ($G in $Identity) {
                Resolve-Email ([ref]$G) -IsGroup
                Write-Verbose "Updating settings for group '$G'"
                $body = New-Object 'Google.Apis.Groupssettings.v1.Data.Groups'
                foreach ($prop in $PSBoundParameters.Keys | Where-Object {$body.PSObject.Properties.Name -contains $_}) {
                    switch ($prop) {
                        MaxMessageBytes {
                            $body.$prop = $PSBoundParameters[$prop]
                        }
                        Default {
                            $body.$prop = if ($PSBoundParameters[$prop].ToString() -in @("True","False")) {
                                $($PSBoundParameters[$prop]).ToString().ToLower()
                            }
                            else {
                                $PSBoundParameters[$prop]
                            }
                        }
                    }
                }
                $request = $service.Groups.Update($body,$G)
                $request.Alt = "Json"
                $request.Execute() | Add-Member -MemberType NoteProperty -Name 'Group' -Value $G -PassThru
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
