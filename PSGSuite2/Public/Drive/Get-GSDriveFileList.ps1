function Get-GSDriveFileList {
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
                        $request.Q = $($PSBoundParameters[$key] -join " ")
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