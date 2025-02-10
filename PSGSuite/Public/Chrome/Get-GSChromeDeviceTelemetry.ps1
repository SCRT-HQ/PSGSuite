Function Get-GSChromeDeviceTelemetry {
    <#
    .SYNOPSIS
    Gets a list of telemetry records for managed Chrome devices.
    .DESCRIPTION
    Gets a list of telemetry records for managed Chrome devices.
    .PARAMETER FieldMask
    The fields to retrieve for each Chrome device. Acceptable values are:
    * "name"
    * "customer"
    * "orgUnitId"
    * "deviceId"
    * "serialNumber"
    * "cpuInfo"
    * "cpuStatusReport"
    * "memoryInfo"
    * "memoryStatusReport"
    * "networkStatusReport"
    * "osUpdateStatus"
    * "graphicsInfo"
    * "graphicsStatusReport"
    * "batteryInfo"
    * "batteryStatusReport"
    * "storageInfo"
    * "storageStatusReport"
    The default value is to return all fields.
    .PARAMETER Filter
    Query string for searching Chrome device fields. Supported filter fields are:
    * "orgUnitId"
    * "serialNumber"
    For more information on constructing filter queries, see: https://developers.google.com/admin-sdk/directory/v1/guides/search-users
    PowerShell filter syntax here is supported as "best effort". Please use Google's filter operators and syntax to ensure best results
    .PARAMETER PageSize
    Page size of the result set
    .PARAMETER Limit
    The maximum amount of results you want returned. Exclude or set to 0 to return all results
    .EXAMPLE
    Get-GSChromeDeviceTelemetry
    Gets the list of all Chrome devices including all telemetry fields
    .EXAMPLE
    Get-GSChromeDeviceTelemetry -Filter "orgUnitId -eq ABCDEFG"
    Gets the list of all Chrome devices found in the ABCDEFG OU and includes all telemetry fields
    .EXAMPLE
    Get-GSChromeDeviceTelemetry -FieldMask deviceId, batteryInfo, cpuInfo
    Gets the list of all Chrome devices including only the deviceId, batteryInfo and cpuInfo telemetry fields.
    .LINK
    https://developers.google.com/chrome/management/reference/rest/v1/customers.telemetry.devices
    #>
    [OutputType('Google.Apis.ChromeManagement.v1.Data.GoogleChromeManagementV1TelemetryDevice')]
    Param
    (
        [parameter(Mandatory = $false)]
        [Alias("Query")]
        [string]
        $Filter,
        [parameter(Mandatory = $false)]
        [ALias("Fields")]
        [ValidateSet("name", "customer", "orgUnitId", "deviceId", "serialNumber", "cpuInfo", "cpuStatusReport", "memoryInfo", "memoryStatusReport", "networkStatusReport", "osUpdateStatus", "graphicsInfo", "graphicsStatusReport", "batteryInfo", "batteryStatusReport", "storageInfo", "storageStatusReport")]
        [String[]]
        $FieldMask = @("name", "customer", "orgUnitId", "deviceId", "serialNumber", "cpuInfo", "cpuStatusReport", "memoryInfo", "memoryStatusReport", "networkStatusReport", "osUpdateStatus", "graphicsInfo", "graphicsStatusReport", "batteryInfo", "batteryStatusReport", "storageInfo", "storageStatusReport"),
        [parameter(Mandatory = $false)]
        [ValidateRange(1,200)]
        [Alias("MaxResults")]
        [Int]
        $PageSize = 200,
        [parameter(Mandatory = $false)]
        [Alias('First')]
        [Int]
        $Limit = 0,
        [parameter(Mandatory = $false)]
        [String]
        $CustomerID = "my_customer"

    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/chrome.management.telemetry.readonly'
            ServiceType = 'Google.Apis.ChromeManagement.v1.ChromeManagementService'
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
                $verbString = "Getting all Chrome device telemetry records"
                try {
                    $request = $service.Customers.Telemetry.Devices.List('customers/$CustomerID')
                    $ReadMask = $FieldMask -join ","
                    $verbString += " for fields '$ReadMask'"
                    $Request.ReadMask = $ReadMask
                    if ($PSBoundParameters.Keys -contains 'Filter') {
                        if ($Filter -eq '*') {
                            $Filter = ""
                        }
                        else {
                            $Filter = "$($Filter -join " ")"
                        }
                        $Filter = $Filter -replace " -eq ","=" -replace " -like ",":" -replace " -match ",":" -replace " -contains ",":" -creplace "'True'","True" -creplace "'False'","False"
                        if (-not [String]::IsNullOrEmpty($Filter.Trim())) {
                            $verbString += " matching query '$($Filter.Trim())'"
                            $request.Filter = $Filter.Trim()
                        }
                    }
                    if ($Limit -gt 0 -and $PageSize -gt $Limit) {
                        Write-Verbose ("Reducing PageSize from {0} to {1} to meet limit with first page" -f $PageSize,$Limit)
                        $PageSize = $Limit
                    }
                    $request.PageSize = $PageSize
                    Write-Verbose $verbString
                    [int]$i = 1
                    $overLimit = $false
                    do {
                        $result = $request.Execute()
                        if ($null -ne $result.Devices) {
                            $result.Devices | Add-Member -MemberType ScriptMethod -Name ToString -Value {$this.DeviceId} -PassThru -Force
                        }
                        $request.PageToken = $result.NextPageToken
                        [int]$retrieved = ($i + $result.Devices.Count) - 1
                        Write-Verbose "Retrieved $retrieved Chrome devices..."
                        if ($Limit -gt 0 -and $retrieved -eq $Limit) {
                            Write-Verbose "Limit reached: $Limit"
                            $overLimit = $true
                        }
                        elseif ($Limit -gt 0 -and ($retrieved + $PageSize) -gt $Limit) {
                            $newPS = $Limit - $retrieved
                            Write-Verbose ("Reducing PageSize from {0} to {1} to meet limit with next page" -f $PageSize,$newPS)
                            $request.PageSize = $newPS
                        }
                        [int]$i = $i + $result.Devices.Count
                    }
                    until ($overLimit -or !$result.NextPageToken)
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
