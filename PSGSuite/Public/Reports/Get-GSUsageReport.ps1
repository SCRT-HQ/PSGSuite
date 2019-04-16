function Get-GSUsageReport {
    <#
    .SYNOPSIS
    Retrieves the usage report for the specified type.

    Defaults to Customer Usage Report type.

    .DESCRIPTION
    Retrieves the usage report for the specified type.

    Defaults to Customer Usage Report type.

    .PARAMETER Date
    Represents the date for which the data is to be fetched. Defaults to 3 days before the current date.

    .PARAMETER UserKey
    [User Usage Report] Represents the profile id or the user email for which the data should be filtered.

    Use 'all' to retrieve the report for all users.

    .PARAMETER EntityType
    [Entity Usage Report] Type of object. Should be one of:
    * gplus_communities

    .PARAMETER EntityKey
    [Entity Usage Report] Represents the key of object for which the data should be filtered.

    Use 'all' to retrieve the report for all users.

    .PARAMETER Filters
    Represents the set of filters including parameter operator value

    .PARAMETER Parameters
    Represents the application name, parameter name pairs to fetch in csv as app_name1:param_name1

    .PARAMETER PageSize
    Maximum number of results to return. Maximum allowed is 1000

    .EXAMPLE
    Get-GSUsageReport -Date (Get-Date).AddDays(-30)

    Gets the Customer Usage report from 30 days prior
    #>
    [cmdletbinding(DefaultParameterSetName = "Customer")]
    Param
    (
        [parameter(Mandatory = $false,ParameterSetName = "Customer")]
        [parameter(Mandatory = $false,ParameterSetName = "Entity")]
        [parameter(Mandatory = $false,ParameterSetName = "User")]
        [DateTime]
        $Date = (Get-Date).AddDays(-3),
        [parameter(Mandatory = $true,ParameterSetName = "User")]
        [ValidateNotNullOrEmpty()]
        [String]
        $UserKey,
        [parameter(Mandatory = $true,ParameterSetName = "Entity")]
        [ValidateSet('gplus_communities')]
        [String]
        $EntityType,
        [parameter(Mandatory = $false,ParameterSetName = "Entity")]
        [ValidateNotNullOrEmpty()]
        [String]
        $EntityKey = 'all',
        [parameter(Mandatory = $false,ParameterSetName = "Entity")]
        [parameter(Mandatory = $false,ParameterSetName = "User")]
        [String[]]
        $Filters,
        [parameter(Mandatory = $false)]
        [String[]]
        $Parameters,
        [parameter(Mandatory = $false,ParameterSetName = "Entity")]
        [parameter(Mandatory = $false,ParameterSetName = "User")]
        [ValidateRange(1,1000)]
        [Alias("MaxResults")]
        [Int]
        $PageSize = "1000",
        [parameter(Mandatory = $false)]
        [switch]
        $Flat,
        [parameter(Mandatory = $false)]
        [switch]
        $Raw
    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.reports.usage.readonly'
            ServiceType = 'Google.Apis.Admin.Reports.reports_v1.ReportsService'
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        try {
            Write-Verbose "Getting $($PSCmdlet.ParameterSetName) Usage report for $($Date.ToString('yyyy-MM-dd'))"
            switch ($PSCmdlet.ParameterSetName) {
                Customer {
                    $request = $service.CustomerUsageReports.Get(($Date.ToString('yyyy-MM-dd')))
                }
                Entity {
                    $request = $service.EntityUsageReports.Get($EntityType,$EntityKey,($Date.ToString('yyyy-MM-dd')))
                    $request.MaxResults = $PageSize
                }
                User {
                    if ($UserKey -ceq 'me') {
                        $UserKey = $Script:PSGSuite.AdminEmail
                    }
                    elseif ($UserKey -notlike "*@*.*" -and $UserKey -ne 'all') {
                        $UserKey = "$($UserKey)@$($Script:PSGSuite.Domain)"
                    }
                    $request = $service.UserUsageReport.Get($UserKey,($Date.ToString('yyyy-MM-dd')))
                    $request.MaxResults = $PageSize
                }
            }
            foreach ($key in $PSBoundParameters.Keys | Where-Object {$_ -notin @('Date','UserKey','EntityKey','EntityType')}) {
                switch ($key) {
                    Filters {
                        $request.$key = $PSBoundParameters[$key] -join ","
                    }
                    Parameters {
                        $request.$key = $PSBoundParameters[$key] -join ","
                    }
                    Default {
                        if ($request.PSObject.Properties.Name -contains $key) {
                            $request.$key = $PSBoundParameters[$key]
                        }
                    }
                }
            }
            $warnings = @()
            [int]$i = 1
            do {
                $result = $request.Execute()
                if ($Raw) {
                    $result.UsageReportsValue
                }
                else {
                    $result.UsageReportsValue | ForEach-Object {
                        if ($null -ne $_) {
                            $orig = $_
                            $orig | Add-Member -MemberType NoteProperty -Name CustomerId -Value $orig.Entity.CustomerId -Force -PassThru | Add-Member -MemberType NoteProperty -Name EntityType -Value $orig.Entity.Type -Force
                            switch ($PSCmdlet.ParameterSetName) {
                                Entity {
                                    $orig | Add-Member -MemberType NoteProperty -Name EntityKey -Value $orig.Entity.EntityKey -Force
                                    $orig | Add-Member -MemberType NoteProperty -Name CommunityName -Value $orig.Parameters[$orig.Parameters.Name.IndexOf('gplus:community_name')].StringValue -Force
                                }
                                User {
                                    $orig | Add-Member -MemberType NoteProperty -Name Email -Value $orig.Entity.UserEmail -Force -PassThru | Add-Member -MemberType NoteProperty -Name UserEmail -Value $orig.Entity.UserEmail -Force -PassThru | Add-Member -MemberType NoteProperty -Name ProfileId -Value $orig.Entity.ProfileId -Force
                                }
                            }
                            foreach ($param in $orig.Parameters | Sort-Object Name) {
                                if ($null -ne $param.Name) {
                                    $paramValue = if ($null -ne $param.StringValue) {
                                        $param.StringValue
                                    }
                                    elseif ($null -ne $param.IntValue) {
                                        $param.IntValue
                                    }
                                    elseif ($null -ne $param.DatetimeValue) {
                                        $param.DatetimeValue
                                    }
                                    elseif ($null -ne $param.BoolValue) {
                                        $param.BoolValue
                                    }
                                    elseif ($null -ne $param.MsgValue) {
                                        $param.MsgValue
                                    }
                                    else {
                                        $null
                                    }
                                    if ($Flat) {
                                        $orig | Add-Member -MemberType NoteProperty -Name $param.Name -Value $paramValue -Force
                                    }
                                    else {
                                        $pName = $param.Name -split ":"
                                        if ($orig.PSObject.Properties.Name -notcontains $pName[0]) {
                                            $orig | Add-Member -MemberType NoteProperty -Name $pName[0] -Value $([Ordered]@{}) -Force
                                        }
                                        $orig.$($pName[0])[$pName[1]] = $paramValue
                                    }
                                }
                            }
                            $orig
                        }
                    }
                }
                $warnings += $result.Warnings
                $request.PageToken = $result.NextPageToken
                [int]$retrieved = ($i + $result.UsageReportsValue.Count) - 1
                Write-Verbose "Retrieved $retrieved entities for this report..."
                [int]$i = $i + $result.UsageReportsValue.Count
            }
            until (!$result.NextPageToken)
            if ($warnings | Where-Object {$_.Code}) {
                $warnings | ForEach-Object {
                    Write-Warning "[$($_.Code)] $($_.Message)"
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
