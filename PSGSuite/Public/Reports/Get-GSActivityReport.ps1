function Get-GSActivityReport {
    <#
    .SYNOPSIS
    Retrieves a list of activities
    
    .DESCRIPTION
    Retrieves a list of activities
    
    .PARAMETER UserKey
    Represents the profile id or the user email for which the data should be filtered. When 'all' is specified as the userKey, it returns usageReports for all users
    
    .PARAMETER ApplicationName
    Application name for which the events are to be retrieved. 
    
    Available values are:
    * "Admin": The Admin console application's activity reports return account information about different types of administrator activity events.
    * "Calendar": The G Suite Calendar application's activity reports return information about various Calendar activity events.
    * "Drive": The Google Drive application's activity reports return information about various Google Drive activity events. The Drive activity report is only available for G Suite Business customers.
    * "Groups": The Google Groups application's activity reports return information about various Groups activity events.
    * "GPlus": The Google+ application's activity reports return information about various Google+ activity events.
    * "Login": The G Suite Login application's activity reports return account information about different types of Login activity events.
    * "Mobile": The G Suite Mobile Audit activity report return information about different types of Mobile Audit activity events.
    * "Rules": The G Suite Rules activity report return information about different types of Rules activity events.
    * "Token": The G Suite Token application's activity reports return account information about different types of Token activity events.

    Defaults to "Admin"
    
    .PARAMETER EventName
    The name of the event being queried
    
    .PARAMETER ActorIpAddress
    IP Address of host where the event was performed. Supports both IPv4 and IPv6 addresses
    
    .PARAMETER EndTime
    Return events which occurred at or before this time
    
    .PARAMETER Filters
    Event parameters in the form [parameter1 name][operator][parameter1 value]
    
    .PARAMETER PageSize
    Number of activity records to be shown in each page
    
    .EXAMPLE
    Get-GSActivityReport -StartTime (Get-Date).AddDays(-30)

    Gets the admin activity report for the last 30 days
    #>
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false,Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $UserKey = 'all',
        [parameter(Mandatory = $false,Position = 1)]
        [ValidateSet("Admin","Calendar","Drive","Groups","GPlus","Login","Mobile","Rules","Token")]
        [String]
        $ApplicationName = "Admin",
        [parameter(Mandatory = $false,Position = 2)]
        [String]
        $EventName,
        [parameter(Mandatory = $false)]
        [DateTime]
        $StartTime,
        [parameter(Mandatory = $false)]
        [DateTime]
        $EndTime,
        [parameter(Mandatory = $false)]
        [String]
        $ActorIpAddress,
        [parameter(Mandatory = $false)]
        [String[]]
        $Filters,
        [parameter(Mandatory = $false)]
        [ValidateRange(1,1000)]
        [Alias("MaxResults")]
        [Int]
        $PageSize = "1000"
    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.reports.audit.readonly'
            ServiceType = 'Google.Apis.Admin.Reports.reports_v1.ReportsService'
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        try {
            if ($UserKey -notlike "*@*.*" -and $UserKey -cne 'all') {
                $UserKey = "$($UserKey)@$($Script:PSGSuite.Domain)"
            }
            Write-Verbose "Getting $ApplicationName Activity report"
            $request = $service.Activities.List($UserKey,($ApplicationName.ToLower()))
            $request.MaxResults = $PageSize
            foreach ($key in $PSBoundParameters.Keys | Where-Object {$_ -notin @('UserKey','ApplicationName')}) {
                switch ($key) {
                    StartTime {
                        $request.$key = $StartTime.ToString('o')
                    }
                    EndTime {
                        $request.$key = $EndTime.ToString('o')
                    }
                    Filters {
                        $request.$key = $PSBoundParameters[$key] -join ","
                    }
                    Default {
                        if ($request.PSObject.Properties.Name -contains $key) {
                            $request.$key = $PSBoundParameters[$key]
                        }
                    }
                }
            }
            $response = @()
            [int]$i = 1
            do {
                $result = $request.Execute()
                $response += $result.Items
                $request.PageToken = $result.NextPageToken
                [int]$retrieved = ($i + $result.Items.Count) - 1
                Write-Verbose "Retrieved $retrieved events..."
                [int]$i = $i + $result.Items.Count
            }
            until (!$result.NextPageToken)
            return $response
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