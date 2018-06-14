function Get-GSCalendarACL {
    <#
    .SYNOPSIS
    Gets the ACL calendar for a calendar
    
    .DESCRIPTION
    Gets the ACL for a calendar 
    
    .PARAMETER User
    The primary email or UserID of the user. You can exclude the '@domain.com' to insert the Domain in the config or use the special 'me' to indicate the AdminEmail in the config.

    Defaults to the AdminEmail in the config
    
    .PARAMETER CalendarId
    The calendar ID of the calendar you would like to list ACLS for.

    Defaults to the user's primary calendar
    
    .PARAMETER PageSize
    Maximum number of events returned on one result page.
    
    .EXAMPLE
    Get-GSCalendarACL -User me -CalendarID "primary"
    
    This gets the ACL on the primary calendar of the Admin.
    #>
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
        $CalendarId = "primary",
        [parameter(Mandatory = $false)]
        [ValidateRange(1,2500)]
        [Int]
        $PageSize = 2500
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
                foreach ($calId in $CalendarId) {
                    $request = $service.Acl.List($calId)
                    foreach ($key in $PSBoundParameters.Keys | Where-Object {$_ -ne 'CalendarId'}) {
                        switch ($key) {
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
                    Write-Verbose "Getting Calendar ACL List on calendar '$calId' for user '$U'"
                    [int]$i = 1
                    do {
                        $result = $request.Execute()
                        $result.Items | Add-Member -MemberType NoteProperty -Name 'User' -Value $U -PassThru | Add-Member -MemberType NoteProperty -Name 'CalendarId' -Value $calId -PassThru
                        if ($result.NextPageToken) {
                            $request.PageToken = $result.NextPageToken
                        }
                        [int]$retrieved = ($i + $result.Items.Count) - 1
                        Write-Verbose "Retrieved $retrieved Calendar Events..."
                        [int]$i = $i + $result.Items.Count
                    }
                    until (!$result.NextPageToken)
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