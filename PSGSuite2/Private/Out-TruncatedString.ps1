function Out-TruncatedString {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $String,

        [Parameter(Position = 1)]
        [ValidateRange(0,[int32]::MaxValue)]
        [int] $Length = 0
    )

    $outString = $String

    if ($Length -gt 0) {
        if ($String.Length -gt $Length) {
            $outString = $String.Substring(0,($Length - 3)) + '...'
        }
    }

    Write-Output $outString
}