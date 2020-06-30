function Add-GSPrincipalGroupMembership {
    <#
    .SYNOPSIS
    Adds the target email to a list of groups

    .DESCRIPTION
    Adds the target email to a list of groups. Designed for parity with Add-ADPrincipalGroupMembership

    .PARAMETER Identity
    The user or group email that you would like to add to the list of groups

    .PARAMETER MemberOf
    The list of groups to add the target email to

    .PARAMETER Role
    The role that you would like to add the members as

    Defaults to "MEMBER"

    .EXAMPLE
    Add-GSPrincipalGroupMembership "joe@domain.com" -MemberOf "admins@domain.com","users@domain.com"

    Adds the email "joe@domain.com" to the admins@ and users@ groups
    #>
    [OutputType('Google.Apis.Admin.Directory.directory_v1.Data.Member')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail","User","Email","UserEmail")]
        [String]
        $Identity,
        [parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true,Position = 1)]
        [Alias('GroupEmail','Group')]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $MemberOf,
        [parameter(Mandatory = $false)]
        [ValidateSet("MEMBER","MANAGER","OWNER")]
        [String]
        $Role = "MEMBER"
    )
    Process {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.group'
            ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        }
        $service = New-GoogleService @serviceParams
        try {
            Resolve-Email ([ref]$Identity)
            try {
                foreach ($U in $MemberOf) {
                    $groupObj = Get-GSGroup -Group $U -Verbose:$false
                    Write-Verbose "Adding '$Identity' as a $Role of group '$($groupObj.Email)'"
                    $body = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.Member'
                    $body.Email = $Identity
                    $body.Role = $Role
                    $request = $service.Members.Insert($body,$groupObj.Id)
                    $request.Execute() | Add-Member -MemberType NoteProperty -Name 'Group' -Value $groupObj.Email -PassThru
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
