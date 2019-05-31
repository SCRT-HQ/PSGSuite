function Get-GSMobileDevice {
    <#
    .SYNOPSIS
    Gets the list of Mobile Devices registered for the user's account

    .DESCRIPTION
    Gets the list of Mobile Devices registered for the user's account

    .PARAMETER User
    The user that you would like to retrieve the Mobile Device list for. If no user is specified, it will list all of the Mobile Devices of the CustomerID

    .PARAMETER Filter
    Search string in the format given at: http://support.google.com/a/bin/answer.py?hl=en&answer=1408863#search

    .PARAMETER Projection
    Restrict information returned to a set of selected fields.

    Acceptable values are:
    * "BASIC": Includes only the basic metadata fields (e.g., deviceId, model, status, type, and status)
    * "FULL": Includes all metadata fields

    Defauls to "FULL"

    .PARAMETER PageSize
    Page size of the result set

    .PARAMETER Limit
    The maximum amount of results you want returned. Exclude or set to 0 to return all results

    .PARAMETER OrderBy
    Device property to use for sorting results.

    Acceptable values are:
    * "deviceId": The serial number for a Google Sync mobile device. For Android devices, this is a software generated unique identifier.
    * "email": The device owner's email address.
    * "lastSync": Last policy settings sync date time of the device.
    * "model": The mobile device's model.
    * "name": The device owner's user name.
    * "os": The device's operating system.
    * "status": The device status.
    * "type": Type of the device.

    .PARAMETER SortOrder
    Whether to return results in ascending or descending order. Must be used with the OrderBy parameter.

    Acceptable values are:
    * "ASCENDING": Ascending order.
    * "DESCENDING": Descending order.

    .EXAMPLE
    Get-GSMobileDevice

    Gets the Mobile Device list for the AdminEmail
    #>
    [OutputType('Google.Apis.Admin.Directory.directory_v1.Data.MobileDevice')]
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
        [ValidateRange(1,1000)]
        [Int]
        $PageSize = 1000,
        [parameter(Mandatory = $false)]
        [Alias('First')]
        [Int]
        $Limit = 0,
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
        $customerId = if ($Script:PSGSuite.CustomerID) {
            $Script:PSGSuite.CustomerID
        }
        else {
            "my_customer"
        }
    }
    Process {
        try {
            $request = $service.Mobiledevices.List($customerId)
            if ($Limit -gt 0 -and $PageSize -gt $Limit) {
                Write-Verbose ("Reducing PageSize from {0} to {1} to meet limit with first page" -f $PageSize,$Limit)
                $PageSize = $Limit
            }
            $request.MaxResults = $PageSize
            [int]$i = 1
            $overLimit = $false
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
                            do {
                                $result = $request.Execute()
                                $result.Mobiledevices
                                if ($result.NextPageToken) {
                                    $request.PageToken = $result.NextPageToken
                                }
                                [int]$retrieved = ($i + $result.Mobiledevices.Count) - 1
                                Write-Verbose "Retrieved $retrieved Mobile Devices..."
                                if ($Limit -gt 0 -and $retrieved -eq $Limit) {
                                    Write-Verbose "Limit reached: $Limit"
                                    $overLimit = $true
                                }
                                elseif ($Limit -gt 0 -and ($retrieved + $PageSize) -gt $Limit) {
                                    $newPS = $Limit - $retrieved
                                    Write-Verbose ("Reducing PageSize from {0} to {1} to meet limit with next page" -f $PageSize,$newPS)
                                    $request.MaxResults = $newPS
                                }
                                [int]$i = $i + $result.Mobiledevices.Count
                            }
                            until ($overLimit -or !$result.NextPageToken)
                        }
                    }
                    else {
                        Write-Verbose "Getting Mobile Device list for customer '$($script:PSGSuite.CustomerID)'"
                        do {
                            $result = $request.Execute()
                            $result.Mobiledevices
                            if ($result.NextPageToken) {
                                $request.PageToken = $result.NextPageToken
                            }
                            [int]$retrieved = ($i + $result.Mobiledevices.Count) - 1
                            Write-Verbose "Retrieved $retrieved Mobile Devices..."
                            if ($Limit -gt 0 -and $retrieved -eq $Limit) {
                                Write-Verbose "Limit reached: $Limit"
                                $overLimit = $true
                            }
                            elseif ($Limit -gt 0 -and ($retrieved + $PageSize) -gt $Limit) {
                                $newPS = $Limit - $retrieved
                                Write-Verbose ("Reducing PageSize from {0} to {1} to meet limit with next page" -f $PageSize,$newPS)
                                $request.MaxResults = $newPS
                            }
                            [int]$i = $i + $result.Mobiledevices.Count
                        }
                        until ($overLimit -or !$result.NextPageToken)
                    }
                }
                Query {
                    $request.Query = $Filter
                    Write-Verbose "Getting Mobile Device list for filter '$Filter'"
                    do {
                        $result = $request.Execute()
                        $result.Mobiledevices
                        if ($result.NextPageToken) {
                            $request.PageToken = $result.NextPageToken
                        }
                        [int]$retrieved = ($i + $result.Mobiledevices.Count) - 1
                        Write-Verbose "Retrieved $retrieved Mobile Devices..."
                        if ($Limit -gt 0 -and $retrieved -eq $Limit) {
                            Write-Verbose "Limit reached: $Limit"
                            $overLimit = $true
                        }
                        elseif ($Limit -gt 0 -and ($retrieved + $PageSize) -gt $Limit) {
                            $newPS = $Limit - $retrieved
                            Write-Verbose ("Reducing PageSize from {0} to {1} to meet limit with next page" -f $PageSize,$newPS)
                            $request.MaxResults = $newPS
                        }
                        [int]$i = $i + $result.Mobiledevices.Count
                    }
                    until ($overLimit -or !$result.NextPageToken)
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
