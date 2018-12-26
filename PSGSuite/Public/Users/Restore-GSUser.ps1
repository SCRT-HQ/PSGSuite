function Restore-GSUser {
    <#
    .SYNOPSIS
    Restores a deleted user

    .DESCRIPTION
    Restores a deleted user

    .PARAMETER User
    The email address of the user to restore

    .PARAMETER Id
    The unique Id of the user to restore

    .PARAMETER OrgUnitPath
    The OrgUnitPath to restore the user to

    Defaults to the root OrgUnit "/"

    .PARAMETER RecentOnly
    If multiple users with the email address are found in deleted users, this forces restoration of the most recently deleted user. If not passed and multiple deleted users are found with the specified email address, you will be prompted to choose which you'd like to restore based on deletion time

    .EXAMPLE
    Restore-GSUser -User john.smith@domain.com -OrgUnitPath "/Users/Rehires" -Confirm:$false

    Restores user John Smith to the OrgUnitPath "/Users/Rehires", skipping confirmation. If multiple accounts with the email "john.smith@domain.com" are found, the user is presented with a dialog to choose which account to restore based on deletion time
    #>
    [OutputType('Google.Apis.Admin.Directory.directory_v1.Data.User')]
    [cmdletbinding(SupportsShouldProcess = $true,ConfirmImpact = "Medium",DefaultParameterSetName = 'User')]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true,ParameterSetName = 'User')]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $User,
        [parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true,ParameterSetName = 'Id')]
        [Int]
        $Id,
        [parameter(Mandatory = $false,Position = 1)]
        [String]
        $OrgUnitPath = "/",
        [parameter(Mandatory = $false)]
        [Switch]
        $RecentOnly
    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.user'
            ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        }
        $service = New-GoogleService @serviceParams
        if (!$User) {
            $User =  ($Id | ForEach-Object {"$_"})
            $GetId = $false
        }
    }
    Process {
        try {
            foreach ($U in $User) {
                $body = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.UserUndelete'
                $body.OrgUnitPath = $OrgUnitPath
                if (!$Id) {
                    if ($PSCmdlet.ShouldProcess("Undeleting user '$U'")) {
                        if ($U -notlike "*@*.*") {
                            $U = "$($U)@$($Script:PSGSuite.Domain)"
                        }
                        $delUsers = Get-GSUser -Filter "email=$U" -ShowDeleted -Verbose:$false | Where-Object {$_.PrimaryEmail -eq $U} | Sort-Object DeletionTime -Descending
                        $userId = if ($delUsers.Count -gt 1 -and !$RecentOnly) {
                            $i = 0
                            $options = @()
                            $idHash = @{}
                            $delUsers | ForEach-Object {
                                $i++
                                $optText = "$($i): $($_.DeletionTime.ToString())"
                                $options += @{"&$($optText)" = "User '$($_.PrimaryEmail)' deleted on $($_.DeletionTime.ToLongDateString()) at $($_.DeletionTime.ToLongTimeString())"}
                                $idHash[$optText] = $_.Id
                            }
                            $choice = Read-Prompt -Options $options -Title "`n** Choose Which User To Undelete **`n" -Message "There are $($delUsers.Count) deleted users with the email address '$U'. Please enter the number for the user you would like to undelete based on the time the account was deleted`n"
                            $idHash[$choice]
                        }
                        else {
                            $delUsers[0].Id
                        }
                    }
                }
                else {
                    $userId = $U
                }
                Write-Verbose "Undeleting User Id '$userId' [$U]"
                $request = $service.Users.Undelete($body,$userId)
                $request.Execute()
                Write-Verbose "User '$U' has been successfully undeleted"
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
