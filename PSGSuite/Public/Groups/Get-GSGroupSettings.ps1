function Get-GSGroupSettings {
    <#
    .SYNOPSIS
    Gets a group's settings
    
    .DESCRIPTION
    Gets a group's settings
    
    .PARAMETER Identity
    The email of the group

    If only the email name-part is passed, the full email will be contstructed using the Domain from the active config
    
    .EXAMPLE
    Get-GSGroupSettings admins

    Gets the group settings for admins@domain.com
    #>
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
            if ($ErrorActionPreference -eq 'Stop') {
                $PSCmdlet.ThrowTerminatingError($_)
            }
            else {
                Write-Error $_
            }
        }
    }
}