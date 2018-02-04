function Get-GSDriveFileList {
    <#
    .SYNOPSIS
    Gets the list of Drive files owned by the user
    
    .DESCRIPTION
    Gets the list of Drive files owned by the user
    
    .PARAMETER User
    The email or unique Id of the user whose Drive files you are trying to list

    Defaults to the AdminEmail user
    
    .PARAMETER Filter
    A query for filtering the file results. See the "Search for Files and Team Drives" guide for the supported syntax: https://developers.google.com/drive/v3/web/search-parameters

    PowerShell filter syntax here is supported as "best effort". Please use Google's filter operators and syntax to ensure best results
    
    .PARAMETER TeamDriveId
    ID of Team Drive to search
    
    .PARAMETER ParentFolderId
    ID of parent folder to search to add to the filter
    
    .PARAMETER IncludeTeamDriveItems
    Whether Team Drive items should be included in results. (Default: false)
    
    .PARAMETER Corpora
    Comma-separated list of bodies of items (files/documents) to which the query applies. Supported bodies are 'User', 'Domain', 'TeamDrive' and 'AllTeamDrives'. 'AllTeamDrives' must be combined with 'User'; all other values must be used in isolation. Prefer 'User' or 'TeamDrive' to 'AllTeamDrives' for efficiency.
    
    .PARAMETER Spaces
    A comma-separated list of spaces to query within the corpus. Supported values are 'Drive', 'AppDataFolder' and 'Photos'.
    
    .PARAMETER OrderBy
    A comma-separated list of sort keys. Valid keys are 'createdTime', 'folder', 'modifiedByMeTime', 'modifiedTime', 'name', 'name_natural', 'quotaBytesUsed', 'recency', 'sharedWithMeTime', 'starred', and 'viewedByMeTime'.
    
    .PARAMETER PageSize
    The page size of the result set
    
    .EXAMPLE
    Get-GSDriveFileList joe

    Gets Joe's Drive file list
    #>
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [Alias('Owner','PrimaryEmail','UserKey','Mail')]
        [string]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false)]
        [Alias('Q','Query')]
        [String[]]
        $Filter,
        [parameter(Mandatory = $false)]
        [String]
        $TeamDriveId,
        [parameter(Mandatory = $false)]
        [String]
        $ParentFolderId,
        [parameter(Mandatory = $false)]
        [Switch]
        $IncludeTeamDriveItems,
        [parameter(Mandatory = $false)]
        [ValidateSet('user','domain','teamDrive')]
        [String]
        $Corpora,
        [parameter(Mandatory = $false)]
        [ValidateSet('drive','appDataFolder','photos')]
        [String[]]
        $Spaces,
        [parameter(Mandatory = $false)]
        [ValidateSet('createdTime','folder','modifiedByMeTime','modifiedTime','name','quotaBytesUsed','recency','sharedWithMeTime','starred','viewedByMeTime')]
        [String[]]
        $OrderBy,
        [parameter(Mandatory = $false)]
        [Alias('MaxResults')]
        [ValidateScript( {[int]$_ -le 1000})]
        [Int]
        $PageSize = "1000"
    )
    Begin {
        if ($TeamDriveId) {
            $PSBoundParameters['Corpora'] = 'teamDrive'
            $PSBoundParameters['IncludeTeamDriveItems'] = $true
        }
        if ($ParentFolderId) {
            if ($Filter) {
                $Filter += "'$ParentFolderId' in parents"
                $PSBoundParameters['Filter'] += "'$ParentFolderId' in parents"
            }
            else {
                $Filter = "'$ParentFolderId' in parents"
                $PSBoundParameters['Filter'] = "'$ParentFolderId' in parents"
            }
        }
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
            $request = $service.Files.List()
            $request.SupportsTeamDrives = $true
            $request.Fields = 'files,kind,nextPageToken'
            if ($PageSize) {
                $request.PageSize = $PageSize
            }
            foreach ($key in $PSBoundParameters.Keys) {
                switch ($key) {
                    Filter {
                        $FilterFmt = $PSBoundParameters[$key] -replace " -eq ","=" -replace " -like ",":" -replace " -match ",":" -replace " -contains ",":" -creplace "'True'","True" -creplace "'False'","False" -replace " -in "," in " -replace " -le ",'<=' -replace " -ge ",">=" -replace " -gt ",'>' -replace " -lt ",'<' -replace " -ne ","!=" -replace " -and "," and " -replace " -or "," or " -replace " -not "," not "
                        $request.Q = $($FilterFmt -join " ")
                    }
                    Spaces {
                        $request.$key = $($PSBoundParameters[$key] -join ",")
                    }
                    Default {
                        if ($request.PSObject.Properties.Name -contains $key) {
                            $request.$key = $PSBoundParameters[$key]
                        }
                    }
                }
            }
            if ($Filter) {
                Write-Verbose "Getting all Drive Files matching filter '$Filter' for user '$User'"
            }
            else {
                Write-Verbose "Getting all Drive Files for user '$User'"
            }
            $response = @()
            [int]$i = 1
            do {
                $result = $request.Execute()
                $response += $result.Files | Select-Object @{N = 'User';E = {$User}},*
                if ($result.NextPageToken) {
                    $request.PageToken = $result.NextPageToken
                }
                [int]$retrieved = ($i + $result.Files.Count) - 1
                Write-Verbose "Retrieved $retrieved Files..."
                [int]$i = $i + $result.Files.Count
            }
            until (!$result.NextPageToken)
            $response
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}