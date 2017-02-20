function Get-GSGroupSettings {
    [cmdletbinding()]
    Param
    (
      [parameter(Position=0,Mandatory=$true)]
      [String]
      $Group,
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
$URI = "https://www.googleapis.com/groups/v1/groups/$Group"
try
    {
    $response = Invoke-RestMethod -Method Get -Uri $URI -Headers $header -ContentType "application/json" | Select-Object -ExpandProperty entry | Select-Object @{N="kind";E={"admin#directory#group#settings"}},email,name,description,whoCanJoin,whoCanViewMembership,whoCanViewGroup,whoCanInvite,whoCanAdd,allowExternalMembers,whoCanPostMessage,allowWebPosting,maxMessageBytes,isArchived,archiveOnly,messageModerationLevel,spamModerationLevel,replyTo,customReplyTo,includeCustomFooter,customFooterText,sendMessageDenyNotification,defaultMessageDenyNotificationText,showInGroupDirectory,allowGoogleCommunication,membersCanPostAsTheGroup,messageDisplayFont,includeInGlobalAddressList,whoCanLeaveGroup,whoCanContactOwner | ForEach-Object {if($_.kind -like "*#*"){$_.PSObject.TypeNames.Insert(0,$(Convert-KindToType -Kind $_.kind));$_}else{$_}}
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