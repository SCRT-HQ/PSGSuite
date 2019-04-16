function Remove-GSCalendarAcl {
    <#
    .SYNOPSIS
    Removes an Access Control List rule from a calendar.

    .DESCRIPTION
    Removes an Access Control List rule from a calendar.

    .PARAMETER User
    The primary email or UserID of the user who owns the calendar. You can exclude the '@domain.com' to insert the Domain in the config or use the special 'me' to indicate the AdminEmail in the config.

    .PARAMETER CalendarID
    The calendar ID of the calendar you would like to remove the ACL from.

    .PARAMETER RuleId
    The ACL rule Id to remove.

    .EXAMPLE
    Get-GSCalendar -User joe@domain.com |
        Get-GSCalendarACL |
        Where-Object {$_.Role -eq 'Owner'} |
        Remove-GSCalendarACL

    Gets all the calendars for Joe and finds all ACL rules where
    #>
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    Param
    (
        [parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [String]
        $User,
        [parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true)]
        [String]
        $CalendarID,
        [parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias('Id')]
        [String[]]
        $RuleId
    )
    Process {
        if ($User -ceq 'me') {
            $User = $Script:PSGSuite.AdminEmail
        }
        elseif ($User -notlike "*@*.*") {
            $User = "$($User)@$($Script:PSGSuite.Domain)"
        }
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/calendar'
            ServiceType = 'Google.Apis.Calendar.v3.CalendarService'
            User        = $User
        }
        $service = New-GoogleService @serviceParams
        foreach ($rule in $RuleId) {
            try {
                if ($PSCmdlet.ShouldProcess("Deleting ACL Rule Id '$rule' from Calendar '$CalendarID' for user '$User'")) {
                    Write-Verbose "Deleting ACL Rule Id '$rule' from Calendar '$CalendarID' for user '$User'"
                    $request = $service.Acl.Delete($CalendarID, $rule)
                    $request.Execute()
                    Write-Verbose "ACL Rule Id '$rule' deleted successfully from Calendar '$CalendarID' for user '$User'"
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
}
