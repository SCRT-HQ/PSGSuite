function Get-GSTeamDrive {
    <#
    .SYNOPSIS
    Gets information about a Team Drive
    
    .DESCRIPTION
    Gets information about a Team Drive
    
    .PARAMETER TeamDriveId
    The unique Id of the Team Drive. If excluded, the list of Team Drives will be returned
    
    .PARAMETER User
    The email or unique Id of the user with access to the Team Drive
    
    .PARAMETER Filter
    Query string for searching Team Drives. See the "Search for Files and Team Drives" guide for the supported syntax: https://developers.google.com/drive/v3/web/search-parameters

    PowerShell filter syntax here is supported as "best effort". Please use Google's filter operators and syntax to ensure best results
    
    .PARAMETER PageSize
    The page size of the result set
    
    .EXAMPLE
    
    #>
    [cmdletbinding(DefaultParameterSetName = "List")]
    Param
    (
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true,ParameterSetName = "Get")]
        [Alias('Id')]
        [String[]]
        $TeamDriveId,
        [parameter(Mandatory = $false,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [Alias('Owner','PrimaryEmail','UserKey','Mail')]
        [string]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [Alias('Q','Query')]
        [String]
        $Filter,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [ValidateRange(1,100)]
        [Int]
        $PageSize = "100"
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
            switch ($PSCmdlet.ParameterSetName) {
                Get {
                    foreach ($id in $TeamDriveId) {
                        $request = $service.Teamdrives.Get($id)
                        Write-Verbose "Getting Team Drive '$id' for user '$User'"
                        $request.Execute() | Select-Object @{N = "User";E = {$User}},*
                    }
                }
                List {
                    $request = $service.Teamdrives.List()
                    $request.PageSize = $PageSize
                    if ($Filter) {
                        $FilterFmt = $Filter -replace " -eq ","=" -replace " -like "," contains " -replace " -match "," contains " -replace " -contains "," contains " -creplace "'True'","True" -creplace "'False'","False" -replace " -in "," in " -replace " -le ",'<=' -replace " -ge ",">=" -replace " -gt ",'>' -replace " -lt ",'<' -replace " -ne ","!=" -replace " -and "," and " -replace " -or "," or " -replace " -not "," not "
                        $request.UseDomainAdminAccess = $true
                        $request.Q = $($FilterFmt -join " ")
                    }
                    Write-Verbose "Getting Team Drives for user '$User'"
                    $request.Execute() | Select-Object -ExpandProperty TeamDrives | Select-Object @{N = "User";E = {$User}},*
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