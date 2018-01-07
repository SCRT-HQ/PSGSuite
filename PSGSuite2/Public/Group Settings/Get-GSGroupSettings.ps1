function Get-GSGroupSettings {
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias('GroupEmail','Group','Email')]
        [String[]]
        $Identity
    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/apps.groups.settings'
            ServiceType = 'Google.Apis.Groupssettings.v1.GroupssettingsService'
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        try {
            foreach ($G in $Identity) {
                if ($G -notlike "*@*.*") {
                    $G = "$($G)@$($Script:PSGSuite.Domain)"
                }
                Write-Verbose "Getting settings for group '$G'"
                $request = $service.Groups.Get($G)
                $request.Alt = "Json"
                $request.Execute() | Select-Object @{N = "Group";E = {$G}},*
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}