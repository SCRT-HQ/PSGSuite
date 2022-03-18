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

    .PARAMETER AllowExternalMembers
    Are external members allowed to join the group

    .PARAMETER AllowWebPosting
    If posting from web is allowed

    .PARAMETER ArchiveOnly
    If the group is archive only

    .PARAMETER CustomFooterText
    Custom footer text

    .PARAMETER CustomReplyTo
    Email address used when replying to a message if the replyTo property is set to REPLY_TO_CUSTOM

    .PARAMETER DefaultMessageDenyNotificationText
    Text of message sent when message is rejected to message's author
    Requires SendMessageDenyNotification to be true

    .PARAMETER EnableCollaborativeInbox
    Whether a collaborative inbox will remain turned on for the group

    .PARAMETER FavoriteRepliesOnTop
    If favorite replies should be displayed above other replies

    .PARAMETER IncludeCustomFooter
    Whether to include custom footer

    .PARAMETER IncludeInGlobalAddressList
    If this groups should be included in global address list or not

    .PARAMETER IsArchived
    If the contents of the group are archived

    .PARAMETER MembersCanPostAsTheGroup
    Can members post using the group email address

    .PARAMETER MessageModerationLevel
    Moderation level of incoming messages

    Available values are:
    * "MODERATE_ALL_MESSAGES"
    * "MODERATE_NON_MEMBERS"
    * "MODERATE_NEW_MEMBERS"
    * "MODERATE_NONE"  -GApps Default

    .PARAMETER PrimaryLanguage
    The primary language for group in format of RFC 3066 Language Tag accepted by Google Mail

    .PARAMETER ReplyTo
    who the default reply should go to

    Available values are:
    * "REPLY_TO_CUSTOM"  -Requires that CustomReplyTo must be set
    * "REPLY_TO_SENDER"
    * "REPLY_TO_LIST"
    * "REPLY_TO_OWNER"
    * "REPLY_TO_IGNORE"  -GApps Default
    * "REPLY_TO_MANAGERS"

    .PARAMETER SendMessageDenyNotification
    Allows a member to be notified if the member's message to the group is denied by the group owner
    If true, the property defaultMessageDenyNotificationText is dependent on this property

    .PARAMETER SpamModerationLevel
    Specifies moderation levels for messages detected as spam

    Available values are:
    * "ALLOW"
    * "MODERATE"  -GApps Default
    * "SILENTLY_MODERATE"
    * "REJECT"

    .PARAMETER WhoCanAssistContent
    Specifies who can moderate metadata
    Note: In March 2019, the whoCanModerateMembers, whoCanModerateContent, and whoCanAssistContent parent properties were

    Available values are:
    * "ALL_MEMBERS"
    * "OWNERS_AND_MANAGERS"
    * "MANAGERS_ONLY"
    * "OWNERS_ONLY"
    * "NONE"  -GApps Default

    .PARAMETER WhoCanContactOwner
    Specifies who can contact the group owner

    Available values are:
    * "ALL_IN_DOMAIN_CAN_CONTACT"
    * "ALL_MANAGERS_CAN_CONTACT"
    * "ALL_MEMBERS_CAN_CONTACT"
    * "ANYONE_CAN_CONTACT"

    .PARAMETER WhoCanDiscoverGroup
    Specifies the set of users for whom this group is discoverable

    Available values are:
    * "ANYONE_CAN_DISCOVER"
    * "ALL_IN_DOMAIN_CAN_DISCOVER"  -GApps Default
    * "ALL_MEMBERS_CAN_DISCOVER"

    .PARAMETER WhoCanJoin
    Permission to join group

    Available values are:
    * "ANYONE_CAN_JOIN"
    * "ALL_IN_DOMAIN_CAN_JOIN"
    * "INVITED_CAN_JOIN"
    * "CAN_REQUEST_TO_JOIN"

    .PARAMETER WhoCanLeaveGroup
    Specifies who can leave the group

    Available values are:
    * "ALL_MANAGERS_CAN_LEAVE"
    * "ALL_MEMBERS_CAN_LEAVE"  -GApps Default
    * "NONE_CAN_LEAVE"

    .PARAMETER WhoCanModerateContent
    Specifies who can moderate content
    Note: In March 2019, the whoCanModerateMembers, whoCanModerateContent, and whoCanAssistContent parent properties were
    added to merge similar properties.

    Available values are:
    * "ALL_MEMBERS"
    * "OWNERS_AND_MANAGERS"  -GApps Default
    * "OWNERS_ONLY"
    * "NONE"

    .PARAMETER WhoCanModerateMembers
    Specifies who can manage members
    Note: In March 2019, the whoCanModerateMembers, whoCanModerateContent, and whoCanAssistContent parent properties were
    added to merge similar properties.

    Available values are:
    * "ALL_MEMBERS"
    * "OWNERS_AND_MANAGERS"
    * "OWNERS_ONLY"  -GApps Default
    * "NONE"

    .PARAMETER WhoCanPostMessage
    Permissions to post messages

    Available values are:
    * "NONE_CAN_POST"
    * "ALL_MANAGERS_CAN_POST"
    * "ALL_MEMBERS_CAN_POST"
    * "ALL_OWNERS_CAN_POST"
    * "ALL_IN_DOMAIN_CAN_POST"
    * "ANYONE_CAN_POST"

    .PARAMETER WhoCanViewGroup
    Permissions to view group messages

    Available values are:
    * "ANYONE_CAN_VIEW"
    * "ALL_IN_DOMAIN_CAN_VIEW"
    * "ALL_MEMBERS_CAN_VIEW"  -GApps Default
    * "ALL_MANAGERS_CAN_VIEW"
    * "ALL_OWNERS_CAN_VIEW"

    .PARAMETER WhoCanViewMembership
    Permissions to view membership

    Available values are:
    * "ALL_IN_DOMAIN_CAN_VIEW"
    * "ALL_MEMBERS_CAN_VIEW"  -GApps Default
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
      [ValidateScript( {$_.length -le 75})]
      [String]
      $Name,
      [parameter(Mandatory = $false)]
      [ValidateScript( {$_.length -le 300})]
      [String]
      $Description,
      [parameter(Mandatory = $false)]
      [Switch]
      $AllowExternalMembers,
      [parameter(Mandatory = $false)]
      [Switch]
      $AllowWebPosting,
      [parameter(Mandatory = $false)]
      [Switch]
      $ArchiveOnly,
      [parameter(Mandatory = $false)]
      [ValidateScript( {$_.length -le 1000})]
      [String]
      $CustomFooterText,
      [parameter(Mandatory = $false)]
      [String]
      $CustomReplyTo,
      [parameter(Mandatory = $false)]
      [Alias('MessageDenyNotificationText')]
      [ValidateScript( {$_.length -le 10000})]
      [String]
      $DefaultMessageDenyNotificationText,
      [parameter(Mandatory = $false)]
      [Switch]
      $EnableCollaborativeInbox,
      [parameter(Mandatory = $false)]
      [Switch]
      $FavoriteRepliesOnTop,
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
      [Switch]
      $MembersCanPostAsTheGroup,
      [parameter(Mandatory = $false)]
      [ValidateSet("MODERATE_ALL_MESSAGES","MODERATE_NEW_MEMBERS","MODERATE_NONE","MODERATE_NON_MEMBERS")]
      [String]
      $MessageModerationLevel,
      [ValidateScript( {$_.length -le 5})]
      [String]
      $PrimaryLanguage,
      [parameter(Mandatory = $false)]
      [ValidateSet("REPLY_TO_CUSTOM","REPLY_TO_IGNORE","REPLY_TO_LIST","REPLY_TO_MANAGERS","REPLY_TO_OWNER","REPLY_TO_SENDER")]
      [String]
      $ReplyTo,
      [parameter(Mandatory = $false)]
      [Switch]
      $SendMessageDenyNotification,
      [parameter(Mandatory = $false)]
      [ValidateSet("ALLOW","MODERATE","SILENTLY_MODERATE","REJECT")]
      [String]
      $SpamModerationLevel,
      [parameter(Mandatory = $false)]
      [ValidateSet("ALL_MEMBERS","OWNERS_AND_MANAGERS","MANAGERS_ONLY","OWNERS_ONLY","NONE")]
      [String]
      $WhoCanAssistContent,
      [parameter(Mandatory = $false)]
      [ValidateSet("ALL_IN_DOMAIN_CAN_CONTACT","ALL_MANAGERS_CAN_CONTACT","ALL_MEMBERS_CAN_CONTACT","ANYONE_CAN_CONTACT")]
      [String]
      $WhoCanContactOwner,
      [parameter(Mandatory = $false)]
      [ValidateSet("ANYONE_CAN_DISCOVER","ALL_IN_DOMAIN_CAN_DISCOVER","ALL_MEMBERS_CAN_DISCOVER")]
      [String]
      $WhoCanDiscoverGroup,
      [parameter(Mandatory = $false)]
      [ValidateSet("ALL_IN_DOMAIN_CAN_JOIN","ANYONE_CAN_JOIN","CAN_REQUEST_TO_JOIN","INVITED_CAN_JOIN")]
      [String]
      $WhoCanJoin,
      [parameter(Mandatory = $false)]
      [ValidateSet("ALL_MANAGERS_CAN_LEAVE","ALL_MEMBERS_CAN_LEAVE","NONE_CAN_LEAVE")]
      [String]
      $WhoCanLeaveGroup,
      [parameter(Mandatory = $false)]
      [ValidateSet("ALL_MEMBERS","OWNERS_AND_MANAGERS","OWNERS_ONLY","NONE")]
      [String]
      $WhoCanModerateContent,
      [parameter(Mandatory = $false)]
      [ValidateSet("ALL_MEMBERS","OWNERS_AND_MANAGERS","OWNERS_ONLY","NONE")]
      [String]
      $WhoCanModerateMembers,
      [parameter(Mandatory = $false)]
      [ValidateSet("NONE_CAN_POST","ALL_MANAGERS_CAN_POST","ALL_MEMBERS_CAN_POST","ALL_OWNERS_CAN_POST","ALL_IN_DOMAIN_CAN_POST","ANYONE_CAN_POST")]
      [String]
      $WhoCanPostMessage,
      [parameter(Mandatory = $false)]
      [ValidateSet("ANYONE_CAN_VIEW","ALL_IN_DOMAIN_CAN_VIEW","ALL_MEMBERS_CAN_VIEW","ALL_MANAGERS_CAN_VIEW","ALL_OWNERS_CAN_VIEW")]
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
