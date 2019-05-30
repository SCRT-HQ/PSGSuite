function Get-GSDrive {
    <#
    .SYNOPSIS
    Gets information about a Shared Drive

    .DESCRIPTION
    Gets information about a Shared Drive

    .PARAMETER DriveId
    The unique Id of the Shared Drive. If excluded, the list of Shared Drives will be returned

    .PARAMETER User
    The email or unique Id of the user with access to the Shared Drive

    .PARAMETER Filter
    Query string for searching Shared Drives. See the "Search for Files and Shared Drives" guide for the supported syntax: https://developers.google.com/drive/v3/web/search-parameters

    PowerShell filter syntax here is supported as "best effort". Please use Google's filter operators and syntax to ensure best results

    .PARAMETER UseDomainAdminAccess
    Issue the request as a domain administrator; if set to true, then all Shared Drives of the domain in which the requester is an administrator are returned.

    .PARAMETER PageSize
    The page size of the result set

    .PARAMETER Limit
    The maximum amount of results you want returned. Exclude or set to 0 to return all results

    .EXAMPLE
    Get-GSDrive -Limit 3 -UseDomainAdminAccess

    Gets the first 3 Shared Drives in the domain.
    #>
    [OutputType('Google.Apis.Drive.v3.Data.Drive')]
    [cmdletbinding(DefaultParameterSetName = "List")]
    Param
    (
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true,ParameterSetName = "Get")]
        [Alias('Id','TeamDriveId')]
        [String[]]
        $DriveId,
        [parameter(Mandatory = $false,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [Alias('Owner','PrimaryEmail','UserKey','Mail')]
        [string]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [Alias('Q','Query')]
        [String]
        $Filter,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [Switch]
        $UseDomainAdminAccess,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [ValidateRange(1,100)]
        [Int]
        $PageSize = "100",
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [Alias('First')]
        [Int]
        $Limit = 0
    )
    Process {
        if ($UseDomainAdminAccess -or $User -ceq 'me') {
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
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Get {
                    foreach ($id in $DriveId) {
                        $request = $service.Drives.Get($id)
                        Write-Verbose "Getting Shared Drive '$id' for user '$User'"
                        $request.Execute() | Add-Member -MemberType NoteProperty -Name 'User' -Value $User -PassThru
                    }
                }
                List {
                    $request = $service.Drives.List()
                    if ($Limit -gt 0 -and $PageSize -gt $Limit) {
                        Write-Verbose ("Reducing PageSize from {0} to {1} to meet limit with first page" -f $PageSize,$Limit)
                        $PageSize = $Limit
                    }
                    $request.PageSize = $PageSize
                    if ($UseDomainAdminAccess) {
                        $request.UseDomainAdminAccess = $true
                        Write-Verbose "Getting Shared Drives as Domain Admin"
                    }
                    else {
                        Write-Verbose "Getting Shared Drives for user '$User'"
                    }
                    if ($Filter) {
                        $FilterFmt = $Filter -replace " -eq ","=" -replace " -like "," contains " -replace " -match "," contains " -replace " -contains "," contains " -creplace "'True'","True" -creplace "'False'","False" -replace " -in "," in " -replace " -le ",'<=' -replace " -ge ",">=" -replace " -gt ",'>' -replace " -lt ",'<' -replace " -ne ","!=" -replace " -and "," and " -replace " -or "," or " -replace " -not "," not "
                        $request.Q = $($FilterFmt -join " ")
                    }
                    [int]$i = 1
                    $overLimit = $false
                    do {
                        $result = $request.Execute()
                        if ($result.Drives) {
                            $result.Drives | Add-Member -MemberType NoteProperty -Name 'User' -Value $User -PassThru
                        }
                        $request.PageToken = $result.NextPageToken
                        [int]$retrieved = ($i + $result.Drives.Count) - 1
                        Write-Verbose "Retrieved $retrieved Shared Drives..."
                        if ($Limit -gt 0 -and $retrieved -eq $Limit) {
                            $overLimit = $true
                        }
                        elseif ($Limit -gt 0 -and ($retrieved + $PageSize) -gt $Limit) {
                            $newPS = $Limit - $retrieved
                            Write-Verbose ("Reducing PageSize from {0} to {1} to meet limit with next page" -f $PageSize,$newPS)
                            $request.PageSize = $newPS
                        }
                        [int]$i = $i + $result.Drives.Count
                    }
                    until ($overLimit -or !$result.NextPageToken)
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
