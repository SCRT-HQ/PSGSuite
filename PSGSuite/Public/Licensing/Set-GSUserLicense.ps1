function Set-GSUserLicense {
    <#
    .SYNOPSIS
    Sets the license for a user

    .DESCRIPTION
    Sets the license for a user

    .PARAMETER User
    The user's current primary email address

    .PARAMETER License
    The license SKU to set for the user

    .EXAMPLE
    Set-GSUserLicense -User joe -License Google-Apps-For-Business

    Sets Joe to a Google-Apps-For-Business license
    #>
    [OutputType('Google.Apis.Licensing.v1.Data.LicenseAssignment')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $User,
        [parameter(Mandatory = $true,Position = 1)]
        [Alias("SkuId")]
        [ValidateSet("G-Suite-Enterprise","Google-Apps-Unlimited","Google-Apps-For-Business","Google-Apps-For-Postini","Google-Apps-Lite","Google-Drive-storage-20GB","Google-Drive-storage-50GB","Google-Drive-storage-200GB","Google-Drive-storage-400GB","Google-Drive-storage-1TB","Google-Drive-storage-2TB","Google-Drive-storage-4TB","Google-Drive-storage-8TB","Google-Drive-storage-16TB","Google-Vault","Google-Vault-Former-Employee","1010020020")]
        [string]
        $License
    )
    Begin {
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
    Process {
        try {
            foreach ($U in $User) {
                if ($U -notlike "*@*.*") {
                    $U = "$($U)@$($Script:PSGSuite.Domain)"
                }
                Write-Verbose "Setting license for $U to $License"
                if ($License -eq "G-Suite-Enterprise") {
                    $License = "1010020020"
                }
                $body = New-Object 'Google.Apis.Licensing.v1.Data.LicenseAssignmentInsert' -Property @{
                    UserId = $U
                }
                $request = $service.LicenseAssignments.Insert($body,$productHash[$License],$License)
                $request.Execute() | Add-Member -MemberType NoteProperty -Name 'User' -Value $U -PassThru
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
