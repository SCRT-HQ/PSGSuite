function Get-GSDrivePermission {
    [cmdletbinding(DefaultParameterSetName = "List")]
    Param
    (
        [parameter(Mandatory = $false,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [Alias('Owner','PrimaryEmail','UserKey','Mail')]
        [string]
        $User = $Script:PSGSuite.AdminEmail, 
        [parameter(Mandatory = $true)]
        [String]
        $FileId, 
        [parameter(Mandatory = $false,ParameterSetName = "Get")]
        [String[]]
        $PermissionId,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [Alias('MaxResults')]
        [ValidateScript( {[int]$_ -le 100})]
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
            if ($PermissionId) {
                foreach ($per in $PermissionId) {
                    $request = $service.Permissions.Get($FileId,$per)
                    Write-Verbose "Getting Permission Id '$per' on File '$FileId' for user '$User'"
                    $request.Execute() | Select-Object @{N = 'User';E = {$User}},@{N = 'FileId';E = {$FileId}},*
                }
            }
            else {
                $request = $service.Permissions.List($FileId)
                $request.PageSize = $PageSize
                Write-Verbose "Getting Permission list on File '$FileId' for user '$User'"
                $response = @()
                [int]$i = 1
                do {
                    $result = $request.Execute()
                    $response += $result.Permissions | Select-Object @{N = 'User';E = {$User}},@{N = 'FileId';E = {$FileId}},*
                    if ($result.NextPageToken) {
                        $request.PageToken = $result.NextPageToken
                    }
                    [int]$retrieved = ($i + $result.Permissions.Count) - 1
                    Write-Verbose "Retrieved $retrieved Permissions..."
                    [int]$i = $i + $result.Permissions.Count
                }
                until (!$result.NextPageToken)
                $response
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}