function New-GSCalendarEvent {
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0)]
        [String]
        $Summary,
        [parameter(Mandatory = $false)]
        [String]
        $Description,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [String]
        $CalendarID = "primary",
        [parameter(Mandatory = $false)]
        [String]
        $Location,
        [parameter(Mandatory = $false)]
        [ValidateSet("Periwinkle","Seafoam","Lavender","Coral","Goldenrod","Beige","Cyan","Grey","Blue","Green","Red")]
        [String]
        $EventColor,
        [parameter(Mandatory = $false)]
        [DateTime]
        $LocalStartDateTime = (Get-Date),
        [parameter(Mandatory = $false)]
        [DateTime]
        $LocalEndDateTime = (Get-Date).AddMinutes(30),
        [parameter(Mandatory = $false)]
        [String]
        $StartDate,
        [parameter(Mandatory = $false)]
        [String]
        $EndDate,
        [parameter(Mandatory = $false)]
        [String]
        $UTCStartDateTime,
        [parameter(Mandatory = $false)]
        [String]
        $UTCEndDateTime
    )
    Begin {
        $colorHash = @{
            Periwinkle = 1
            Seafoam    = 2
            Lavender   = 3
            Coral      = 4
            Goldenrod  = 5
            Beige      = 6
            Cyan       = 7
            Grey       = 8
            Blue       = 9
            Green      = 10
            Red        = 11
        }
    }
    Process {
        try {
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
                    $body = New-Object 'Google.Apis.Calendar.v3.Data.Event'
                    foreach ($key in $PSBoundParameters.Keys) {
                        switch ($key) {
                            EventColor {
                                $body.ColorId = $colorHash[$EventColor]
                            }
                            Default {
                                if ($body.PSObject.Properties.Name -contains $key) {
                                    $body.$key = $PSBoundParameters[$key]
                                }
                            }
                        }
                    }
                    $body.Start = if ($UTCStartDateTime) {
                        New-Object 'Google.Apis.Calendar.v3.Data.EventDateTime' -Property @{
                            DateTime = $UTCStartDateTime
                        }
                    }
                    elseif ($StartDate) {
                        New-Object 'Google.Apis.Calendar.v3.Data.EventDateTime' -Property @{
                            Date = (Get-Date $StartDate -Format "yyyy-MM-dd")
                        }
                    }
                    else {
                        New-Object 'Google.Apis.Calendar.v3.Data.EventDateTime' -Property @{
                            DateTime = $LocalStartDateTime
                        }
                    }
                    $body.End = if ($UTCEndDateTime) {
                        New-Object 'Google.Apis.Calendar.v3.Data.EventDateTime' -Property @{
                            DateTime = $UTCEndDateTime
                        }
                    }
                    elseif ($EndDate) {
                        New-Object 'Google.Apis.Calendar.v3.Data.EventDateTime' -Property @{
                            Date = (Get-Date $EndDate -Format "yyyy-MM-dd")
                        }
                    }
                    else {
                        New-Object 'Google.Apis.Calendar.v3.Data.EventDateTime' -Property @{
                            DateTime = $LocalEndDateTime
                        }
                    }
                    Write-Verbose "Creating Calendar Event '$($Summary)' on calendar '$calId' for user '$U'"
                    $request = $service.Events.Insert($body,$calId)
                    $request.Execute() | Select-Object @{N = 'User';E = {$U}},@{N = 'CalendarId';E = {$calId}},*
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}