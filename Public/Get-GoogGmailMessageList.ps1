function Get-GoogGmailMessageList {
    [cmdletbinding(DefaultParameterSetName='InternalToken')]
    Param
    (
      [parameter(Mandatory=$false)]
      [string]
      $User=$Script:PSGoogle.AdminEmail,
      [parameter(Mandatory=$false)]
      [String[]]
      $LabelID,
      [parameter(Mandatory=$false)]
      [switch]
      $ExcludeChats,
      [parameter(Mandatory=$false)]
      [switch]
      $IncludeSpamTrash,
      [parameter(Mandatory=$false)]
      [String[]]
      $Query,
      [parameter(Mandatory=$false)]
      [ValidateScript({if([int]$_ -le 500){$true}else{throw "PageSize must be 500 or less!"}})]
      [Int]
      $PageSize="500",
      [parameter(ParameterSetName='ExternalToken',Mandatory=$false)]
      [String]
      $AccessToken,
      [parameter(ParameterSetName='InternalToken',Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [String]
      $P12KeyPath = $Script:PSGoogle.P12KeyPath,
      [parameter(ParameterSetName='InternalToken',Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [String]
      $AppEmail = $Script:PSGoogle.AppEmail
    )
if (!$AccessToken)
    {
    $AccessToken = Get-GoogToken -P12KeyPath $P12KeyPath -Scopes "https://mail.google.com/" -AppEmail $AppEmail -AdminEmail $User
    }
$header = @{
    Authorization="Bearer $AccessToken"
    }
$URI = "https://www.googleapis.com/gmail/v1/users/$user/messages?maxResults=$PageSize"

if ($IncludeSpamTrash){$URI = "$URI&includeSpamTrash=$true"}
else {$URI = "$URI&includeSpamTrash=$false"}
if ($LabelID){$LabelID | % {$URI = "$URI&labelIds=$_"}}
if ($ExcludeChats){if($Query){$Query+="-in:chats"}else{$Query="-in:chats"}}
if ($Query)
    {
    $Query = $Query -join " "
    $URI = "$URI&q=$Query"
    }
try
    {
    Write-Verbose "Constructed URI: $URI"
    $response = @()
    [int]$i=1
    do
        {
        if ($i -eq 1)
            {
            $result = Invoke-RestMethod -Method Get -Uri $URI -Headers $header -Verbose:$false
            }
        else
            {
            $result = Invoke-RestMethod -Method Get -Uri "$URI&pageToken=$pageToken" -Headers $header -Verbose:$false
            }
        $response += $result.messages
        $returnSize = $result.messages.Count
        $pageToken="$($result.nextPageToken)"
        [int]$retrieved = ($i + $result.messages.Count) - 1
        Write-Verbose "Retrieved $retrieved messages..."
        [int]$i = $i + $result.messages.Count
        }
    until 
        ($returnSize -lt $PageSize)
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