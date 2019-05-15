if ($items = Get-ChildItem (Resolve-Path $PSScriptRoot\..\BuildOutput\PSGSuite\*\lib\net45 -ErrorAction SilentlyContinue).Path -Filter '*.dll') {
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
                if ($_.BaseName -match 'Google') {
                    'Latest'
                }
                else {
                    switch ($_.BaseName) {
                        'BouncyCastle.Crypto' {
                            '1.8.1'
                        }
                        'MimeKit' {
                            '1.10.1.0'
                        }
                        'Newtonsoft.Json' {
                            '10.0.3'
                        }
                    }
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
