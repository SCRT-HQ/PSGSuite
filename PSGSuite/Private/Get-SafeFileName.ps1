function Get-SafeFileName {
    [CmdletBinding()]
    Param (
        [parameter(Mandatory,ValueFromPipeline,Position = 0)]
        [String]
        $Name
    )
    Process {
        $Name -replace "[$(([System.IO.Path]::GetInvalidFileNameChars() + [System.IO.Path]::GetInvalidPathChars()) -join '')]","_"
    }
}
