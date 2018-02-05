function Add-GSGroupMember {
    <#
    .SYNOPSIS
    Adds a list of emails to a target group
    
    .DESCRIPTION
    Adds a list of emails to a target group. Designed for parity with Add-ADGroupMember
    
    .PARAMETER Identity
    The email or GroupID of the target group to add members to
    
    .PARAMETER Member
    The list of user and/or group emails that you would like to add to the target group
    
    .PARAMETER Role
    The role that you would like to add the members as
    
    Defaults to "MEMBER"
    
    .EXAMPLE
    Add-GSGroupMember "admins@domain.com" -Member "joe-admin@domain.com","sally.admin@domain.com"

    Adds 2 users to the group "admins@domain.com"
    #>
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias('GroupEmail','Group','Email')]
        [String]
        $Identity,
        [parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true,Position = 1)]
        [Alias("PrimaryEmail","UserKey","Mail","User","UserEmail")]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Member,
        [parameter(Mandatory = $false)]
        [ValidateSet("MEMBER","MANAGER","OWNER")]
        [String]
        $Role = "MEMBER"
    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.group'
            ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        try {
            if ($Identity -notlike "*@*.*") {
                $Identity = "$($Identity)@$($Script:PSGSuite.Domain)"
            }
            $groupObj = Get-GSGroup -Group $Identity -Verbose:$false
            foreach ($U in $Member) {
                if ($U -notlike "*@*.*") {
                    $U = "$($U)@$($Script:PSGSuite.Domain)"
                }
                Write-Verbose "Adding '$U' as a $Role of group '$Identity'"
                $body = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.Member'
                $body.Email = $U
                $body.Role = $Role
                $request = $service.Members.Insert($body,$groupObj.Id)
                $request.Execute() | Select-Object @{N = "Group";E = {$Identity}},*
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}