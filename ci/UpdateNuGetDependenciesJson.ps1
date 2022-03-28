if ($items = Get-ChildItem (Resolve-Path $PSScriptRoot\..\BuildOutput\PSGSuite\*\lib\net45 -ErrorAction SilentlyContinue).Path -Filter '*.dll' |
    Where-Object {$_.BaseName -notin 'Google.Apis.Auth.PlatformServices','Google.Apis.PlatformServices'}) {
    $items |
    #Where-Object |
    Sort-Object BaseName |
    Select-Object Name,
        @{
            N = 'BaseName'
            E = {
                if ($_.BaseName -eq 'BouncyCastle.Crypto') {
                    'BouncyCastle.Crypto.dll'
                }
                else {
                    $_.BaseName
                }
            }
        },
        @{
            N='Target'
            E={
                if ($_.BaseName -match 'BouncyCastle.Crypto') {
                    '1.8.1'
                }
                elseif ($_.BaseName -match 'MimeKit') {
                    '2.0.3'
                }
                else {
                    'Latest'
                }
            }
        },
        @{
            N='LatestVersion'
            E={
                [System.Diagnostics.FileVersionInfo]::GetVersionInfo($_.FullName).ProductVersion
            }
        } |
    ConvertTo-Json |
    Set-Content (Join-Path $PSScriptRoot 'NuGetDependencies.json') -Force
}
