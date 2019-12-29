function Resolve-Email {
    [CmdletBinding()]
    Param (
        [parameter(Mandatory,Position = 0,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [Ref[]]
        $Email,
        [parameter()]
        [Switch]
        $IsGroup
    )
    Process {
        foreach ($e in $Email) {
            if (-not $IsGroup -and -not ($e.value -as [decimal])) {
                if ($e.value -ceq 'me') {
                    $e.value = $Script:PSGSuite.AdminEmail
                }
                elseif ($e.value -notlike "*@*.*") {
                    $e.value = "$($e.value)@$($Script:PSGSuite.Domain)"
                }
            }
            elseif ($IsGroup -and $e.value -cnotmatch '^([\w.%+-]+@[a-zA-Z\d.-]+\.[a-zA-Z]{2,}|\d{2}[a-z\d]{13})$') {
                $e.value = "$($e.value)@$($Script:PSGSuite.Domain)"
            }
        }
    }
}
