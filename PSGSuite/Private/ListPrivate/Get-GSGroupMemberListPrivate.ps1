function Get-GSGroupMemberListPrivate {
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias('GroupEmail','Group','Email')]
        [String]
        $Identity,
        [parameter(Mandatory = $false)]
        [ValidateSet("Owner","Manager","Member")]
        [String[]]
        $Roles,
        [parameter(Mandatory = $false)]
        [ValidateRange(1,200)]
        [Alias('MaxResults')]
        [Int]
        $PageSize = "200"
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
            $request = $service.Members.List($Identity)
            if ($PageSize) {
                $request.MaxResults = $PageSize
            }
            if ($Roles) {
                Write-Verbose "Getting all members of group '$Identity' in the following role(s): $($Roles -join ',')"
                $request.Roles = "$($Roles -join ',')"
            }
            else {
                Write-Verbose "Getting all members of group '$Identity'"
            }
            $response = @()
            [int]$i = 1
            do {
                $result = $request.Execute()
                $response += $result.MembersValue | Select-Object @{N = "Group";E = {$Identity}},*
                $request.PageToken = $result.NextPageToken
                [int]$retrieved = ($i + $result.MembersValue.Count) - 1
                Write-Verbose "Retrieved $retrieved members..."
                [int]$i = $i + $result.MembersValue.Count
            }
            until (!$result.NextPageToken)
            return $response
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}