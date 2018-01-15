function Get-GSMobileDeviceList {
    [cmdletbinding(DefaultParameterSetName = "User")]
    Param
    (
        [parameter(Mandatory = $false,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true,ParameterSetName = "User")]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $User,
        [parameter(Mandatory = $false,ParameterSetName = "Query",Position = 0)]
        [Alias('Query')]
        [String]
        $Filter,
        [parameter(Mandatory = $false)]
        [ValidateSet("BASIC","FULL")]
        [String]
        $Projection = "FULL",
        [parameter(Mandatory = $false)]
        [ValidateScript( {[int]$_ -le 1000 -and [int]$_ -ge 1})]
        [Int]
        $PageSize = "1000",
        [parameter(Mandatory = $false)]
        [ValidateSet("deviceId","email","lastSync","model","name","os","status","type")]
        [String]
        $OrderBy,
        [parameter(Mandatory = $false)]
        [ValidateSet("Ascending","Descending")]
        [String]
        $SortOrder
    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.device.mobile'
            ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        try {
            $request = $service.Mobiledevices.List($Script:PSGSuite.CustomerID)
            switch ($PSCmdlet.ParameterSetName) {
                User {
                    if ($User) {
                        foreach ($U in $User) {
                            if ($U -ceq 'me') {
                                $U = $Script:PSGSuite.AdminEmail
                            }
                            elseif ($U -notlike "*@*.*") {
                                $U = "$($U)@$($Script:PSGSuite.Domain)"
                            }
                            $Filter = "email:`"$U`""
                            $request.Query = $Filter
                            Write-Verbose "Getting Mobile Device list for User '$U'"
                            $response = @()
                            [int]$i = 1
                            do {
                                $result = $request.Execute()
                                $response += $result.Mobiledevices
                                if ($result.NextPageToken) {
                                    $request.PageToken = $result.NextPageToken
                                }
                                [int]$retrieved = ($i + $result.Mobiledevices.Count) - 1
                                Write-Verbose "Retrieved $retrieved Mobile Devices..."
                                [int]$i = $i + $result.Mobiledevices.Count
                            }
                            until (!$result.NextPageToken)
                            return $response
                        }
                    }
                    else {
                        Write-Verbose "Getting Mobile Device list for customer"
                        $response = @()
                        [int]$i = 1
                        do {
                            $result = $request.Execute()
                            $response += $result.Mobiledevices
                            if ($result.NextPageToken) {
                                $request.PageToken = $result.NextPageToken
                            }
                            [int]$retrieved = ($i + $result.Mobiledevices.Count) - 1
                            Write-Verbose "Retrieved $retrieved Mobile Devices..."
                            [int]$i = $i + $result.Mobiledevices.Count
                        }
                        until (!$result.NextPageToken)
                        return $response
                    }
                }
                Query {
                    $request.Query = $Filter
                    Write-Verbose "Getting Mobile Device list for filter '$Filter'"
                    $response = @()
                    [int]$i = 1
                    do {
                        $result = $request.Execute()
                        $response += $result.Mobiledevices
                        if ($result.NextPageToken) {
                            $request.PageToken = $result.NextPageToken
                        }
                        [int]$retrieved = ($i + $result.Mobiledevices.Count) - 1
                        Write-Verbose "Retrieved $retrieved Mobile Devices..."
                        [int]$i = $i + $result.Mobiledevices.Count
                    }
                    until (!$result.NextPageToken)
                    return $response
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}