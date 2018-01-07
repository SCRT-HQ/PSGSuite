function Add-GSGroupMember {
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