function Get-GSGmailDelegates {
    [cmdletbinding()]
    Param
    (
      [parameter(Mandatory=$false,Position=0)]
      [Alias("Delegator")]
      [ValidateNotNullOrEmpty()]
      [String]
      $User = $Script:PSGSuite.AdminEmail,
      [parameter(Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [string]
      $Domain = $Script:PSGSuite.Domain,
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
      $AppEmail = $Script:PSGSuite.AppEmail,
      [parameter(Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [string]
      $AdminEmail=$Script:PSGSuite.AdminEmail
    )
if (!$AccessToken)
    {
    $AccessToken = Get-GSToken -P12KeyPath $P12KeyPath -Scopes "https://apps-apis.google.com/a/feeds/emailsettings/2.0/" -AppEmail $AppEmail -AdminEmail $AdminEmail
    }
$header = @{
    Authorization="Bearer $AccessToken"
    }
$URI = "https://apps-apis.google.com/a/feeds/emailsettings/2.0/$Domain/$($User -replace "@$Domain",'')/delegation"
try
    {
    $response = Invoke-RestMethod -Method Get -Uri $URI -Headers $header -ContentType "application/atom+xml"
    if (!$response)
        {
        Write-Warning "No delegates found for user '$User'"
        }
    elseif (!$Raw)
        {
        $result = @()
        foreach ($dele in $response)
            {
            $deleObj = New-Object psobject
            $deleObj | Add-Member -MemberType NoteProperty -Name delegator -Value $User
            for ($i=0;$i -lt $dele.property.length;$i++)
                {
                $deleObj | Add-Member -MemberType NoteProperty -Name $dele.property[$i].name -Value $dele.property[$i].value
                }
            $result += $deleObj | ForEach-Object {if($_.kind -like "*#*"){$_.PSObject.TypeNames.Insert(0,$(Convert-KindToType -Kind $_.kind));$_}else{$_}}
            Remove-Variable deleObj -ErrorAction SilentlyContinue
            }
        return $result
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
return $response
}