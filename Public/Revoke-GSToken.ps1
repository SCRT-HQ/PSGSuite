function Revoke-GSToken {
    Param
    (
    [parameter(Mandatory=$true)]
    [String[]]
    $AccessToken
    )
$total = $AccessToken.Length
$i=0
foreach ($Token in $AccessToken)
    {
    $i++
    try
        {
        Write-Verbose "Revoking token $i / $total - $Token"
        $response = Invoke-RestMethod -Method Get -Uri "https://accounts.google.com/o/oauth2/revoke?token=$Token" -ErrorAction Stop -Verbose:$false
        Write-Verbose "Token revoked!"
        }
    catch
        {
        Write-Error "Failed to revoke token! Token may already be revoked."
        return
        }
    }
return $response
}