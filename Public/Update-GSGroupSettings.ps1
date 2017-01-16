function Update-GSGroupSettings {
    [cmdletbinding()]
    Param
    (
      [parameter(Position=0,Mandatory=$true)]
      [String]
      $Group,
      [parameter(Mandatory=$false)]
      [String]
      $Name,
      [parameter(Mandatory=$false)]
      [String]
      $Description,
      [parameter(Mandatory=$false)]
      [ValidateSet("ALL_IN_DOMAIN_CAN_JOIN","ANYONE_CAN_JOIN","CAN_REQUEST_TO_JOIN","INVITED_CAN_JOIN")]
      [String]
      $WhoCanJoin,
      [parameter(Mandatory=$false)]
      [ValidateSet("ALL_IN_DOMAIN_CAN_VIEW","ALL_MANAGERS_CAN_VIEW","ALL_MEMBERS_CAN_VIEW")]
      [String]
      $WhoCanViewMembership,
      [parameter(Mandatory=$false)]
      [ValidateSet("ALL_IN_DOMAIN_CAN_VIEW","ALL_MANAGERS_CAN_VIEW","ALL_MEMBERS_CAN_VIEW","ANYONE_CAN_VIEW")]
      [String]
      $WhoCanViewGroup,
      [parameter(Mandatory=$false)]
      [ValidateSet("ALL_MANAGERS_CAN_INVITE","ALL_MEMBERS_CAN_INVITE","NONE_CAN_INVITE")]
      [String]
      $WhoCanInvite,
      [parameter(Mandatory=$false)]
      [ValidateSet("ALL_MEMBERS_CAN_ADD","ALL_MANAGERS_CAN_ADD","NONE_CAN_ADD")]
      [String]
      $WhoCanAdd,
      [parameter(Mandatory=$false)]
      [ValidateSet($true,$false)]
      [String]
      $AllowExternalMembers,
      [parameter(Mandatory=$false)]
      [ValidateSet("ALL_IN_DOMAIN_CAN_POST","ALL_MANAGERS_CAN_POST","ALL_MEMBERS_CAN_POST","ANYONE_CAN_POST","NONE_CAN_POST")]
      [String]
      $WhoCanPostMessage,
      [parameter(Mandatory=$false)]
      [ValidateSet($true,$false)]
      [String]
      $AllowWebPosting,
      [parameter(Mandatory=$false)]
      [int]
      $MaxMessageBytes,
      [parameter(Mandatory=$false)]
      [ValidateSet($true,$false)]
      [String]
      $IsArchived,
      [parameter(Mandatory=$false)]
      [ValidateSet($true,$false)]
      [String]
      $ArchiveOnly,
      [parameter(Mandatory=$false)]
      [ValidateSet("MODERATE_ALL_MESSAGES","MODERATE_NEW_MEMBERS","MODERATE_NONE","MODERATE_NON_MEMBERS")]
      [String]
      $MessageModerationLevel,
      [parameter(Mandatory=$false)]
      [ValidateSet("ALLOW","MODERATE","SILENTLY_MODERATE","REJECT")]
      [String]
      $SpamModerationLevel,
      [parameter(Mandatory=$false)]
      [ValidateSet("REPLY_TO_CUSTOM","REPLY_TO_IGNORE","REPLY_TO_LIST","REPLY_TO_MANAGERS","REPLY_TO_OWNER","REPLY_TO_SENDER")]
      [String]
      $ReplyTo,
      [parameter(Mandatory=$false)]
      [String]
      $CustomReplyToAddress,
      [parameter(Mandatory=$false)]
      [ValidateSet($true,$false)]
      [String]
      $IncludeCustomFooter,
      [parameter(Mandatory=$false)]
      [ValidateScript({$_.length -le 1000})]
      [String]
      $CustomFooterText,
      [parameter(Mandatory=$false)]
      [ValidateSet($true,$false)]
      [String]
      $SendMessageDenyNotification,
      [parameter(Mandatory=$false)]
      [ValidateScript({$_.length -le 10000})]
      [String]
      $MessageDenyNotificationText,
      [parameter(Mandatory=$false)]
      [ValidateSet($true,$false)]
      [String]
      $ShowInGroupDirectory,
      [parameter(Mandatory=$false)]
      [ValidateSet($true,$false)]
      [String]
      $AllowGoogleCommunication,
      [parameter(Mandatory=$false)]
      [ValidateSet($true,$false)]
      [String]
      $MembersCanPostAsTheGroup,
      [parameter(Mandatory=$false)]
      [ValidateSet("DEFAULT_FONT","FIXED_WIDTH_FONT")]
      [String]
      $MessageDisplayFont,
      [parameter(Mandatory=$false)]
      [ValidateSet($true,$false)]
      [String]
      $IncludeInGlobalAddressList,
      [parameter(Mandatory=$false)]
      [ValidateSet("ALL_MANAGERS_CAN_LEAVE","ALL_MEMBERS_CAN_LEAVE","NONE_CAN_LEAVE")]
      [String]
      $WhoCanLeaveGroup,
      [parameter(Mandatory=$false)]
      [ValidateSet("ALL_IN_DOMAIN_CAN_CONTACT","ALL_MANAGERS_CAN_CONTACT","ALL_MEMBERS_CAN_CONTACT","ANYONE_CAN_CONTACT")]
      [String]
      $WhoCanContactOwner,
      [parameter(Mandatory=$false)]
      [String]
      $AccessToken,
      [parameter(Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [String]
      $P12KeyPath = $Script:PSGSuite.P12KeyPath,
      [parameter(Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [String]
      $AppEmail = $Script:PSGSuite.AppEmail,
      [parameter(Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [String]
      $AdminEmail = $Script:PSGSuite.AdminEmail
    )
if (!$AccessToken)
    {
    $AccessToken = Get-GSToken -P12KeyPath $P12KeyPath -Scopes "https://www.googleapis.com/auth/apps.groups.settings" -AppEmail $AppEmail -AdminEmail $AdminEmail
    }
$header = @{
    Authorization="Bearer $AccessToken"
    }
$body = @{}
if ($Name){$body.Add("name",$Name)}
if ($Description){$body.Add("description",$Description)}
if ($WhoCanJoin){$body.Add("WhoCanJoin",$WhoCanJoin)}
if ($WhoCanViewMembership){$body.Add("whoCanViewMembership",$WhoCanViewMembership)}
if ($WhoCanViewGroup){$body.Add("whoCanViewGroup",$WhoCanViewGroup)}
if ($WhoCanInvite){$body.Add("whoCanInvite",$WhoCanInvite)}
if ($WhoCanAdd){$body.Add("whoCanAdd",$WhoCanAdd)}
if ($AllowExternalMembers -eq $true -or $AllowExternalMembers -eq $false){$body.Add("allowExternalMembers",$AllowExternalMembers.ToLower())}
if ($WhoCanPostMessage){$body.Add("whoCanPostMessage",$WhoCanPostMessage)}
if ($AllowWebPosting -eq $true -or $AllowWebPosting -eq $false){$body.Add("allowWebPosting",$AllowWebPosting.ToLower())}
if ($MaxMessageBytes){$body.Add("maxMessageBytes",$MaxMessageBytes)}
if ($IsArchived -eq $true -or $IsArchived -eq $false){$body.Add("isArchived",$IsArchived.ToLower())}
if ($ArchiveOnly -eq $true -or $ArchiveOnly -eq $false){$body.Add("archiveOnly",$ArchiveOnly.ToLower())}
if ($MessageModerationLevel){$body.Add("messageModerationLevel",$MessageModerationLevel)}
if ($SpamModerationLevel){$body.Add("spamModerationLevel",$SpamModerationLevel)}
if ($ReplyTo){$body.Add("replyTo",$ReplyTo)}
if ($CustomReplyToAddress){$body.Add("CustomReplyTo",$CustomReplyToAddress)}
if ($IncludeCustomFooter -eq $true -or $IncludeCustomFooter -eq $false){$body.Add("includeCustomFooter",$IncludeCustomFooter.ToLower())}
if ($CustomFooterText){$body.Add("customFooterText",$CustomFooterText)}
if ($SendMessageDenyNotification -eq $true -or $SendMessageDenyNotification -eq $false){$body.Add("sendMessageDenyNotification",$SendMessageDenyNotification.ToLower())}
if ($MessageDenyNotificationText){$body.Add("messageDenyNotificationText",$MessageDenyNotificationText)}
if ($ShowInGroupDirectory -eq $true -or $ShowInGroupDirectory -eq $false){$body.Add("showInGroupDirectory",$ShowInGroupDirectory.ToLower())}
if ($AllowGoogleCommunication -eq $true -or $AllowGoogleCommunication -eq $false){$body.Add("allowGoogleCommunication",$AllowGoogleCommunication.ToLower())}
if ($MembersCanPostAsTheGroup -eq $true -or $MembersCanPostAsTheGroup -eq $false){$body.Add("membersCanPostAsTheGroup",$MembersCanPostAsTheGroup.ToLower())}
if ($MessageDisplayFont){$body.Add("messageDisplayFont",$MessageDisplayFont)}
if ($IncludeInGlobalAddressList -eq $true -or $IncludeInGlobalAddressList -eq $false){$body.Add("includeInGlobalAddressList",$IncludeInGlobalAddressList.ToLower())}
if ($WhoCanLeaveGroup){$body.Add("whoCanLeaveGroup",$WhoCanLeaveGroup)}
if ($WhoCanContactOwner){$body.Add("whoCanContactOwner",$WhoCanContactOwner)}

$body = $body | ConvertTo-Json

$URI = "https://www.googleapis.com/groups/v1/groups/$Group"
try
    {
    $response = Invoke-RestMethod -Method Patch -Uri $URI -Headers $header -Body $body -ContentType "application/json"
    }
catch
    {
    try
        {
        $result = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($result)
        $reader.BaseStream.Position = 0
        $reader.DiscardBufferedData()
        $resp = $reader.ReadToEnd()
        $response = $resp | ConvertFrom-Json | 
            Select-Object @{N="Error";E={$Error[0]}},@{N="Code";E={$_.error.Code}},@{N="Message";E={$_.error.Message}},@{N="Domain";E={$_.error.errors.domain}},@{N="Reason";E={$_.error.errors.reason}}
        Write-Error "$(Get-HTTPStatus -Code $response.Code): $($response.Domain) / $($response.Message) / $($response.Reason)"
        return
        }
    catch
        {
        Write-Error $resp
        return
        }
    }
return $response
}