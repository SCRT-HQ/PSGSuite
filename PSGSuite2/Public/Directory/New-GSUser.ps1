function New-GSUser {
    <#
    .Synopsis
    Create a new Google user
    .DESCRIPTION
    Create a new Google user, allowing for full property setting on creation
    .EXAMPLE
    New-GSUser -PrimaryEmail john.smith@domain.com -GivenName John -FamilyName Smith -Password Password123 -ChangePasswordAtNextLogin -OrgUnitPath "/Users/New Hires" -IncludeInGlobalAddressList
    #>
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0)]
        [String]
        $PrimaryEmail,
        [parameter(Mandatory = $true)]
        [String]
        $GivenName,
        [parameter(Mandatory = $true)]
        [String]
        $FamilyName,
        [parameter(Mandatory = $false)]
        [String]
        $FullName,
        [parameter(Mandatory = $true)]
        [SecureString]
        $Password,
        [parameter(Mandatory = $false)]
        [Switch]
        $ChangePasswordAtNextLogin,
        [parameter(Mandatory = $false)]
        [String]
        $OrgUnitPath,
        [parameter(Mandatory = $false)]
        [Switch]
        $Suspended,
        [parameter(Mandatory = $false)]
        [Google.Apis.Admin.Directory.directory_v1.Data.UserAddress[]]
        $Addresses,
        [parameter(Mandatory = $false)]
        [Google.Apis.Admin.Directory.directory_v1.Data.UserPhone[]]
        $Phones,
        [parameter(Mandatory = $false)]
        [Google.Apis.Admin.Directory.directory_v1.Data.UserExternalId[]]
        $ExternalIds,
        [parameter(Mandatory = $false)]
        [Switch]
        $IncludeInGlobalAddressList,
        [parameter(Mandatory = $false)]
        [Switch]
        $IpWhitelisted
    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.user'
            ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        try {
            Write-Verbose "Creating user '$PrimaryEmail'"
            $body = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.User'
            $name = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.UserName' -Property @{
                GivenName  = $GivenName
                FamilyName = $FamilyName
            }
            if ($PSBoundParameters.Keys -contains 'FullName') {
                $name.FullName = $FullName
            }
            else {
                $name.FullName = "$GivenName $FamilyName"
            }
            $body.Name = $name
            foreach ($prop in $PSBoundParameters.Keys | Where-Object {$body.PSObject.Properties.Name -contains $_}) {
                switch ($prop) {
                    PrimaryEmail {
                        if ($PSBoundParameters[$prop] -notlike "*@*.*") {
                            $PSBoundParameters[$prop] = "$($PSBoundParameters[$prop])@$($Script:PSGSuite.Domain)"
                        }
                        $body.$prop = $PSBoundParameters[$prop]
                    }
                    Password {
                        $body.Password = (New-Object PSCredential "user",$Password).GetNetworkCredential().Password
                    }
                    Default {
                        $body.$prop = $PSBoundParameters[$prop]
                    }
                }
            }
            $request = $service.Users.Insert($body)
            $request.Execute()
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}