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

    .PARAMETER Recurse
    If True, recurses through subfolders found underneath primary search results

    .PARAMETER IncludeTeamDriveItems
    Whether Team Drive items should be included in results. (Default: false)

    .PARAMETER Corpora
    Comma-separated list of bodies of items (files/documents) to which the query applies. Supported bodies are 'User', 'Domain', 'TeamDrive' and 'AllTeamDrives'. 'AllTeamDrives' must be combined with 'User'; all other values must be used in isolation. Prefer 'User' or 'TeamDrive' to 'AllTeamDrives' for efficiency.

    .PARAMETER Fields
    The specific fields to fetch for the listed files.

    .PARAMETER Spaces
    A comma-separated list of spaces to query within the corpus. Supported values are 'Drive', 'AppDataFolder' and 'Photos'.

    .PARAMETER OrderBy
    A comma-separated list of sort keys. Valid keys are 'createdTime', 'folder', 'modifiedByMeTime', 'modifiedTime', 'name', 'name_natural', 'quotaBytesUsed', 'recency', 'sharedWithMeTime', 'starred', and 'viewedByMeTime'.

    .PARAMETER PageSize
    The page size of the result set

    .PARAMETER Limit
    The maximum amount of results you want returned. Exclude or set to 0 to return all results

    .EXAMPLE
    Get-GSDriveFileList joe

    Gets Joe's Drive file list
    #>
    [OutputType('Google.Apis.Drive.v3.Data.File')]
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
        $Recurse,
        [parameter(Mandatory = $false)]
        [Switch]
        $IncludeTeamDriveItems,
        [parameter(Mandatory = $false)]
        [String[]]
        $Fields = @('files','kind','nextPageToken'),
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
        [ValidateRange(1,1000)]
        [Int]
        $PageSize = 1000,
        [parameter(Mandatory = $false)]
        [Alias('First')]
        [Int]
        $Limit = 0
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
                $Filter = @("'$ParentFolderId' in parents")
                $PSBoundParameters['Filter'] = @("'$ParentFolderId' in parents")
            }
        }
        if ($Fields -notcontains '*' -and $Fields -notcontains 'nextPageToken') {
            $Fields += 'nextPageToken'
        }
    }
    Process {
        Resolve-Email ([ref]$User)
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/drive'
            ServiceType = 'Google.Apis.Drive.v3.DriveService'
            User        = $User
        }
        $service = New-GoogleService @serviceParams
        try {
            $request = $service.Files.List()
            $request.SupportsAllDrives = $true
            if ($Limit -gt 0 -and $PageSize -gt $Limit) {
                Write-Verbose ("Reducing PageSize from {0} to {1} to meet limit with first page" -f $PageSize,$Limit)
                $PageSize = $Limit
            }
            $request.PageSize = $PageSize
            if ($Fields) {
                $request.Fields = "$($Fields -join ",")"
            }
            foreach ($key in $PSBoundParameters.Keys | Where-Object { $_ -notin @('Fields','PageSize') }) {
                switch ($key) {
                    Filter {
                        $FilterFmt = ($PSBoundParameters[$key] -join " and ") -replace " -eq ","=" -replace " -like ",":" -replace " -match ",":" -replace " -contains ",":" -creplace "'True'","True" -creplace "'False'","False" -replace " -in "," in " -replace " -le ",'<=' -replace " -ge ",">=" -replace " -gt ",'>' -replace " -lt ",'<' -replace " -ne ","!=" -replace " -and "," and " -replace " -or "," or " -replace " -not "," not "
                        $request.Q = $FilterFmt
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
            $baseVerbose = "Getting"
            if ($Fields) {
                $baseVerbose += " Fields [$($Fields -join ",")] of"
            }
            $baseVerbose += " all Drive Files for User '$User'"
            if ($FilterFmt) {
                $baseVerbose += " matching Filter: $FilterFmt"
            }
            Write-Verbose $baseVerbose
            [int]$i = 1
            $overLimit = $false
            $originalLimit = $Limit
            do {
                $result = $request.Execute()
                $result.Files | Add-Member -MemberType NoteProperty -Name 'User' -Value $User -PassThru
                [int]$retrieved = ($i + $result.Files.Count) - 1
                if ($Recurse -and ($Limit -eq 0 -or $retrieved -lt $Limit)) {
                    Write-Verbose "Starting recursive search..."
                    if ($Limit -gt 0) {
                        $Limit = $Limit - $result.Files.Count
                        Write-Verbose "[Prerecursion] Limit reduced to $Limit to account for $($result.Files.Count) files found in main search"
                    }
                    foreach ($subFolder in ($result.Files | Where-Object { $_.MimeType -eq 'application/vnd.google-apps.folder' } | Sort-Object Name)) {
                        Write-Verbose "Getting recursive file list of files under subfolder $($subFolder.Name) [$($subFolder.Id)]"
                        $params = @{
                            PageSize              = $PageSize
                            User                  = $User
                            ParentFolderId        = $subfolder.Id
                            IncludeTeamDriveItems = $IncludeTeamDriveItems
                            Recurse               = $true
                            Fields                = $Fields
                            Limit                 = $Limit
                            Verbose               = $false
                        }
                        Get-GSDriveFileList @params -OutVariable sub
                        Write-Verbose "Found $($sub.Count) files in subfolder $($subfolder.Name) [$($subfolder.Id)]"
                        [int]$retrieved += $sub.Count
                        if ($originalLimit -gt 0) {
                            $Limit = $originalLimit - $retrieved
                            Write-Verbose "[Postrecursion] Limit reduced to $Limit"
                            if ($retrieved -ge $originalLimit) {
                                break
                            }
                        }
                    }
                }
                if ($result.NextPageToken) {
                    $request.PageToken = $result.NextPageToken
                }
                Write-Verbose "Retrieved $retrieved Files..."
                if ($originalLimit -gt 0 -and $retrieved -ge $originalLimit) {
                    Write-Verbose "Limit reached: $originalLimit"
                    $overLimit = $true
                }
                elseif ($originalLimit -gt 0 -and ($retrieved + $PageSize) -gt $originalLimit) {
                    $newPS = $originalLimit - $retrieved
                    Write-Verbose ("Reducing PageSize from {0} to {1} to meet limit with next page" -f $PageSize,$newPS)
                    $request.PageSize = $newPS
                }
                [int]$i = $i + $result.Files.Count
            }
            until ($overLimit -or !$result.NextPageToken)
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
