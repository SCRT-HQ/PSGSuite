function Get-GSChromeOSDevice {
    <#
    .SYNOPSIS
    Gets the list of Chrome OS Devices registered for the user's account

    .DESCRIPTION
    Gets the list of Chrome OS Devices registered for the user's account

    .PARAMETER ResourceId
    Immutable ID of Chrome OS Device. Gets the list of Chrome OS devices if excluded.

    .PARAMETER OrgUnitPath
    The full path of the organizational unit or its unique ID.

    .PARAMETER Filter
    Search string in the format given at: http://support.google.com/chromeos/a/bin/answer.py?answer=1698333

    .PARAMETER Projection
    Restrict information returned to a set of selected fields.

    Acceptable values are:
    * "BASIC": Includes only the basic metadata fields (e.g., deviceId, model, status, type, and status)
    * "FULL": Includes all metadata fields

    Defauls to "FULL"

    .PARAMETER PageSize
    Page size of the result set

    .PARAMETER OrderBy
    Device property to use for sorting results.

    Acceptable values are:
    * "annotatedLocation": Chrome device location as annotated by the administrator.
    * "annotatedUser": Chrome device user as annotated by the administrator.
    * "lastSync": The date and time the Chrome device was last synchronized with the policy settings in the Admin console.
    * "notes": Chrome device notes as annotated by the administrator.
    * "serialNumber": The Chrome device serial number entered when the device was enabled.
    * "status": Chrome device status. For more information, see the chromeosdevices resource.
    * "supportEndDate": Chrome device support end date. This is applicable only for devices purchased directly from Google.

    .PARAMETER SortOrder
    Whether to return results in ascending or descending order. Must be used with the OrderBy parameter.

    Acceptable values are:
    * "ASCENDING": Ascending order.
    * "DESCENDING": Descending order.

    .EXAMPLE
    Get-GSChromeOSDevice

    Gets the Chrome OS Device list for the customer
    #>
    [OutputType('Google.Apis.Admin.Directory.directory_v1.Data.ChromeOSDevice')]
    [cmdletbinding(DefaultParameterSetName = "List")]
    Param
    (
        [parameter(Mandatory = $false,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true,ParameterSetName = "Get")]
        [Alias('Id','Device','DeviceId')]
        [String[]]
        $ResourceId,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [Alias('Query')]
        [String]
        $Filter,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [String]
        $OrgUnitPath,
        [parameter(Mandatory = $false)]
        [ValidateSet("BASIC","FULL")]
        [String]
        $Projection = "FULL",
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [ValidateRange(1,100)]
        [Alias('MaxResults')]
        [Int]
        $PageSize = "100",
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [ValidateSet("annotatedLocation","annotatedUser","lastSync","notes","serialNumber","status","supportEndDate")]
        [String]
        $OrderBy,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [ValidateSet("ASCENDING","DESCENDING")]
        [String]
        $SortOrder
    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.device.chromeos'
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
            switch ($PSCmdlet.ParameterSetName) {
                Get {
                    foreach ($dev in $ResourceId) {
                        try {
                            Write-Verbose "Getting Chrome OS Device '$dev'"
                            $request = $service.Chromeosdevices.Get($customerId,$dev)
                            $request.Execute()
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
                List {
                    $request = $service.Chromeosdevices.List($customerId)
                    if ($PSBoundParameters.Keys -contains 'Filter') {
                        Write-Verbose "Getting Chrome OS Device list for filter '$Filter'"
                        $request.Query = $PSBoundParameters['Filter']
                    }
                    else {
                        Write-Verbose "Getting Chrome OS Device list"
                    }
                    foreach ($key in $PSBoundParameters.Keys | Where-Object {$_ -ne 'Filter'}) {
                        switch ($key) {
                            PageSize {
                                $request.MaxResults = $PSBoundParameters[$key]
                            }
                            default {
                                if ($request.PSObject.Properties.Name -contains $key) {
                                    $request.$key = $PSBoundParameters[$key]
                                }
                            }
                        }
                    }
                    [int]$i = 1
                    do {
                        $result = $request.Execute()
                        $result.Chromeosdevices
                        if ($result.NextPageToken) {
                            $request.PageToken = $result.NextPageToken
                        }
                        [int]$retrieved = ($i + $result.Chromeosdevices.Count) - 1
                        Write-Verbose "Retrieved $retrieved Chrome OS Devices..."
                        [int]$i = $i + $result.Chromeosdevices.Count
                    }
                    until (!$result.NextPageToken)
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
