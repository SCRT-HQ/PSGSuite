function Convert-StringToHash {
    Param
    (
      [parameter(Mandatory=$true,Position=0)]
      [String]
      $String,
      [parameter(Mandatory=$false,Position=1)]
      [ValidateSet("SHA-1","SHA-256","SHA-384","SHA-512","MD5","RIPEMD160")]
      [ValidateNotNullOrEmpty()]
      [String]
      $Algorithm = "SHA-1",
      [parameter(Mandatory=$false,Position=2)]
      [ValidateSet("Byte","Hexadecimal")]
      [ValidateNotNullOrEmpty()]
      [String]
      $Output = "Byte"
    )
    switch ($Algorithm) {
        "SHA-1" { $hasher = new-object System.Security.Cryptography.SHA1Managed }
        "SHA-256" { $hasher = new-object System.Security.Cryptography.SHA256Managed }
        "SHA-384" { $hasher = new-object System.Security.Cryptography.SHA384Managed }
        "SHA-512" { $hasher = new-object System.Security.Cryptography.SHA512Managed }
        "MD5" { $hasher = new-object System.Security.Cryptography.MD5CryptoServiceProvider }
        "RIPEMD160" { $hasher = new-object System.Security.Cryptography.RIPEMD160Managed }
    }
    switch ($Output) {
        "Byte" { ($hasher.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($String)) | ForEach-Object {$_.ToString()}) -join "" }
        "Hexadecimal" { ($hasher.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($String)) | ForEach-Object {$_.ToString("X2")}) -join "" }
    }
}