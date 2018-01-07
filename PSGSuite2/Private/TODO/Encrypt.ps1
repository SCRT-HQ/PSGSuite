function Encrypt {
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
    Write-Verbose "Encrypting string"
    $String | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString -Key $Bytes
}