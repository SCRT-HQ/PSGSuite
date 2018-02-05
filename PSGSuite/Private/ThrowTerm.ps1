function ThrowTerm {
    Param
    (
        [parameter(Mandatory = $true,Position = 0)]
        [String]
        $Message
    )
    New-Object System.Management.Automation.ErrorRecord(
        (New-Object Exception $Message),
        'PowerShell.Module.Error',
        [System.Management.Automation.ErrorCategory]::OperationStopped,
        $null
    )
}