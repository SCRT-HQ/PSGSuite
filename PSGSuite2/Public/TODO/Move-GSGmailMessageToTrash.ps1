function Move-GSGmailMessageToTrash {
    <#
.Synopsis
   Trashes a Gmail message
.DESCRIPTION
   Trashes a Gmail message
.EXAMPLE
   Move-GSGmailMessageToTrash -User "user1@domain.com" -MessageID "15da93037f374213"
#>
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false)]
        [string]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $True)]
        [Alias('id')]
        [String[]]
        $MessageID,
        [parameter(Mandatory = $false)]
        [String]
        $AccessToken,
        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $P12KeyPath = $Script:PSGSuite.P12KeyPath,
        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $AppEmail = $Script:PSGSuite.AppEmail,
        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $AdminEmail = $Script:PSGSuite.AdminEmail
    )
    Begin {
        if (!$AccessToken) {
            $AccessToken = Get-GSToken -P12KeyPath $P12KeyPath -Scopes "https://mail.google.com/" -AppEmail $AppEmail -AdminEmail $User
        }
        $header = @{
            Authorization = "Bearer $AccessToken"
        }
        $response = @()
    }
    Process {
        foreach ($id in $MessageID) {
            $URI = "https://www.googleapis.com/gmail/v1/users/$User/messages/$MessageID/trash"
            try {
                if ($result = Invoke-RestMethod -Method Post -Uri $URI -Headers $header) {
                    $result.PSObject.TypeNames.Insert(0,"Google.Gmail.Message")
                    $response += $result
                }
                else {
                    Write-Warning "No response recorded!"
                }
            }
            catch {
                try {
                    $result = $_.Exception.Response.GetResponseStream()
                    $reader = New-Object System.IO.StreamReader($result)
                    $reader.BaseStream.Position = 0
                    $reader.DiscardBufferedData()
                    $resp = $reader.ReadToEnd()
                    $response = $resp | ConvertFrom-Json | 
                        Select-Object @{N = "Error";E = {$Error[0]}},@{N = "Code";E = {$_.error.Code}},@{N = "Message";E = {$_.error.Message}},@{N = "Domain";E = {$_.error.errors.domain}},@{N = "Reason";E = {$_.error.errors.reason}}
                    Write-Error "$(Get-HTTPStatus -Code $response.Code): $($response.Domain) / $($response.Message) / $($response.Reason)"
                    return
                }
                catch {
                    Write-Error $resp
                    return
                }
            }
        }
    }
    End {
    return $response
    }
}