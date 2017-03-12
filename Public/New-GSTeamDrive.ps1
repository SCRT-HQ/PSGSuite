function New-GSTeamDrive {
    [cmdletbinding()]
    Param
    (
      [parameter(Mandatory=$false,Position=0)]
      [ValidateNotNullOrEmpty()]
      [String]
      $Owner = $Script:PSGSuite.AdminEmail,
      [parameter(Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [String]
      $RequestID=$((New-Guid).Guid),
      [parameter(Mandatory=$true)]
      [String]
      $Name,
      [parameter(Mandatory=$false)]
      [ValidateSet($true,$false)]
      [String]
      $CanAddChildren,
      [parameter(Mandatory=$false)]
      [ValidateSet($true,$false)]
      [String]
      $CanComment,
      [parameter(Mandatory=$false)]
      [ValidateSet($true,$false)]
      [String]
      $CanCopy,
      [parameter(Mandatory=$false)]
      [ValidateSet($true,$false)]
      [String]
      $CanDeleteTeamDrive,
      [parameter(Mandatory=$false)]
      [ValidateSet($true,$false)]
      [String]
      $CanDownload,
      [parameter(Mandatory=$false)]
      [ValidateSet($true,$false)]
      [String]
      $CanEdit,
      [parameter(Mandatory=$false)]
      [ValidateSet($true,$false)]
      [String]
      $CanListChildren,
      [parameter(Mandatory=$false)]
      [ValidateSet($true,$false)]
      [String]
      $CanManageMembers,
      [parameter(Mandatory=$false)]
      [ValidateSet($true,$false)]
      [String]
      $CanReadRevisions,
      [parameter(Mandatory=$false)]
      [ValidateSet($true,$false)]
      [String]
      $CanRemoveChildren,
      [parameter(Mandatory=$false)]
      [ValidateSet($true,$false)]
      [String]
      $CanRename,
      [parameter(Mandatory=$false)]
      [ValidateSet($true,$false)]
      [String]
      $CanRenameTeamDrive,
      [parameter(Mandatory=$false)]
      [ValidateSet($true,$false)]
      [String]
      $CanShare,
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
if (!$AccessToken)
    {
    $AccessToken = Get-GSToken -P12KeyPath $P12KeyPath -Scopes "https://www.googleapis.com/auth/drive" -AppEmail $AppEmail -AdminEmail $Owner
    }
$header = @{
    Authorization="Bearer $AccessToken"
    }
$body = @{
    name = "$Name"
    capabilities = @{}
    }
if($CanAddChildren -eq $true -or $CanAddChildren -eq $false){$body["capabilities"].Add("canAddChildren",$CanAddChildren)}
if($CanComment -eq $true -or $CanComment -eq $false){$body["capabilities"].Add("canComment",$CanComment)}
if($CanCopy -eq $true -or $CanCopy -eq $false){$body["capabilities"].Add("canCopy",$CanCopy)}
if($CanDeleteTeamDrive -eq $true -or $CanDeleteTeamDrive -eq $false){$body["capabilities"].Add("canDeleteTeamDrive",$CanDeleteTeamDrive)}
if($CanDownload -eq $true -or $CanDownload -eq $false){$body["capabilities"].Add("canDownload",$CanDownload)}
if($CanEdit -eq $true -or $CanEdit -eq $false){$body["capabilities"].Add("canEdit",$CanEdit)}
if($CanListChildren -eq $true -or $CanListChildren -eq $false){$body["capabilities"].Add("CanListChildren",$CanListChildren)}
if($CanManageMembers -eq $true -or $CanManageMembers -eq $false){$body["capabilities"].Add("canManageMembers",$CanManageMembers)}
if($CanReadRevisions -eq $true -or $CanReadRevisions -eq $false){$body["capabilities"].Add("canReadRevisions",$CanReadRevisions)}
if($CanRemoveChildren -eq $true -or $CanRemoveChildren -eq $false){$body["capabilities"].Add("canRemoveChildren",$CanRemoveChildren)}
if($CanRename -eq $true -or $CanRename -eq $false){$body["capabilities"].Add("canRename",$CanRename)}
if($CanRenameTeamDrive -eq $true -or $CanRenameTeamDrive -eq $false){$body["capabilities"].Add("canRenameTeamDrive",$CanRenameTeamDrive)}
if($CanShare -eq $true -or $CanShare -eq $false){$body["capabilities"].Add("canShare",$CanShare)}

$body = $body | ConvertTo-Json
$URI = "https://www.googleapis.com/drive/v3/teamdrives?requestId=$RequestID"
try
    {
    $response = Invoke-RestMethod -Method Post -Uri $URI -Headers $header -Body $body -ContentType "application/json" | ForEach-Object {if($_.kind -like "*#*"){$_.PSObject.TypeNames.Insert(0,$(Convert-KindToType -Kind $_.kind));$_}else{$_}}
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