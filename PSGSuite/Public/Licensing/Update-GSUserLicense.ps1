function Update-GSUserLicense {
    <#
    .SYNOPSIS
    Reassign a user's product SKU with a different SKU in the same product

    .DESCRIPTION
    Reassign a user's product SKU with a different SKU in the same product

    .PARAMETER User
    The user's current primary email address

    .PARAMETER License
    The license SKU that you would like to reassign the user to

    .EXAMPLE
    Update-GSUserLicense -User joe -License G-Suite-Enterprise

    Updates Joe to a G-Suite-Enterprise license
    #>
    [OutputType('Google.Apis.Licensing.v1.Data.LicenseAssignment')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail","UserId")]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $User
    )
    DynamicParam {
        $paramDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

        # License
        $_licenses = (Get-LicenseSkuHash).Keys | Sort-Object -Unique
        $attributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $attribute = New-Object System.Management.Automation.ParameterAttribute
        $attribute.Mandatory = $false
        $attribute.Position = 1
        $attributeCollection.Add($attribute)
        $attribute = New-Object System.Management.Automation.AliasAttribute('SkuId')
        $attributeCollection.Add($attribute)
        $attribute = New-Object System.Management.Automation.ValidateSetAttribute($_licenses)
        $attributeCollection.Add($attribute)
        $Name = 'License'
        $dynParam = New-Object System.Management.Automation.RuntimeDefinedParameter($Name, [string], $attributeCollection)
        $paramDictionary.Add($Name, $dynParam)

        return $paramDictionary
    }
    Process {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/apps.licensing'
            ServiceType = 'Google.Apis.Licensing.v1.LicensingService'
        }
        $service = New-GoogleService @serviceParams
        $License = $PSBoundParameters['License']
        try {
            foreach ($U in $User) {
                Resolve-Email ([ref]$U)
                Write-Verbose "Setting license for $U to $License"
                $License = Get-LicenseSkuFromDisplayName $License
                $body = Get-GSUserLicense -User $U
                $request = $service.LicenseAssignments.Update($body,(Get-LicenseSkuToProductHash $License),$License,$U)
                $request.Execute()
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
