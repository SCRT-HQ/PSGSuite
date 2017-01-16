function Get-GSGmailMessageInfo {
    [cmdletbinding()]
    Param
    (
      [parameter(Mandatory=$false)]
      [string]
      $User=$Script:PSGSuite.AdminEmail,
      [parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$True)]
      [Alias('id')]
      [String[]]
      $MessageID,
      [parameter(Mandatory=$false)]
      [ValidateSet("Full","Metadata","Minimal","Raw")]
      [string]
      $Format="Full",
      [parameter(Mandatory=$false)]
      [switch]
      $HighLevelView,
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
        $AccessToken = Get-GSToken -P12KeyPath $P12KeyPath -Scopes "https://mail.google.com/" -AppEmail $AppEmail -AdminEmail $User
        }
    $header = @{
        Authorization="Bearer $AccessToken"
        }
    $response = @()
    }
Process
    {
    $URI = "https://www.googleapis.com/gmail/v1/users/$User/messages/$($MessageID)?format=$Format"
    try
        {
        $result = Invoke-RestMethod -Method Get -Uri $URI -Headers $header
        if ($HighLevelView)
            {
            $bodyParts = $result.payload.parts | % {ConvertFrom-Base64String -Base64String $($_.body.data) -FromWebSafeBase64}
            $tempObj = New-Object psobject
            $tempObj | Add-Member -MemberType NoteProperty -Name id -Value $result.id -Force -ErrorAction SilentlyContinue
            $tempObj | Add-Member -MemberType NoteProperty -Name threadId -Value $result.threadId -Force -ErrorAction SilentlyContinue
            $tempObj | Add-Member -MemberType NoteProperty -Name labelIds -Value $($result.labelIds -join ", ") -Force -ErrorAction SilentlyContinue
            $tempObj | Add-Member -MemberType NoteProperty -Name snippet -Value $result.snippet -Force -ErrorAction SilentlyContinue
            $tempObj | Add-Member -MemberType NoteProperty -Name internalDate -Value $(Convert-EpochToDate -EpochString $result.internalDate -UnitOfTime Milliseconds | Select-Object -ExpandProperty Converted) -Force -ErrorAction SilentlyContinue
            $tempObj | Add-Member -MemberType NoteProperty -Name sizeEstimate -Value $result.sizeEstimate -Force -ErrorAction SilentlyContinue
            $result.payload.headers | ForEach-Object {$tempObj | Add-Member -MemberType NoteProperty -Name $_.name -Value $_.value -Force} -ErrorAction SilentlyContinue
            $tempObj | Add-Member -MemberType NoteProperty -Name BodyNonHtml -Value $(($bodyParts | ? {$_ -notlike "<html>*"}) -join "`n`n") -Force -ErrorAction SilentlyContinue
            $tempObj | Add-Member -MemberType NoteProperty -Name BodyHtml -Value $(($bodyParts | ? {$_ -like "<html>*"}) -join "`n`n") -Force -ErrorAction SilentlyContinue
            $tempObj | Add-Member -MemberType NoteProperty -Name BodyRaw -Value $($bodyParts -join "`n`n") -Force -ErrorAction SilentlyContinue
            $response += $tempObj
            }
        else
            {
            $response += $result
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