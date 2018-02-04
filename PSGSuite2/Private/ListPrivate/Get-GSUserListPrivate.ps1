function Get-GSUserListPrivate {
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false)]
        [Alias("Query")]
        [String[]]
        $Filter = "*",
        [parameter(Mandatory = $false)]
        [Alias("OrgUnitPath")]
        [String]
        $SearchBase = "/",
        [parameter(Mandatory = $false)]
        [ValidateSet("Base","OneLevel","Subtree")]
        [String]
        $SearchScope = "Subtree",
        [parameter(Mandatory = $false)]
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
        [ValidateRange(1,500)]
        [Alias("MaxResults")]
        [Int]
        $PageSize = "500",
        [parameter(Mandatory = $false)]
        [ValidateSet("Email","GivenName","FamilyName")]
        [String]
        $OrderBy,
        [parameter(Mandatory = $false)]
        [ValidateSet("Ascending","Descending")]
        [String]
        $SortOrder
    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.user.readonly'
            ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        try {
            $request = $service.Users.List()
            $request.Projection = $Projection
            if ($Script:PSGSuite.Preference) {
                switch ($Script:PSGSuite.Preference) {
                    Domain {
                        $request.Domain = $Script:PSGSuite.Domain
                    }
                    CustomerID {
                        $request.Customer = $Script:PSGSuite.CustomerID
                    }
                }
            }
            else {
                $request.Customer = "my_customer"
            }
            if ($PageSize) {
                $request.MaxResults = $PageSize
            }
            foreach ($prop in $PSBoundParameters.Keys | Where-Object {$_ -in @('OrderBy','SortOrder','CustomFieldMask','ShowDeleted','ViewType')}) {
                $request.$prop = $PSBoundParameters[$prop]
            }
            if ($Filter -or $SearchBase) {
                if ($Filter -eq '*') {
                    $Filter = ""
                }
                else {
                    $Filter = "$($Filter -join " ")"
                }
                if ($SearchBase) {
                    $Filter += " OrgUnitPath='$SearchBase'"
                }
                $Filter = $Filter -replace " -eq ","=" -replace " -like ",":" -replace " -match ",":" -replace " -contains ",":" -creplace "'True'","True" -creplace "'False'","False"
                $request.Query = $Filter.Trim()
                Write-Verbose "Getting Users matching filter: `"$($Filter.Trim())`""
            }
            else {
                Write-Verbose "Getting all Users"
            }
            $response = @()
            [int]$i = 1
            do {
                $result = $request.Execute()
                $response += $result.UsersValue | Select-Object @{N = "User";E = {$_.PrimaryEmail}},*
                $request.PageToken = $result.NextPageToken
                [int]$retrieved = ($i + $result.UsersValue.Count) - 1
                Write-Verbose "Retrieved $retrieved users..."
                [int]$i = $i + $result.UsersValue.Count
            }
            until (!$result.NextPageToken)
            if ($SearchScope -ne "Subtree") {
                $response = switch ($SearchScope) {
                    Base {
                        $response | Where-Object {$_.OrgUnitPath -eq $SearchBase}
                    }
                    OneLevel {
                        $maxDepth = ($SearchBase -split "/" | Where-Object {$_}).Count + 1
                        $children = $response | Select-Object -ExpandProperty OrgUnitPath -Unique | ForEach-Object {
                            if (($_ -split "/" | Where-Object {$_}).Count -le $maxDepth) {
                                $_
                            }
                        }
                        $response | Where-Object {$_.OrgUnitPath -in $children}
                    }
                }
                Write-Verbose "Total users in SearchScope: $($response.Count)"
            }
            return $response
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}