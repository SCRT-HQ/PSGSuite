function Get-GSGroup {
    [cmdletbinding(DefaultParameterSetName = "List")]
    Param
    (
        [parameter(Mandatory = $false,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true,ParameterSetName = "Get")]
        [Alias("Email")]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Group,
        [parameter(Mandatory = $false)]
        [String[]]
        $Fields,
        [parameter(Mandatory=$false,ParameterSetName = "List")]
        [String]
        $Where_IsAMember,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [ValidateScript( {[int]$_ -le 200 -and [int]$_ -ge 1})]
        [Alias("MaxResults")]
        [Int]
        $PageSize = "200"
    )
    Begin {
        if ($PSCmdlet.ParameterSetName -eq 'Get') {
            $serviceParams = @{
                Scope       = 'https://www.googleapis.com/auth/admin.directory.group'
                ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
            }
            $service = New-GoogleService @serviceParams
        }
    }
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Get {
                    foreach ($G in $Group) {
                        if ($G -notlike "*@*.*") {
                            $G = "$($G)@$($Script:PSGSuite.Domain)"
                        }
                        Write-Verbose "Getting group '$G'"
                        $request = $service.Groups.Get($G)
                        if ($Fields) {
                            $request.Fields = "$($Fields -join ",")"
                        }
                        $request.Execute() | Select-Object @{N = "Group";E = {$_.Email}},*
                    }
                }
                List {
                    Get-GSGroupList @PSBoundParameters
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}