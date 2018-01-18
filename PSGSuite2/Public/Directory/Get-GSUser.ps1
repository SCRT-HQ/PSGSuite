function Get-GSUser {
    [cmdletbinding(DefaultParameterSetName = "Get")]
    Param
    (
        [parameter(Mandatory = $false,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true,ParameterSetName = "Get")]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [Alias("Query")]
        [String[]]
        $Filter,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [Alias("OrgUnitPath")]
        [String]
        $SearchBase,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [ValidateSet("Base","OneLevel","Subtree")]
        [String]
        $SearchScope,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [Switch]
        $ShowDeleted,
        [parameter(Mandatory = $false)]
        [ValidateSet("Basic","Custom","Full")]
        [string]
        $Projection = "Full",
        [parameter(Mandatory = $false)]
        [String]
        $CustomFieldMask,
        [parameter(Mandatory = $false)]
        [ValidateSet("Admin_View","Domain_Public")]
        [String]
        $ViewType = "Admin_View",
        [parameter(Mandatory = $false)]
        [String[]]
        $Fields,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [ValidateScript( {[int]$_ -le 500 -and [int]$_ -ge 1})]
        [Alias("MaxResults")]
        [Int]
        $PageSize = "500",
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [ValidateSet("Email","GivenName","FamilyName")]
        [String]
        $OrderBy,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [ValidateSet("Ascending","Descending")]
        [String]
        $SortOrder
    )
    Begin {
        if ($PSCmdlet.ParameterSetName -eq 'Get') {
            $serviceParams = @{
                Scope       = 'https://www.googleapis.com/auth/admin.directory.user.readonly'
                ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
            }
            $service = New-GoogleService @serviceParams
        }
    }
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Get {
                    foreach ($U in $User) {
                        if ($U -ceq 'me') {
                            $U = $Script:PSGSuite.AdminEmail
                        }
                        elseif ($U -notlike "*@*.*") {
                            $U = "$($U)@$($Script:PSGSuite.Domain)"
                        }
                        Write-Verbose "Getting User '$U'"
                        $request = $service.Users.Get($U)
                        $request.Projection = $Projection
                        $request.ViewType = ($ViewType -replace '_','')
                        if ($CustomFieldMask) {
                            $request.CustomFieldMask = $CustomFieldMask
                        }
                        if ($Fields) {
                            $request.Fields = "$($Fields -join ",")"
                        }
                        $request.Execute() | Select-Object @{N = "User";E = {$_.PrimaryEmail}},*
                    }
                }
                List {
                    Get-GSUserList @PSBoundParameters
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}