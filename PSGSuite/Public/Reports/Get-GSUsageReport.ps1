function Get-GSUsageReport {
    <#
    .SYNOPSIS
    Retrieves a list of activities
    
    .DESCRIPTION
    Retrieves a list of activities
    
    .PARAMETER Date
    Represents the date for which the data is to be fetched
    
    .PARAMETER UserKey
    Represents the profile id or the user email for which the data should be filtered
    
    .PARAMETER EntityType
    Type of object. Should be one of - gplus_communities
    
    .PARAMETER EntityKey
    Represents the key of object for which the data should be filtered
    
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
        [parameter(Mandatory = $true,ParameterSetName = "Customer")]
        [parameter(Mandatory = $true,ParameterSetName = "Entity")]
        [parameter(Mandatory = $true,ParameterSetName = "User")]
        [DateTime]
        $Date,
        [parameter(Mandatory = $true,ParameterSetName = "User")]
        [ValidateNotNullOrEmpty()]
        [String]
        $UserKey,
        [parameter(Mandatory = $true,ParameterSetName = "Entity")]
        [ValidateNotNullOrEmpty()]
        [String]
        $EntityType,
        [parameter(Mandatory = $true,ParameterSetName = "Entity")]
        [ValidateNotNullOrEmpty()]
        [String]
        $EntityKey,
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
        $PageSize = "1000"
    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.reports.usage.readonly'
            ServiceType = 'Google.Apis.Admin.Reports.reports_v1.ReportsService'
        }
        $service = New-GoogleService @serviceParams
        $props = @()
        $props += (@{N = "Date";E = {$Date.ToString('yyyy-MM-dd')}})
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
                    $props += (@{N = "EntityType";E = {$EntityType}})
                    $props += (@{N = "EntityKey";E = {$EntityKey}})
                }
                User {
                    if ($UserKey -ceq 'me') {
                        $UserKey = $Script:PSGSuite.AdminEmail
                    }
                    elseif ($UserKey -notlike "*@*.*") {
                        $UserKey = "$($UserKey)@$($Script:PSGSuite.Domain)"
                    }
                    $request = $service.UserUsageReport.Get($UserKey,($Date.ToString('yyyy-MM-dd')))
                    $request.MaxResults = $PageSize
                    $props += (@{N = "UserKey";E = {$UserKey}})
                }
            }
            $props += '*'
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
            $response = @()
            $warnings = @()
            [int]$i = 1
            do {
                $result = $request.Execute()
                $response += $result.UsageReportsValue.Parameters | Select-Object $props
                $warnings += $result.Warnings
                $request.PageToken = $result.NextPageToken
                [int]$retrieved = ($i + $result.UsageReportsValue.Parameters.Count) - 1
                Write-Verbose "Retrieved $retrieved report parameters..."
                [int]$i = $i + $result.UsageReportsValue.Parameters.Count
            }
            until (!$result.NextPageToken)
            if ($warnings) {
                $warnings | ForEach-Object {
                    Write-Warning "[$($_.Code)] $($_.Message)"
                }
            }
            return $response
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}