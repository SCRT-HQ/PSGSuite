function New-GSCalendarAcl {
    <#
    .SYNOPSIS
    Adds a new Access Control Rule to a calendar.

    .DESCRIPTION
    Adds a new Access Control Rule to a calendar.

    .PARAMETER User
    The primary email or UserID of the user. You can exclude the '@domain.com' to insert the Domain in the config or use the special 'me' to indicate the AdminEmail in the config.

    Defaults to the AdminEmail in the config.

    .PARAMETER CalendarID
    The Id of the calendar you would like to share

    Defaults to the user's primary calendar.

    .PARAMETER Role
    The role assigned to the scope.

    Available values are:
    * "none" - Provides no access.
    * "freeBusyReader" - Provides read access to free/busy information.
    * "reader" - Provides read access to the calendar. Private events will appear to users with reader access, but event details will be hidden.
    * "writer" - Provides read and write access to the calendar. Private events will appear to users with writer access, and event details will be visible.
    * "owner" - Provides ownership of the calendar. This role has all of the permissions of the writer role with the additional ability to see and manipulate ACLs.

    .PARAMETER Value
    The email address of a user or group, or the name of a domain, depending on the scope type. Omitted for type "default".

    .PARAMETER Type
    The type of the scope.

    Available values are:
    * "default" - The public scope. This is the default value.
    * "user" - Limits the scope to a single user.
    * "group" - Limits the scope to a group.
    * "domain" - Limits the scope to a domain.

    Note: The permissions granted to the "default", or public, scope apply to any user, authenticated or not.

    .EXAMPLE
    New-GSCalendarACL -CalendarID jennyappleseed@domain.com -Role reader -Value Jonnyappleseed@domain.com -Type user

    Gives Jonnyappleseed@domain.com reader access to jennyappleseed's calendar.

    .LINK
    https://psgsuite.io/Function%20Help/Calendar/New-GSCalendarACL/
    #>
    [OutputType('Google.Apis.Calendar.v3.Data.AclRule')]
    [cmdletbinding(DefaultParameterSetName = "AttendeeEmails")]
    Param
    (
        [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail", "UserKey", "Mail")]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $User = "me",
        [parameter(Mandatory = $false)]
        [String[]]
        $CalendarId = "primary",
        [parameter(Mandatory = $true)]
        [ValidateSet("owner", "writer", "reader", "none", "freeBusyReader")]
        [String]
        $Role,
        [parameter(Mandatory = $true)]
        [String]
        $Value,
        [parameter(Mandatory = $false)]
        [ValidateSet("default", "user", "group", "domain")]
        [String]
        $Type = "user"
    )
    Process {
        foreach ($U in $User) {
            if ($U -ceq 'me') {
                $U = $Script:PSGSuite.AdminEmail
            }
            elseif ($U -notlike "*@*.*") {
                $U = "$($U)@$($Script:PSGSuite.Domain)"
            }
            $serviceParams = @{
                Scope       = 'https://www.googleapis.com/auth/calendar'
                ServiceType = 'Google.Apis.Calendar.v3.CalendarService'
                User        = $U
            }
            $service = New-GoogleService @serviceParams
            foreach ($calId in $CalendarID) {
                try {
                    $body = New-Object 'Google.Apis.Calendar.v3.Data.AclRule'
                    $scopeData = New-Object "Google.Apis.Calendar.v3.Data.AclRule+ScopeData"
                    foreach ($key in $PSBoundParameters.Keys) {
                        switch ($key) {
                            Role {
                                $body.Role = $PSBoundParameters[$key]
                            }
                            Type {
                                $scopeData.Type = $PSBoundParameters[$key]
                            }
                            Value {
                                $scopeData.Value = $PSBoundParameters[$key]
                            }
                            Default {
                                if ($body.PSObject.Properties.Name -contains $key) {
                                    $body.$key = $PSBoundParameters[$key]
                                }
                            }
                        }
                    }
                    Write-Verbose "Inserting new ACL for type '$Type' with value '$Value' in role '$Role'  on calendar '$calId' for user '$U'"
                    $body.Scope = $scopeData
                    $request = $service.Acl.Insert($body, $calId)
                    $request.Execute()
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
}
