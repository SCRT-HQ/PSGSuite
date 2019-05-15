function Resolve-Email {
    [CmdletBinding()]
    Param (
        [parameter(Mandatory,Position = 0,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [Ref[]]
        $Email
    )
    Process {
        foreach ($e in $Email) {
            if ( -not ($e.value -as [decimal])) {
                if ($e.value -ceq 'me') {
                    $e.value = $Script:PSGSuite.AdminEmail
                }
                elseif ($e.value -notlike "*@*.*") {
                    $e.value = "$($e.value)@$($Script:PSGSuite.Domain)"
                }
            }
        }
    }
}
