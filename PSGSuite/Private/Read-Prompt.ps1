function Read-Prompt {
    [CmdletBinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0)]
        $Options,
        [parameter(Mandatory = $false)]
        [String]
        $Title = "Picky Choosy Time",
        [parameter(Mandatory = $false)]
        [String]
        $Message = "Which do you prefer?",
        [parameter(Mandatory = $false)]
        [Int]
        $Default = 0
    )
    Process {
        $opt = @()
        foreach ($option in $Options) {
            switch ($option.GetType().Name) {
                Hashtable {
                    foreach ($key in $option.Keys) {
                        $opt += New-Object System.Management.Automation.Host.ChoiceDescription "$($key)","$($option[$key])"
                    }
                }
                String {
                    $opt += New-Object System.Management.Automation.Host.ChoiceDescription "$option",$null
                }
            }
        }    
        $choices = [System.Management.Automation.Host.ChoiceDescription[]] $opt
        $answer = $host.ui.PromptForChoice($Title, $Message, $choices, $Default)
        $choices[$answer].Label -replace "&"
    }
}