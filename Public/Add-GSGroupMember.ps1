function Add-GSGroupMember {
    [cmdletbinding()]
    Param
    (
      [parameter(Position=0,Mandatory=$true)]
      [String[]]
      $GroupEmail,
      [parameter(Mandatory=$true,ValueFromPipeline=$true)]
      [String[]]
      $UserEmail,
      [parameter(Mandatory=$false)]
      [ValidateSet("MEMBER","MANAGER","OWNER")]
      [String]
      $Role="MEMBER",
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
Begin
    {
    $response = @()
    if (!$AccessToken)
        {
        $AccessToken = Get-GSToken -P12KeyPath $P12KeyPath -Scopes "https://www.googleapis.com/auth/admin.directory.group" -AppEmail $AppEmail -AdminEmail $AdminEmail
        }
    $header = @{
        Authorization="Bearer $AccessToken"
        }
    }
Process
    {
    foreach ($Group in $GroupEmail)
        {
        foreach ($Member in $UserEmail)
            {
            Write-Verbose "Adding $Member to $Group as $Role"
            $body = @{
                email=$Member
                role=$Role
                } | ConvertTo-Json

            $URI = "https://www.googleapis.com/admin/directory/v1/groups/$Group/members"
            try
                {
                $result = Invoke-RestMethod -Method Post -Uri $URI -Headers $header -Body $body -ContentType "application/json" -Verbose:$false | ForEach-Object {if($_.kind -like "*#*"){$_.PSObject.TypeNames.Insert(0,$(Convert-KindToType -Kind $_.kind));$_}else{$_}}
                $response += $result
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
        }
    }
End
    {
    return $response
    }
}