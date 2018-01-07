function Add-GSPrincipalGroupMembership {
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
            foreach ($U in $MemberOf) {
                $groupObj = Get-GSGroup -Group $U -Verbose:$false
                if ($U -notlike "*@*.*") {
                    $U = "$($U)@$($Script:PSGSuite.Domain)"
                }
                Write-Verbose "Adding '$Identity' as a $Role of group '$U'"
                $body = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.Member'
                $body.Email = $Identity
                $body.Role = $Role
                $request = $service.Members.Insert($body,$groupObj.Id)
                $request.Execute() | Select-Object @{N = "Group";E = {$U}},*
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}