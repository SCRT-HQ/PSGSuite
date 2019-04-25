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

    .PARAMETER Fields
    The specific fields to fetch for the listed files.

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
                $Filter = @("'$ParentFolderId' in parents")
                $PSBoundParameters['Filter'] = @("'$ParentFolderId' in parents")
            }
        }
        if ($Fields -notcontains '*' -and $Fields -notcontains 'nextPageToken') {
            $Fields += 'nextPageToken'
        }
    }
    Process {
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
        try {
            $request = $service.Files.List()
            $request.SupportsTeamDrives = $true
            if ($PageSize) {
                $request.PageSize = $PageSize
            }
            foreach ($key in $PSBoundParameters.Keys) {
                switch ($key) {
                    Filter {
                        $FilterFmt = ($PSBoundParameters[$key] -join " and ") -replace " -eq ","=" -replace " -like ",":" -replace " -match ",":" -replace " -contains ",":" -creplace "'True'","True" -creplace "'False'","False" -replace " -in "," in " -replace " -le ",'<=' -replace " -ge ",">=" -replace " -gt ",'>' -replace " -lt ",'<' -replace " -ne ","!=" -replace " -and "," and " -replace " -or "," or " -replace " -not "," not "
                        $request.Q = $FilterFmt
                    }
                    Fields {
                        $request.Fields = "$($Fields -join ",")"
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
            do {
                $result = $request.Execute()
                $result.Files | Add-Member -MemberType NoteProperty -Name 'User' -Value $User -PassThru
                if ($result.NextPageToken) {
                    $request.PageToken = $result.NextPageToken
                }
                [int]$retrieved = ($i + $result.Files.Count) - 1
                Write-Verbose "Retrieved $retrieved Files..."
                [int]$i = $i + $result.Files.Count
            }
            until (!$result.NextPageToken)
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
