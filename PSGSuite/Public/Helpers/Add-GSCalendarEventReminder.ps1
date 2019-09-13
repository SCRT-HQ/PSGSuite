function Add-GSCalendarEventReminder {
    <#
    .SYNOPSIS
    Builds an EventReminder object to use when creating or updating a CalendarSubscription or CalendarEvent

    .DESCRIPTION
    Builds an EventReminder object to use when creating or updating a CalendarSubscription or CalendarEvent

    .PARAMETER Method
    The method used by this reminder. Defaults to email.

    Possible values are:
    * "email" - Reminders are sent via email.
    * "sms" - Reminders are sent via SMS. These are only available for G Suite customers. Requests to set SMS reminders for other account types are ignored.
    * "popup" - Reminders are sent via a UI popup.

    .PARAMETER Minutes
    Number of minutes before the start of the event when the reminder should trigger. Defaults to 30 minutes.

    Valid values are between 0 and 40320 (4 weeks in minutes).

    .PARAMETER InputObject
    Used for pipeline input of an existing IM object to strip the extra attributes and prevent errors

    .EXAMPLE

    #>
    [OutputType('Google.Apis.Calendar.v3.Data.EventReminder')]
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory, ParameterSetName = "Fields")]
        [ValidateSet('email','sms','popup')]
        [String]
        $Method,
        [Parameter(Mandatory, ParameterSetName = "Fields")]
        [Int]
        $Minutes,
        [Parameter(ValueFromPipeline, ParameterSetName = "InputObject")]
        [Google.Apis.Calendar.v3.Data.EventReminder[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    New-Object 'Google.Apis.Calendar.v3.Data.EventReminder' -Property @{
                        Method = $Method
                        Minutes = $Minutes
                    }
                }
                InputObject {
                    foreach ($iObj in $InputObject) {
                        New-Object 'Google.Apis.Calendar.v3.Data.EventReminder' -Property @{
                            Method = $iObj.Method
                            Minutes = $iObj.Minutes
                        }
                    }
                }
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
