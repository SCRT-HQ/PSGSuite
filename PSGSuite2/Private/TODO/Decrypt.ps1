function Decrypt {
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipeline = $true)]
        [String]
        $String,
        [parameter(Mandatory = $false)]
        [Byte[]]
        $Bytes = @(1..32)
    )
    try {
        Write-Verbose "Attempting to decrypt string"
        [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR((ConvertTo-SecureString $String -Key $Bytes)))
    }
    catch {
        Write-Verbose "Input string was not in correct format, returning input string"
        $String
    }
}