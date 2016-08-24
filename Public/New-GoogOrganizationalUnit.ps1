function New-GoogOrganizationalUnit {
<#
.Synopsis
   Creates a new Organizational Unit in Google Apps
.DESCRIPTION
   Creates a new Organizational Unit in Google Apps.
.EXAMPLE
   New-GoogOrganizationalUnit -AccessToken $(Get-GoogToken @TokenParams) -CustomerID $Customer -Name "Test Org" -ParentOrgUnitPath "/Testing" -Description "This is a test OrgUnit"
#>
    Param
    (
      [parameter(Mandatory=$true)]
      [String]
      $AccessToken,
      [parameter(Mandatory=$false)]
      [String]
      $CustomerID="my_customer",
      [parameter(Mandatory=$true)]
      [String]
      $Name,
      [parameter(Mandatory=$false)]
      [string]
      $ParentOrgUnitPath,
      [parameter(Mandatory=$false)]
      [String]
      $Description,
      [parameter(Mandatory=$false)]
      [switch]
      $BlockInheritance
    )

$header = @{Authorization="Bearer $AccessToken"}

$URI = "https://www.googleapis.com/admin/directory/v1/customer/$CustomerID/orgunits"

if($BlockInheritance){$Block = $true}
else{$Block = $false}

$Body = @{
    name = $Name
    blockInheritance = $Block
    parentOrgUnitPath = $ParentOrgUnitPath
    }
if($Description){$Body.description = $Description}
$Body = $Body | ConvertTo-Json

Write-Verbose "Constructed URI: $URI"

try
    {
    $response = Invoke-RestMethod -Method Post -Uri $URI -Headers $header -Body $body -ContentType "application/json"
    }
catch 
    {
    $result = $_.Exception.Response.GetResponseStream()
    $reader = New-Object System.IO.StreamReader($result)
    $reader.BaseStream.Position = 0
    $reader.DiscardBufferedData()
    $response = $reader.ReadToEnd();
    }

return $response
}