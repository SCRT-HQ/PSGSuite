function Get-GSCalendarEventList {
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false)]
        [String]
        $CalendarID = "primary",
        [parameter(Mandatory = $false)]
        [Alias('Q','Query')]
        [String]
        $Filter,
        [parameter(Mandatory = $false)]
        [ValidateSet("StartTime","Updated")]
        [String]
        $OrderBy,
        [parameter(Mandatory = $false)]
        [Int]
        $MaxAttendees,
        [parameter(Mandatory = $false)]
        [ValidateScript( {[int]$_ -le 2500})]
        [Int]
        $PageSize = 2500,
        [parameter(Mandatory = $false)]
        [switch]
        $ShowDeleted,
        [parameter(Mandatory = $false)]
        [switch]
        $ShowHiddenInvitations,
        [parameter(Mandatory = $false)]
        [switch]
        $SingleEvents,
        [parameter(Mandatory = $false)]
        [DateTime]
        $TimeMin,
        [parameter(Mandatory = $false)]
        [DateTime]
        $TimeMax
    )
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
                    $request = $service.Events.List($calId)
                    foreach ($key in $PSBoundParameters.Keys) {
                        switch ($key) {
                            Filter {
                                $request.Q = $Filter
                            }
                            Default {
                                if ($request.PSObject.Properties.Name -contains $key) {
                                    $request.$key = $PSBoundParameters[$key]
                                }
                            }
                        }
                    }
                    if ($PageSize) {
                        $request.MaxResults = $PageSize
                    }
                    if ($Filter) {
                        Write-Verbose "Getting all Calendar Events matching filter '$Filter' on calendar '$calId' for user '$U'"
                    }
                    else {
                        Write-Verbose "Getting all Calendar Events on calendar '$calId' for user '$U'"
                    }
                    $response = @()
                    [int]$i = 1
                    do {
                        $result = $request.Execute()
                        $response += $result.Items | Select-Object @{N = 'User';E = {$U}},@{N = 'CalendarId';E = {$calId}},*
                        if ($result.NextPageToken) {
                            $request.PageToken = $result.NextPageToken
                        }
                        [int]$retrieved = ($i + $result.Items.Count) - 1
                        Write-Verbose "Retrieved $retrieved Calendar Events..."
                        [int]$i = $i + $result.Items.Count
                    }
                    until (!$result.NextPageToken)
                    $response
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}