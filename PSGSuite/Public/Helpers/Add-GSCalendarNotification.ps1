function Add-GSCalendarNotification {
    <#
    .SYNOPSIS
    Builds an CalendarNotification object to use when creating or updating a CalendarSubscription

    .DESCRIPTION
    Builds an CalendarNotification object to use when creating or updating a CalendarSubscription

    .PARAMETER Method
    The method used to deliver the notification.

    Possible values are:
    * "email" - Reminders are sent via email.
    * "sms" - Reminders are sent via SMS. This value is read-only and is ignored on inserts and updates. SMS reminders are only available for G Suite customers.

    .PARAMETER Type
    The type of notification.

    Possible values are:
    * "eventCreation" - Notification sent when a new event is put on the calendar.
    * "eventChange" - Notification sent when an event is changed.
    * "eventCancellation" - Notification sent when an event is cancelled.
    * "eventResponse" - Notification sent when an event is changed.
    * "agenda" - An agenda with the events of the day (sent out in the morning).

    .PARAMETER InputObject
    Used for pipeline input of an existing IM object to strip the extra attributes and prevent errors

    .EXAMPLE

    #>
    [OutputType('Google.Apis.Calendar.v3.Data.CalendarNotification')]
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory, ParameterSetName = "Fields")]
        [ValidateSet('email','sms')]
        [String]
        $Method,
        [Parameter(Mandatory, ParameterSetName = "Fields")]
        [ValidateSet('eventCreation','eventChange','eventCancellation','eventResponse','agenda')]
        [String]
        $Type,
        [Parameter(ValueFromPipeline, ParameterSetName = "InputObject")]
        [Google.Apis.Calendar.v3.Data.CalendarNotification[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    New-Object 'Google.Apis.Calendar.v3.Data.CalendarNotification' -Property @{
                        Method = $Method
                        Type = $Type
                    }
                }
                InputObject {
                    foreach ($iObj in $InputObject) {
                        New-Object 'Google.Apis.Calendar.v3.Data.CalendarNotification' -Property @{
                            Method = $iObj.Method
                            Type = $iObj.Type
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
