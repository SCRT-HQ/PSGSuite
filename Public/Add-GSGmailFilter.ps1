function Add-GSGmailFilter {
    [cmdletbinding()]
    Param
    (
      [parameter(Mandatory=$false,Position=0)]
      [ValidateNotNullOrEmpty()]
      [string]
      $User=$Script:PSGSuite.AdminEmail,
      [parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
      [string]
      $From,
      [parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
      [string]
      $To,
      [parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
      [string]
      $Subject,
      [parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
      [string]
      $Query,
      [parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
      [string]
      $NegatedQuery,
      [parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
      [ValidateSet($true,$false,"")]
      [string]
      $HasAttachment,
      [parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
      [ValidateSet($true,$false,"")]
      [string]
      $ExcludeChats,
      [parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
      [string[]]
      $AddLabelIDs,
      [parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
      [string[]]
      $RemoveLabelIDs,
      [parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
      [string]
      $Forward,
      [parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
      [int]
      $Size,
      [parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
      [string]
      $SizeComparison,
      [parameter(Mandatory=$false)]
      [switch]
      $Raw,
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
      $AppEmail = $Script:PSGSuite.AppEmail
    )
Begin
    {
    if (!$AccessToken)
        {
        $AccessToken = Get-GSToken -P12KeyPath $P12KeyPath -Scopes "https://www.googleapis.com/auth/gmail.settings.basic" -AppEmail $AppEmail -AdminEmail $User
        }
    $header = @{
        Authorization="Bearer $AccessToken"
        }
    }
Process
    {
    $URI = "https://www.googleapis.com/gmail/v1/users/$user/settings/filters"
    if ($AddLabelIDs -or $RemoveLabelIDs -or $Forward)
        {
        $action = @{}
        if ($AddLabelIDs)
            {
            $action.Add("addLabelIds",@($AddLabelIDs))
            }
        if ($RemoveLabelIDs)
            {
            $action.Add("removeLabelIds",@($RemoveLabelIDs))
            }
        if ($Forward)
            {
            $action.Add("forward",$Forward)
            }
        }
    if ($From -or $To -or $Subject -or $Query -or $NegatedQuery -or $HasAttachment -or $ExcludeChats -or $Size -or $SizeComparison)
        {
        $criteria = @{}
        if ($From)
            {
            $criteria.Add("from",$From)
            }
        if ($To)
            {
            $criteria.Add("to",$To)
            }
        if ($Subject)
            {
            $criteria.Add("subject",$Subject)
            }
        if ($Query)
            {
            $criteria.Add("query",$Query)
            }
        if ($NegatedQuery)
            {
            $criteria.Add("negatedQuery",$NegatedQuery)
            }
        if ($HasAttachment -eq $true -or $HasAttachment -eq $false)
            {
            $criteria.Add("hasAttachment",$HasAttachment.ToLower())
            }
        if ($ExcludeChats -eq $true -or $ExcludeChats -eq $false)
            {
            $criteria.Add("excludeChats",$ExcludeChats.ToLower())
            }
        if ($Size)
            {
            $criteria.Add("size",$Size)
            }
        if ($SizeComparison)
            {
            $criteria.Add("sizeComparison",$SizeComparison)
            }
        }
    $body = [ordered]@{
        action = $action
        criteria = $criteria
        } | ConvertTo-Json -Depth 4
    try
        {
        $response = Invoke-RestMethod -Method Post -Uri $URI -Headers $header -Body $body -ContentType "application/json"
        if (!$Raw)
            {
            $response = $response | Select-Object @{N="user";E={$user}},id,@{N="from";E={$_.criteria.from}},@{N="to";E={$_.criteria.to}},@{N="subject";E={$_.criteria.subject}},@{N="query";E={$_.criteria.query}},@{N="negatedQuery";E={$_.criteria.negatedQuery}},@{N="hasAttachment";E={$_.criteria.hasAttachment}},@{N="excludeChats";E={$_.criteria.excludeChats}},@{N="size";E={$_.criteria.size}},@{N="sizeComparison";E={$_.criteria.sizeComparison}},@{N="addLabelIds";E={$_.action.addLabelIds}},@{N="removeLabelIds";E={$_.action.removeLabelIds}},@{N="forward";E={$_.action.forward}}
            }
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
    }
End
    {
    return $response
    }
}