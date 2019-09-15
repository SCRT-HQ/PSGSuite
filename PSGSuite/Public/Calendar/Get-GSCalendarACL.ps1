function Get-GSCalendarAcl {
    <#
    .SYNOPSIS
    Gets the Access Control List for a calendar

    .DESCRIPTION
    Gets the Access Control List for a calendar

    .PARAMETER User
    The primary email or UserID of the user. You can exclude the '@domain.com' to insert the Domain in the config or use the special 'me' to indicate the AdminEmail in the config.

    Defaults to the AdminEmail in the config

    .PARAMETER CalendarId
    The calendar ID of the calendar you would like to list ACLS for.

    Defaults to the user's primary calendar

    .PARAMETER RuleId
    The Id of the Rule you would like to retrieve specifically. Leave empty to return the full ACL list instead.

    .PARAMETER PageSize
    Maximum number of events returned on one result page.

    .PARAMETER Limit
    The maximum amount of results you want returned. Exclude or set to 0 to return all results

    .EXAMPLE
    Get-GSCalendarACL -User me -CalendarID "primary"

    This gets the ACL on the primary calendar of the AdminUser.

    .LINK
    https://psgsuite.io/Function%20Help/Calendar/Get-GSCalendarACL/

    .LINK
    https://developers.google.com/calendar/v3/reference/acl/get

    .LINK
    https://developers.google.com/calendar/v3/reference/acl/list
    #>
    [OutputType('Google.Apis.Calendar.v3.Data.AclRule')]
    [cmdletbinding(DefaultParameterSetName = 'List')]
    Param
    (
        [parameter(Mandatory = $false,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [Alias('Id')]
        [String[]]
        $CalendarId = "primary",
        [parameter(Mandatory = $false, ParameterSetName = 'Get')]
        [String]
        $RuleId,
        [parameter(Mandatory = $false, ParameterSetName = 'List')]
        [ValidateRange(1,2500)]
        [Int]
        $PageSize = 2500,
        [parameter(Mandatory = $false, ParameterSetName = 'List')]
        [Alias('First')]
        [Int]
        $Limit = 0
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
            foreach ($calId in $CalendarId) {
                try {
                    switch ($PSCmdlet.ParameterSetName) {
                        Get {
                            Write-Verbose "Getting ACL Id '$RuleId' of calendar '$calId' for user '$U'"
                            $request = $service.Acl.Get($calId,$RuleId)
                            $request.Execute() | Add-Member -MemberType NoteProperty -Name 'User' -Value $U -PassThru | Add-Member -MemberType NoteProperty -Name 'CalendarId' -Value $calId -PassThru
                        }
                        List {
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
                            if ($Limit -gt 0 -and $PageSize -gt $Limit) {
                                Write-Verbose ("Reducing PageSize from {0} to {1} to meet limit with first page" -f $PageSize,$Limit)
                                $PageSize = $Limit
                            }
                            $request.MaxResults = $PageSize
                            Write-Verbose "Getting ACL List of calendar '$calId' for user '$U'"
                            [int]$i = 1
                            $overLimit = $false
                            do {
                                $result = $request.Execute()
                                $result.Items | Add-Member -MemberType NoteProperty -Name 'User' -Value $U -PassThru | Add-Member -MemberType NoteProperty -Name 'CalendarId' -Value $calId -PassThru
                                if ($result.NextPageToken) {
                                    $request.PageToken = $result.NextPageToken
                                }
                                [int]$retrieved = ($i + $result.Items.Count) - 1
                                Write-Verbose "Retrieved $retrieved Calendar ACLs..."
                                if ($Limit -gt 0 -and $retrieved -eq $Limit) {
                                    Write-Verbose "Limit reached: $Limit"
                                    $overLimit = $true
                                }
                                elseif ($Limit -gt 0 -and ($retrieved + $PageSize) -gt $Limit) {
                                    $newPS = $Limit - $retrieved
                                    Write-Verbose ("Reducing PageSize from {0} to {1} to meet limit with next page" -f $PageSize,$newPS)
                                    $request.MaxResults = $newPS
                                }
                                [int]$i = $i + $result.Items.Count
                            }
                            until ($overLimit -or !$result.NextPageToken)
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
    }
}
