function Invoke-GSDecrypt {
    param($String)
    if ($String -is [System.Security.SecureString]) {
        [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR(
            [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR(
                $String
            )
        )
    }
    elseif ($String -is [ScriptBlock]) {
        $String.InvokeReturnAsIs()
    }
    else {
        $String
    }
}

Function Invoke-GSEncrypt {
    param($string)
    if ($string -is [System.String] -and -not [String]::IsNullOrEmpty($String)) {
        ConvertTo-SecureString -String $string -AsPlainText -Force
    }
    else {
        $string
    }
}
