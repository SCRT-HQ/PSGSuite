function Get-GSGroupSettings {
    <#
    .SYNOPSIS
    Gets a group's settings

    .DESCRIPTION
    Gets a group's settings

    .PARAMETER Identity
    The email or unique ID of the group.

    If only the email name-part is passed, the full email will be contstructed using the Domain from the active config

    .EXAMPLE
    Get-GSGroupSettings admins

    Gets the group settings for admins@domain.com
    #>
    [OutputType('Google.Apis.Groupssettings.v1.Data.Groups')]
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
                Resolve-Email ([ref]$G) -IsGroup
                if ($G -notmatch '^[\w.%+-]+@[a-zA-Z\d.-]+\.[a-zA-Z]{2,}$') {
                    Write-Verbose "Getting Group Email for ID '$G' as the Group Settings API only accepts Group Email addresses."
                    $G = Get-GSGroup -Identity $G -Verbose:$false | Select-Object -ExpandProperty Email
                }
                Write-Verbose "Getting settings for group '$G'"
                $request = $service.Groups.Get($G)
                $request.Alt = "Json"
                $request.Execute() | Add-Member -MemberType NoteProperty -Name 'Group' -Value $G -PassThru
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
