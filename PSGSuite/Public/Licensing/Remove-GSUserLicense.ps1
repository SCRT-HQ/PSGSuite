function Remove-GSUserLicense {
    <#
    .SYNOPSIS
    Removes a license assignment from a user

    .DESCRIPTION
    Removes a license assignment from a user. Useful for restoring a user from a Vault-Former-Employee to an auto-assigned G Suite Business license by removing the Vault-Former-Employee license, for example.

    .PARAMETER User
    The user's current primary email address

    .PARAMETER License
    The license SKU to remove from the user

    .EXAMPLE
    Remove-GSUserLicense -User joe -License Google-Vault-Former-Employee

    Removes the Vault-Former-Employee license from Joe
    #>
    [cmdletbinding(SupportsShouldProcess = $true,ConfirmImpact = "High")]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [string[]]
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
                if ($PSCmdlet.ShouldProcess("Revoking license '$License' from user '$U'")) {
                    Write-Verbose "Revoking license '$License' from user '$U'"
                    $License = Get-LicenseSkuFromDisplayName $License
                    $request = $service.LicenseAssignments.Delete((Get-LicenseSkuToProductHash $License),$License,$U)
                    $request.Execute()
                    Write-Verbose "License revoked for user '$U'"
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
