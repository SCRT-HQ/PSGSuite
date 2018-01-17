function Add-GSDrivePermission {
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [Alias('Owner','PrimaryEmail','UserKey','Mail')]
        [string]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $true)]
        [String]
        $FileId,
        [parameter(Mandatory = $true)]
        [ValidateSet("Owner","Writer","Commenter","Reader","Organizer")]
        [String]
        $Role,
        [parameter(Mandatory = $true)]
        [ValidateSet("User","Group","Domain","Anyone")]
        [String]
        $Type,
        [parameter(Mandatory = $false)]
        [String]
        $EmailAddress,
        [parameter(Mandatory = $false)]
        [DateTime]
        $ExpirationTime,
        [parameter(Mandatory = $false)]
        [string]
        $EmailMessage,
        [parameter(Mandatory = $false)]
        [Switch]
        $SendNotificationEmail,
        [parameter(Mandatory = $false)]
        [Switch]
        $AllowFileDiscovery,
        [parameter(Mandatory = $false)]
        [Alias('ConfirmTransferOfOwnership')]
        [switch]
        $TransferOfOwnership,
        [parameter(Mandatory = $false)]
        [switch]
        $UseDomainAdminAccess
    )
    Begin {
        if ($User -ceq 'me') {
            $User = $Script:PSGSuite.AdminEmail
        }
        elseif ($User -notlike "*@*.*") {
            $User = "$($User)@$($Script:PSGSuite.Domain)"
        }
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/drive'
            ServiceType = 'Google.Apis.Drive.v3.DriveService'
            User        = $User
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        try {
            if ($Role -eq "Owner" -and !$TransferOfOwnership) {
                throw "The TransferOfOwnership parameter is required when setting the 'Owner' role."
            }
            if (($Type -eq "User" -or $Type -eq "Group") -and !$EmailAddress) {
                throw "The EmailAddress parameter is required for types 'User' or 'Group'."
            }
            if (($Type -eq "User" -or $Type -eq "Group") -and ($PSBoundParameters.Keys -contains 'AllowFileDiscovery')) {
                Write-Warning "The AllowFileDiscovery parameter is only applicable for types 'Domain' or 'Anyone' This parameter will be excluded from this request."
                $PSBoundParameters.Remove('AllowFileDiscovery') | Out-Null
            }
            if ($TransferOfOwnership -and !$SendNotificationEmail) {
                $PSBoundParameters['SendNotificationEmail'] = $true
                Write-Warning "Setting SendNotificationEmail to 'True' to prevent errors (required for Ownership transfers)"
            }
            $body = New-Object 'Google.Apis.Drive.v3.Data.Permission'
            foreach ($key in $PSBoundParameters.Keys) {
                switch ($key) {
                    Role {
                        $body.$key = ($PSBoundParameters[$key]).ToLower()
                    }
                    Type {
                        $body.$key = ($PSBoundParameters[$key]).ToLower()
                    }
                    Default {
                        if ($body.PSObject.Properties.Name -contains $key) {
                            $body.$key = $PSBoundParameters[$key]
                        }
                    }
                }
            }
            $request = $service.Permissions.Create($body,$FileId)
            $request.SupportsTeamDrives = $true
            foreach ($key in $PSBoundParameters.Keys) {
                switch ($key) {
                    Default {
                        if ($request.PSObject.Properties.Name -contains $key) {
                            $request.$key = $PSBoundParameters[$key]
                        }
                    }
                }
            }
            Write-Verbose "Adding Drive Permission of '$Role' for user '$User' on Id '$FileID'"
            $request.Execute() | Select-Object @{N = "User";E = {$User}},*
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}