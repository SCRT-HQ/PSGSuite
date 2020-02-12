function Remove-GSDriveFile {
    <#
    .SYNOPSIS
    Deletes a Drive file

    .DESCRIPTION
    Deletes a Drive file

    .PARAMETER FileId
    The unique Id(s) of the file(s) to delete

    .PARAMETER InputObject
    The Drive file object(s) to delete

    .PARAMETER User
    The email or unique Id of the owner of the Drive file

    Defaults to the AdminEmail user

    .EXAMPLE
    Remove-GSDriveFile -FileId '1rhsAYTOB_vrpvfwImPmWy0TcVa2sgmQa_9u976' -User user@domain.com

    Deletes the file with ID 1rhsAYTOB_vrpvfwImPmWy0TcVa2sgmQa_9u976 from the user user@domain.com's Drive
    
    .EXAMPLE
    Get-GSDriveFile -FileId '1rhsAYTOB_vrpvfwImPmWy0TcVa2sgmQa_9u976' -User user@domain.com | Remove-GSDriveFile

    Get the file with ID 1rhsAYTOB_vrpvfwImPmWy0TcVa2sgmQa_9u976 from the user user@domain.com's Drive and pipeline
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    Param
    (
        [parameter(Position = 0, ParameterSetName = "FileIdSet")]
        [String[]]
        $FileId,
        [parameter(ValueFromPipeline = $true, ParameterSetName = "FileObjectSet")]
        [Google.Apis.Drive.v3.Data.File[]]
        $InputObject,        
        [parameter(ValueFromPipelineByPropertyName = $true, ParameterSetName = "FileIdSet")]
        [parameter(ValueFromPipelineByPropertyName = $true, ParameterSetName = "FileObjectSet")]
        [Alias('Owner', 'PrimaryEmail', 'UserKey', 'Mail')]
        [string]
        $User = $Script:PSGSuite.AdminEmail        
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
        function deleteUserFile {
            Param
            (
                [parameter(Mandatory = $true, Position = 0)]
                [String]
                $User,            
                [parameter(Mandatory = $true, Position = 1)]
                [String]
                $FileId
            )
            
            try {
                if ($PSCmdlet.ShouldProcess("Deleting File Id '$FileId' from user '$User'")) {
                    Write-Verbose "Deleting File Id '$FileId' from user '$User'"
                    $request = $service.Files.Delete($FileId)
                    $request.SupportsAllDrives = $true
                    $request.Execute() | Out-Null
                    Write-Verbose "File Id '$FileId' successfully deleted from user '$User'"
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
        
        foreach ($file in $FileId) {
            deleteUserFile -User $User -FileId $file
        }
        
        foreach ($obj in $InputObject) {
            deleteUserFile -User $User -FileId $obj.Id
        }
        
    }
}
