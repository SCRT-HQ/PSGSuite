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
        $attribute.Mandatory = $true
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
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/apps.licensing'
            ServiceType = 'Google.Apis.Licensing.v1.LicensingService'
        }
        $service = New-GoogleService @serviceParams
        $License = $PSBoundParameters['License']
    }
    Process {
        try {
            foreach ($U in $User) {
                Resolve-Email ([ref]$U)
                Write-Verbose "Setting license for $U to $License"
                $License = Get-LicenseSkuFromDisplayName $License
                $body = New-Object 'Google.Apis.Licensing.v1.Data.LicenseAssignmentInsert' -Property @{
                    UserId = $U
                }
                $request = $service.LicenseAssignments.Insert($body,(Get-LicenseSkuToProductHash $License),$License)
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
