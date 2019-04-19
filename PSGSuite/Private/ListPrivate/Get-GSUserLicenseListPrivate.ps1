function Get-GSUserLicenseListPrivate {
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false)]
        [ValidateSet("Google-Apps","Google-Drive-storage","Google-Vault","Cloud-Identity","Cloud-Identity-Premium")]
        [string[]]
        $ProductID = @("Google-Apps","Google-Drive-storage","Google-Vault","Cloud-Identity","Cloud-Identity-Premium"),
        [parameter(Mandatory = $false)]
        [Alias("SkuId")]
        [ValidateSet("Cloud-Identity","Cloud-Identity-Premium","Drive-Enterprise","G-Suite-Enterprise","Google-Apps-Unlimited","Google-Apps-For-Business","Google-Apps-For-Postini","Google-Apps-Lite","Google-Drive-storage-20GB","Google-Drive-storage-50GB","Google-Drive-storage-200GB","Google-Drive-storage-400GB","Google-Drive-storage-1TB","Google-Drive-storage-2TB","Google-Drive-storage-4TB","Google-Drive-storage-8TB","Google-Drive-storage-16TB","Google-Vault","Google-Vault-Former-Employee","1010020020","1010060001","1010010001","1010050001")]
        [string]
        $License,
        [parameter(Mandatory = $false)]
        [Alias("MaxResults")]
        [ValidateRange(1,1000)]
        [Int]
        $PageSize = "1000"
    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/apps.licensing'
            ServiceType = 'Google.Apis.Licensing.v1.LicensingService'
        }
        $service = New-GoogleService @serviceParams
        if ($License) {
            $ProductID = @{
                'Cloud-Identity'               = @('101001')       # Cloud-Identity
                '1010010001'                   = @('101001')       # Cloud-Identity
                'Cloud-Identity-Premium'       = @('101005')       # Cloud-Identity-Premium
                '1010050001'                   = @('101005')       # Cloud-Identity-Premium
                '1010020020'                   = @('Google-Apps')  # G-Suite-Enterprise
                '1010060001'                   = @('Google-Apps')  # Drive-Enterprise
                'G-Suite-Enterprise'           = @('Google-Apps')
                'Google-Apps-Unlimited'        = @('Google-Apps')
                'Google-Apps-For-Business'     = @('Google-Apps')
                'Google-Apps-For-Postini'      = @('Google-Apps')
                'Google-Apps-Lite'             = @('Google-Apps')
                'Google-Vault'                 = @('Google-Vault')
                'Google-Vault-Former-Employee' = @('Google-Vault')
                'Google-Drive-storage-20GB'    = @('Google-Drive-storage')
                'Google-Drive-storage-50GB'    = @('Google-Drive-storage')
                'Google-Drive-storage-200GB'   = @('Google-Drive-storage')
                'Google-Drive-storage-400GB'   = @('Google-Drive-storage')
                'Google-Drive-storage-1TB'     = @('Google-Drive-storage')
                'Google-Drive-storage-2TB'     = @('Google-Drive-storage')
                'Google-Drive-storage-4TB'     = @('Google-Drive-storage')
                'Google-Drive-storage-8TB'     = @('Google-Drive-storage')
                'Google-Drive-storage-16TB'    = @('Google-Drive-storage')
            }[$License]
        }
        $response = @()
    }
    Process {
        try {
            foreach ($prodId in $ProductID) {
                switch ($prodId) {
                    "Cloud-Identity" {
                        $prodId = "101001"
                    }
                    "Cloud-Identity-Premium" {
                        $prodId = "101005"
                    }
                }
                if ($License) {
                    switch ($License) {
                        "G-Suite-Enterprise" {
                            $License = "1010020020"
                        }
                        "Drive-Enterprise" {
                            $License = "1010060001"
                        }
                        "Cloud-Identity" {
                            $License = "1010010001"
                        }
                        "Cloud-Identity-Premium" {
                            $License = "1010050001"
                        }
                    }
                    $request = $service.LicenseAssignments.ListForProductAndSku($prodId,$License,$Script:PSGSuite.Domain)
                }
                else {
                    $request = $service.LicenseAssignments.ListForProduct($prodId,$Script:PSGSuite.Domain)
                }
                if ($PageSize) {
                    $request.MaxResults = $PageSize
                }
                [int]$i = 1
                do {
                    $result = $request.Execute()
                    $response += $result.Items
                    $request.PageToken = $result.NextPageToken
                    [int]$retrieved = ($i + $result.Items.Count) - 1
                    if ($License) {
                        Write-Verbose "Retrieved $retrieved licenses for product '$prodId' & sku '$License'..."
                    }
                    else {
                        Write-Verbose "Retrieved $retrieved licenses for product '$prodId'..."
                    }
                    [int]$i = $i + $result.Items.Count
                }
                until (!$result.NextPageToken)
            }
            Write-Verbose "Retrieved $($response.Count) total licenses"
            return $response
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
