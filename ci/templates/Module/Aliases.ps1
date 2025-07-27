Param(
    [parameter(mandatory=$true)]$SourceDirectory
)

$aliasHashContents = (Get-Content (Join-Path $SourceDirectory "PSGSuite" "Aliases" "PSGSuite.Aliases.ps1") -Raw).Trim()

@"
`$aliasHash = $aliasHashContents

foreach (`$key in `$aliasHash.Keys) {
    try {
        New-Alias -Name `$key -Value `$aliasHash[`$key] -Force
    }
    catch {
        Write-Error "[ALIAS: `$(`$key)] `$(`$_.Exception.Message.ToString())"
    }
}

Export-ModuleMember -Alias '*'
"@