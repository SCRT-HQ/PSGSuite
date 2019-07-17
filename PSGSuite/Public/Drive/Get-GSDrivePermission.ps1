function Get-GSDrivePermission {
    <#
    .SYNOPSIS
    Gets permission information for a Drive file

    .DESCRIPTION
    Gets permission information for a Drive file

    .PARAMETER User
    The email or unique Id of the user whose Drive file permission you are trying to get

    Defaults to the AdminEmail user

    .PARAMETER FileId
    The unique Id of the Drive file

    .PARAMETER PermissionId
    The unique Id of the permission you are trying to get. If excluded, the list of permissions for the Drive file will be returned instead

    .PARAMETER PageSize
    The page size of the result set

    .PARAMETER Limit
    The maximum amount of results you want returned. Exclude or set to 0 to return all results

    .EXAMPLE
    Get-GSDrivePermission -FileId '1rhsAYTOB_vrpvfwImPmWy0TcVa2sgmQa_9u976'

    Gets the list of permissions for the file Id
    #>
    [OutputType('Google.Apis.Drive.v3.Data.Permission')]
    [cmdletbinding(DefaultParameterSetName = "List")]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [Alias('Id')]
        [String]
        $FileId,
        [parameter(Mandatory = $false,Position = 1,ValueFromPipelineByPropertyName = $true)]
        [Alias('Owner','PrimaryEmail','UserKey','Mail')]
        [string]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false,ParameterSetName = "Get")]
        [String[]]
        $PermissionId,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [Alias('MaxResults')]
        [ValidateRange(1,100)]
        [Int]
        $PageSize = 100,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [Alias('First')]
        [Int]
        $Limit = 0
    )
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
            if ($PermissionId) {
                foreach ($per in $PermissionId) {
                    $request = $service.Permissions.Get($FileId,$per)
                    $request.SupportsAllDrives = $true
                    $request.Fields = "*"
                    Write-Verbose "Getting Permission Id '$per' on File '$FileId' for user '$User'"
                    $request.Execute() | Add-Member -MemberType NoteProperty -Name 'User' -Value $User -PassThru | Add-Member -MemberType NoteProperty -Name 'FileId' -Value $FileId -PassThru
                }
            }
            else {
                $request = $service.Permissions.List($FileId)
                $request.SupportsAllDrives = $true
                if ($Limit -gt 0 -and $PageSize -gt $Limit) {
                    Write-Verbose ("Reducing PageSize from {0} to {1} to meet limit with first page" -f $PageSize,$Limit)
                    $PageSize = $Limit
                }
                $request.PageSize = $PageSize
                $request.Fields = "*"
                Write-Verbose "Getting Permission list on File '$FileId' for user '$User'"
                [int]$i = 1
                $overLimit = $false
                do {
                    $result = $request.Execute()
                    $result.Permissions | Add-Member -MemberType NoteProperty -Name 'User' -Value $User -PassThru | Add-Member -MemberType NoteProperty -Name 'FileId' -Value $FileId -PassThru
                    if ($result.NextPageToken) {
                        $request.PageToken = $result.NextPageToken
                    }
                    [int]$retrieved = ($i + $result.Permissions.Count) - 1
                    Write-Verbose "Retrieved $retrieved Permissions..."
                    if ($Limit -gt 0 -and $retrieved -eq $Limit) {
                        Write-Verbose "Limit reached: $Limit"
                        $overLimit = $true
                    }
                    elseif ($Limit -gt 0 -and ($retrieved + $PageSize) -gt $Limit) {
                        $newPS = $Limit - $retrieved
                        Write-Verbose ("Reducing PageSize from {0} to {1} to meet limit with next page" -f $PageSize,$newPS)
                        $request.PageSize = $newPS
                    }
                    [int]$i = $i + $result.Permissions.Count
                }
                until (!$result.NextPageToken)
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
