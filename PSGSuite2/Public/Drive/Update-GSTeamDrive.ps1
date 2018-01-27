function Update-GSTeamDrive {
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0)]
        [String]
        $TeamDriveId,
        [parameter(Mandatory = $false,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [Alias('Owner','PrimaryEmail','UserKey','Mail')]
        [string]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false)]
        [String]
        $Name,
        [parameter(Mandatory = $false)]
        [Switch]
        $CanAddChildren,
        [parameter(Mandatory = $false)]
        [Switch]
        $CanComment,
        [parameter(Mandatory = $false)]
        [Switch]
        $CanCopy,
        [parameter(Mandatory = $false)]
        [Switch]
        $CanDeleteTeamDrive,
        [parameter(Mandatory = $false)]
        [Switch]
        $CanDownload,
        [parameter(Mandatory = $false)]
        [Switch]
        $CanEdit,
        [parameter(Mandatory = $false)]
        [Switch]
        $CanListChildren,
        [parameter(Mandatory = $false)]
        [Switch]
        $CanManageMembers,
        [parameter(Mandatory = $false)]
        [Switch]
        $CanReadRevisions,
        [parameter(Mandatory = $false)]
        [Switch]
        $CanRemoveChildren,
        [parameter(Mandatory = $false)]
        [Switch]
        $CanRename,
        [parameter(Mandatory = $false)]
        [Switch]
        $CanRenameTeamDrive,
        [parameter(Mandatory = $false)]
        [Switch]
        $CanShare,
        [parameter(Mandatory = $false)]
        [String]
        $AccessToken,
        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $P12KeyPath = $Script:PSGSuite.P12KeyPath,
        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $AppEmail = $Script:PSGSuite.AppEmail
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
            $body = New-Object 'Google.Apis.Drive.v3.Data.TeamDrive'
            $capabilities = New-Object 'Google.Apis.Drive.v3.Data.TeamDrive+CapabilitiesData'
            foreach ($key in $PSBoundParameters.Keys) {
                switch ($key) {
                    Default {
                        if ($capabilities.PSObject.Properties.Name -contains $key) {
                            $capabilities.$key = $PSBoundParameters[$key]
                        }
                        elseif ($body.PSObject.Properties.Name -contains $key) {
                            $body.$key = $PSBoundParameters[$key]
                        }
                    }
                }
            }
            $body.Capabilities = $capabilities
            $request = $service.Teamdrives.Update($body,$TeamDriveId)
            Write-Verbose "Updating Team Drive '$Name' for user '$User'"
            $request.Execute() | Select-Object @{N = "User";E = {$User}},*
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}