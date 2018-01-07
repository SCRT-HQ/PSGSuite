function Restore-GSUser {
    <#
.Synopsis
   Restores a deleted Google user
.DESCRIPTION
   Restores a deleted Google user
.EXAMPLE
   Restore-GSUser -User john.smith@domain.com -OrgUnitPath "/Users/Rehires" -WhatIf
.EXAMPLE
   Restore-GSUser -User john.smith@domain.com -OrgUnitPath "/Users/Rehires" -Confirm:$false
#>
    [cmdletbinding(SupportsShouldProcess = $true,ConfirmImpact = "Medium")]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $User,
        [parameter(Mandatory = $true,Position = 1)]
        [String]
        $OrgUnitPath,
        [parameter(Mandatory = $false)]
        [Switch]
        $RecentOnly
    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.user'
            ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        }
        $body = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.UserUndelete'
        $body.OrgUnitPath = $OrgUnitPath
        $service = New-GoogleService @serviceParams
    }
    Process {
        try {
            foreach ($U in $User) {
                if ($U -notlike "*@*.*") {
                    $U = "$($U)@$($Script:PSGSuite.Domain)"
                }
                if ($PSCmdlet.ShouldProcess("Undeleting user '$U'")) {
                    Write-Verbose "Undeleting user '$U'"
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
                    $request = $service.Users.Undelete($body,$userId)
                    $request.Execute()
                    Write-Verbose "User '$U' has been successfully undeleted"
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}