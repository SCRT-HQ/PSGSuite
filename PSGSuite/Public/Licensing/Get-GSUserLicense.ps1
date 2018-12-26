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

    .PARAMETER ProductID
    The product Id to list licenses for

    .PARAMETER PageSize
    The page size of the result set

    .EXAMPLE
    Get-GSUserLicense

    Gets the full list of licenses for the customer
    #>
    [OutputType('Google.Apis.Licensing.v1.Data.LicenseAssignment')]
    [cmdletbinding(DefaultParameterSetName = "List")]
    Param
    (
        [parameter(Mandatory = $false,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true,ParameterSetName = "Get")]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $User,
        [parameter(Mandatory = $false)]
        [Alias("SkuId")]
        [ValidateSet("G-Suite-Enterprise","Google-Apps-Unlimited","Google-Apps-For-Business","Google-Apps-For-Postini","Google-Apps-Lite","Google-Drive-storage-20GB","Google-Drive-storage-50GB","Google-Drive-storage-200GB","Google-Drive-storage-400GB","Google-Drive-storage-1TB","Google-Drive-storage-2TB","Google-Drive-storage-4TB","Google-Drive-storage-8TB","Google-Drive-storage-16TB","Google-Vault","Google-Vault-Former-Employee","1010020020")]
        [string]
        $License,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [ValidateSet("Google-Apps","Google-Drive-storage","Google-Vault")]
        [string[]]
        $ProductID = @("Google-Apps","Google-Drive-storage","Google-Vault"),
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [Alias("MaxResults")]
        [ValidateRange(1,1000)]
        [Int]
        $PageSize = "1000"
    )
    Begin {
        if ($PSCmdlet.ParameterSetName -eq 'Get') {
            $serviceParams = @{
                Scope       = 'https://www.googleapis.com/auth/apps.licensing'
                ServiceType = 'Google.Apis.Licensing.v1.LicensingService'
            }
            $service = New-GoogleService @serviceParams
            $productHash = @{
                '1010020020'                   = 'Google-Apps'
                'G-Suite-Enterprise'           = 'Google-Apps'
                'Google-Apps-Unlimited'        = 'Google-Apps'
                'Google-Apps-For-Business'     = 'Google-Apps'
                'Google-Apps-For-Postini'      = 'Google-Apps'
                'Google-Apps-Lite'             = 'Google-Apps'
                'Google-Vault'                 = 'Google-Vault'
                'Google-Vault-Former-Employee' = 'Google-Vault'
                'Google-Drive-storage-20GB'    = 'Google-Drive-storage'
                'Google-Drive-storage-50GB'    = 'Google-Drive-storage'
                'Google-Drive-storage-200GB'   = 'Google-Drive-storage'
                'Google-Drive-storage-400GB'   = 'Google-Drive-storage'
                'Google-Drive-storage-1TB'     = 'Google-Drive-storage'
                'Google-Drive-storage-2TB'     = 'Google-Drive-storage'
                'Google-Drive-storage-4TB'     = 'Google-Drive-storage'
                'Google-Drive-storage-8TB'     = 'Google-Drive-storage'
                'Google-Drive-storage-16TB'    = 'Google-Drive-storage'
            }
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
                        if ($License) {
                            Write-Verbose "Getting License SKU '$License' for User '$U'"
                            if ($License -eq "G-Suite-Enterprise") {
                                $License = "1010020020"
                            }
                            $request = $service.LicenseAssignments.Get($productHash[$License],$License,$U)
                            $request.Execute()
                        }
                        else {
                            foreach ($license in (@("G-Suite-Enterprise","Google-Apps-Unlimited","Google-Apps-For-Business","Google-Apps-For-Postini","Google-Apps-Lite","Google-Drive-storage-20GB","Google-Drive-storage-50GB","Google-Drive-storage-200GB","Google-Drive-storage-400GB","Google-Drive-storage-1TB","Google-Drive-storage-2TB","Google-Drive-storage-4TB","Google-Drive-storage-8TB","Google-Drive-storage-16TB","Google-Vault","Google-Vault-Former-Employee") | Sort-Object)) {
                                Write-Verbose "Getting License SKU '$License' for User '$U'"
                                if ($License -eq "G-Suite-Enterprise") {
                                    $License = "1010020020"
                                }
                                try {
                                    $request = $service.LicenseAssignments.Get($productHash[$License],$License,$U)
                                    $response = $request.Execute()
                                }
                                catch {
                                }
                                if ($response) {
                                    break
                                }
                            }
                            if (!$response) {
                                Write-Error "No license found for $U!"
                            }
                            else {
                                return $response
                            }
                        }
                    }
                }
                List {
                    Get-GSUserLicenseListPrivate @PSBoundParameters
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
