function Update-GSUser {
    <#
.Synopsis
   Updates an existing Google user
.DESCRIPTION
   Updates an existing Google user
.EXAMPLE
   Update-GSUser -User john.smith@domain.com -PrimaryEmail johnathan.smith@domain.com -GivenName Johnathan -Suspended False
#>
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [Alias("Id","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $User,
        [parameter(Mandatory = $false)]
        [String]
        $PrimaryEmail,
        [parameter(Mandatory = $false)]
        [String]
        $GivenName,
        [parameter(Mandatory = $false)]
        [String]
        $FamilyName,
        [parameter(Mandatory = $false)]
        [String]
        $FullName,
        [parameter(Mandatory = $false)]
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
            if ($User -ceq 'me') {
                $User = $Script:PSGSuite.AdminEmail
            }
            elseif ($User -notlike "*@*.*") {
                $User = "$($User)@$($Script:PSGSuite.Domain)"
            }
            Write-Verbose "Updating user '$User'"
            $userObj = Get-GSUser $User -Verbose:$false
            $body = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.User'
            $name = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.UserName'
            $body.Name = $name
            foreach ($prop in $PSBoundParameters.Keys | Where-Object {$body.PSObject.Properties.Name -contains $_ -or $name.PSObject.Properties.Name -contains $_}) {
                switch ($prop) {
                    PrimaryEmail {
                        if ($PSBoundParameters[$prop] -notlike "*@*.*") {
                            $PSBoundParameters[$prop] = "$($PSBoundParameters[$prop])@$($Script:PSGSuite.Domain)"
                        }
                        $body.$prop = $PSBoundParameters[$prop]
                    }
                    GivenName {
                        $body.Name.$prop = $PSBoundParameters[$prop]
                    }
                    FamilyName {
                        $body.Name.$prop = $PSBoundParameters[$prop]
                    }
                    FullName {
                        $body.Name.$prop = $PSBoundParameters[$prop]
                    }
                    Password {
                        $body.Password = (New-Object PSCredential "user",$Password).GetNetworkCredential().Password
                    }
                    Default {
                        $body.$prop = $PSBoundParameters[$prop]
                    }
                }
            }
            $request = $service.Users.Update($body,$userObj.Id)
            $request.Execute() | Select-Object @{N = "User";E = {$_.PrimaryEmail}},*
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}