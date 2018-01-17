function Update-GSTeamDrive {
    [cmdletbinding()]
    Param
    (
      [parameter(Mandatory=$true,Position=0)]
      [String]
      $TeamDriveId,
      [parameter(Mandatory = $false,Position = 0,ValueFromPipelineByPropertyName = $true)]
      [Alias('Owner','PrimaryEmail','UserKey','Mail')]
      [string]
      $User = $Script:PSGSuite.AdminEmail,
      [parameter(Mandatory=$false)]
      [String]
      $Name,
      [parameter(Mandatory=$false)]
      [ValidateSet($true,$false)]
      [String]
      $CanAddChildren,
      [parameter(Mandatory=$false)]
      [ValidateSet($true,$false)]
      [String]
      $CanComment,
      [parameter(Mandatory=$false)]
      [ValidateSet($true,$false)]
      [String]
      $CanCopy,
      [parameter(Mandatory=$false)]
      [ValidateSet($true,$false)]
      [String]
      $CanDeleteTeamDrive,
      [parameter(Mandatory=$false)]
      [ValidateSet($true,$false)]
      [String]
      $CanDownload,
      [parameter(Mandatory=$false)]
      [ValidateSet($true,$false)]
      [String]
      $CanEdit,
      [parameter(Mandatory=$false)]
      [ValidateSet($true,$false)]
      [String]
      $CanListChildren,
      [parameter(Mandatory=$false)]
      [ValidateSet($true,$false)]
      [String]
      $CanManageMembers,
      [parameter(Mandatory=$false)]
      [ValidateSet($true,$false)]
      [String]
      $CanReadRevisions,
      [parameter(Mandatory=$false)]
      [ValidateSet($true,$false)]
      [String]
      $CanRemoveChildren,
      [parameter(Mandatory=$false)]
      [ValidateSet($true,$false)]
      [String]
      $CanRename,
      [parameter(Mandatory=$false)]
      [ValidateSet($true,$false)]
      [String]
      $CanRenameTeamDrive,
      [parameter(Mandatory=$false)]
      [ValidateSet($true,$false)]
      [String]
      $CanShare,
      [parameter(Mandatory=$false)]
      [String]
      $AccessToken,
      [parameter(Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [String]
      $P12KeyPath = $Script:PSGSuite.P12KeyPath,
      [parameter(Mandatory=$false)]
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