function Test-GSGroupMembership {
    <#
    .SYNOPSIS
    Checks if a Group has a specific member

    .DESCRIPTION
    Checks if a Group has a specific member

    .PARAMETER Identity
    The email of the group

    If only the email name-part is passed, the full email will be contstructed using the Domain from the active config

    .PARAMETER Member
    The user to confirm as a member of the Group

    .EXAMPLE
    Test-GSGroupMembership -Identity admins@domain.com -Member john@domain.com

    Tests if john@domain.com is a member of admins@domain.com
    #>
    [OutputType('Google.Apis.Admin.Directory.directory_v1.Data.MembersHasMember')]
    [cmdletbinding()]
    Param (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias('GroupEmail','Group','Email')]
        [String]
        $Identity,
        [parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true,Position = 1)]
        [Alias("PrimaryEmail","UserKey","Mail","User","UserEmail","Members")]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Member
    )
    Process {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.group'
            ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        }
        $service = New-GoogleService @serviceParams
        Resolve-Email ([ref]$Identity) -IsGroup
        foreach ($mem in $Member) {
            try {
                Resolve-Email ([ref]$mem)
                Write-Verbose "Checking if group '$Identity' has member '$mem'"
                $request = $service.Members.HasMember($Identity,$mem)
                $request.Execute() | Add-Member -MemberType NoteProperty -Name 'Group' -Value $Identity -Force -PassThru | Add-Member -MemberType NoteProperty -Name 'Member' -Value $mem -Force -PassThru
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
}
