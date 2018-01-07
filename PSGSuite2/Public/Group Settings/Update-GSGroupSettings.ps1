function Update-GSGroupSettings {
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias('GroupEmail','Group','Email')]
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
        [ValidateScript( {$_.length -le 10000})]
        [String]
        $MessageDenyNotificationText,
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
                if ($G -notlike "*@*.*") {
                    $G = "$($G)@$($Script:PSGSuite.Domain)"
                }
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
                $request = $service.Groups.Patch($body,$G)
                $request.Alt = "Json"
                $request.Execute() | Select-Object @{N = "Group";E = {$G}},*
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}