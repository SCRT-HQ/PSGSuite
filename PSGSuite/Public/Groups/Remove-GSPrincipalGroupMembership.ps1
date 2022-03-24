function Remove-GSPrincipalGroupMembership {
    <#
    .SYNOPSIS
    Removes the target member from a group or list of groups

    .DESCRIPTION
    Removes the target member from a group or list of groups

    .PARAMETER Identity
    The email or unique Id of the member you would like to remove from the group(s)

    .PARAMETER MemberOf
    The group(s) to remove the member from

    .EXAMPLE
    Remove-GSPrincipalGroupMembership -Identity 'joe.smith' -MemberOf admins,test_pool

    Removes Joe Smith from the groups admins@domain.com and test_pool@domain.com
    #>
    [cmdletbinding(SupportsShouldProcess = $true,ConfirmImpact = "High")]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail","User","UserEmail")]
        [String]
        $Identity,
        [parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true,Position = 1)]
        [Alias('GroupEmail','Group','Email')]
        [String[]]
        $MemberOf
    )
    Process {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.group'
            ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        }
        $service = New-GoogleService @serviceParams
        Resolve-Email ([ref]$Identity)
        foreach ($G in $MemberOf) {
            try {
                Resolve-Email ([ref]$G) -IsGroup
                if ($PSCmdlet.ShouldProcess("Removing member '$Identity' from group '$G'")) {
                    Write-Verbose "Removing member '$Identity' from group '$G'"
                    $request = $service.Members.Delete($G,$Identity)
                    $request.Execute()
                    Write-Verbose "Member '$Identity' has been successfully removed from group '$G'"
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
}
