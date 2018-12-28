function Get-GSCalendarList {
    <#
    .SYNOPSIS
    Lists all calendars a user has on their calendar list (useful for finding secondary calendars)
    
    .DESCRIPTION
    Lists all calendars a user has on their calendar list (useful for finding secondary calendars)
    
    .PARAMETER User
    The primary email or UserID of the user. You can exclude the '@domain.com' to insert the Domain in the config or use the special 'me' to indicate the AdminEmail in the config.
    
    .PARAMETER ShowDeleted
    Whether to include deleted calendar list entries in the result. Optional. The default is False.

    .PARAMETER ShowHidden
    Whether to show hidden entries. Optional. The default is False.

    .EXAMPLE
    Get-GSCalendarList -User me

    Retrieves all calendars on your calendar list
    #>
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [String]
        $User,
        [Parameter(Mandatory = $false, Position = 1)]
        [bool]
        $ShowDeleted = $false,
        [Parameter(Mandatory = $false, Position = 2)]
        [bool]
        $ShowHidden = $false
    )
    Process {
        try {
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

            $Raw = $Service.CalendarList.List().Execute()
            $ItemList = [object[]]($Raw.Items)
            While ($Null -ne $Raw.NextPageToken){
                $Service.CalendarList.List().setPageToken($Raw.NextPageToken)
                $Raw = $service.CalendarList.List().Execute()
                $ItemList += $Raw.Items
            }
            $ItemList
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