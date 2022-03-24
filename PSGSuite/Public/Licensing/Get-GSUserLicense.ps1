function Get-GSUserLicense {
    <#
    .SYNOPSIS
    Gets the G Suite license information for a user or list of users

    .DESCRIPTION
    Gets the G Suite license information for a user or list of users

    .PARAMETER User
    The primary email or unique Id of the user to retrieve license information for

    .PARAMETER License
    The license SKU to retrieve information for. If excluded, searches all license SKUs

    .PARAMETER ProductId
    The product Id to list licenses for

    .PARAMETER PageSize
    The page size of the result set

    .PARAMETER Limit
    The maximum amount of results you want returned. Exclude or set to 0 to return all results

    .PARAMETER CheckAll
    If $true, force a check of all license products when specifying a User. This will return all license types it finds for a specific user instead of the default behavior of short circuiting after matching against the first license assigned.

    .EXAMPLE
    Get-GSUserLicense

    Gets the full list of licenses for the customer
    #>
    [OutputType('Google.Apis.Licensing.v1.Data.LicenseAssignment')]
    [cmdletbinding(DefaultParameterSetName = "List")]
    Param
    (
        [parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = "Get")]
        [Alias("PrimaryEmail", "UserKey", "Mail","UserId")]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $User,
        [parameter(Mandatory = $false, ParameterSetName = "List")]
        [Alias("MaxResults")]
        [ValidateRange(1, 1000)]
        [Int]
        $PageSize = 1000,
        [parameter(Mandatory = $false, ParameterSetName = "List")]
        [Alias('First')]
        [Int]
        $Limit = 0,
        [parameter(ParameterSetName = "Get")]
        [Switch]
        $CheckAll
    )
    DynamicParam {
        $paramDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

        # License
        $_licenses = (Get-LicenseSkuHash).Keys | Sort-Object -Unique
        $attributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $attribute = New-Object System.Management.Automation.ParameterAttribute
        $attribute.Mandatory = $false
        $attributeCollection.Add($attribute)
        $attribute = New-Object System.Management.Automation.AliasAttribute('SkuId')
        $attributeCollection.Add($attribute)
        $attribute = New-Object System.Management.Automation.ValidateSetAttribute($_licenses)
        $attributeCollection.Add($attribute)
        $Name = 'License'
        $dynParam = New-Object System.Management.Automation.RuntimeDefinedParameter($Name, [string], $attributeCollection)
        $paramDictionary.Add($Name, $dynParam)

        # ProductId
        $_products = (Get-LicenseProductHash).Keys | Sort-Object -Unique
        $attributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $attribute = New-Object System.Management.Automation.ParameterAttribute
        $attribute.Mandatory = $false
        $attribute.ParameterSetName = 'List'
        $attributeCollection.Add($attribute)
        $attribute = New-Object System.Management.Automation.ValidateSetAttribute($_products)
        $attributeCollection.Add($attribute)
        $Name = 'ProductId'
        $dynParam = New-Object System.Management.Automation.RuntimeDefinedParameter($Name, [string[]], $attributeCollection)
        $paramDictionary.Add($Name, $dynParam)
        # return the collection of dynamic parameters
        return $paramDictionary
    }
    Process {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/apps.licensing'
            ServiceType = 'Google.Apis.Licensing.v1.LicensingService'
        }
        $service = New-GoogleService @serviceParams
        $License = $PSBoundParameters['License']
        $ProductId = if ($PSBoundParameters.ContainsKey('ProductId')) {
            $PSBoundParameters['ProductId']
        }
        else {
            (Get-LicenseProductFromDisplayName).Keys | Where-Object {$_ -ne 'Cloud-Identity'} | Sort-Object
        }
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Get {
                    foreach ($U in $User) {
                        $response = $null
                        Resolve-Email ([ref]$U)
                        if ($PSBoundParameters.ContainsKey('License')) {
                            Write-Verbose "Getting License SKU '$License' for User '$U'"
                            $License = Get-LicenseSkuFromDisplayName $License
                            $request = $service.LicenseAssignments.Get((Get-LicenseSkuToProductHash $License), $License, $U)
                            $request.Execute()
                        }
                        else {
                            $matchedLicense = $false
                            foreach ($License in (Get-LicenseSkuFromDisplayName).Values | Sort-Object -Unique) {
                                $response = $null
                                Write-Verbose "Getting License SKU '$License' for User '$U'"
                                $License = Get-LicenseSkuFromDisplayName $License
                                try {
                                    $request = $service.LicenseAssignments.Get((Get-LicenseSkuToProductHash $License), $License, $U)
                                    $response = $request.Execute()
                                }
                                catch {}
                                if (-not $CheckAll -and $response) {
                                    $matchedLicense = $true
                                    $response
                                    break
                                }
                                elseif ($response) {
                                    $matchedLicense = $true
                                    $response
                                }
                            }
                            if (-not $matchedLicense) {
                                Write-Warning "No license found for $U!"
                            }
                        }
                    }
                }
                List {
                    if ($License) {
                        $ProductID = Get-LicenseSkuToProductHash $License
                    }
                    $total = 0
                    $overLimit = $false
                    foreach ($prodId in $ProductID) {
                        $origProdId = $prodId
                        try {
                            if (-not $overLimit) {
                                Write-Verbose "Retrieving licenses for product '$origProdId'"
                                $prodId = Get-LicenseProductHash $prodId
                                if ($License) {
                                    $origLicense = $License
                                    $License = Get-LicenseSkuFromDisplayName $License
                                    $request = $service.LicenseAssignments.ListForProductAndSku($prodId, $License, $Script:PSGSuite.Domain)
                                }
                                else {
                                    $request = $service.LicenseAssignments.ListForProduct($prodId, $Script:PSGSuite.Domain)
                                }
                                if ($Limit -gt 0 -and $PageSize -gt $Limit) {
                                    Write-Verbose ("Reducing PageSize from {0} to {1} to meet limit with first page" -f $PageSize, $Limit)
                                    $PageSize = $Limit
                                }
                                $request.MaxResults = $PageSize
                                [int]$i = 1
                                $overLimit = $false
                                do {
                                    $result = $request.Execute()
                                    $result.Items
                                    $total += $result.Items.Count
                                    $request.PageToken = $result.NextPageToken
                                    [int]$retrieved = ($i + $result.Items.Count) - 1
                                    if ($License) {
                                        Write-Verbose "Retrieved $retrieved licenses for product '$origProdId' & sku '$origLicense'..."
                                    }
                                    else {
                                        Write-Verbose "Retrieved $retrieved licenses for product '$origProdId'..."
                                    }
                                    if ($Limit -gt 0 -and $total -eq $Limit) {
                                        Write-Verbose "Limit reached: $Limit"
                                        $overLimit = $true
                                    }
                                    elseif ($Limit -gt 0 -and ($total + $PageSize) -gt $Limit) {
                                        $newPS = $Limit - $total
                                        Write-Verbose ("Reducing PageSize from {0} to {1} to meet limit with next page" -f $PageSize, $newPS)
                                        $request.MaxResults = $newPS
                                    }
                                    [int]$i = $i + $result.Items.Count
                                }
                                until ($overLimit -or !$result.NextPageToken)
                            }
                        }
                        catch {
                            if ($_.Exception.Message -notmatch 'Invalid productId') {
                                if ($ErrorActionPreference -eq 'Stop') {
                                    $PSCmdlet.ThrowTerminatingError($_)
                                }
                                else {
                                    Write-Error $_
                                }
                            }
                            else {
                                Write-Verbose "Retrieved $retrieved licenses for product '$origProdId'..."
                            }
                        }
                    }
                    Write-Verbose "Retrieved $total total licenses"
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
