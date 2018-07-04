function Get-GSResourceListPrivate {
    [CmdletBinding()]
    Param
    (
        [parameter(Mandatory = $false,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('Calendars','Buildings','Features')]
        [String[]]
        $Resource = @('Calendars','Buildings','Features'),
        [parameter(Mandatory = $false)]
        [Alias('Query')]
        [String[]]
        $Filter,
        [parameter(Mandatory = $false)]
        [String[]]
        $OrderBy,
        [parameter(Mandatory = $false)]
        [ValidateRange(1,500)]
        [Alias("MaxResults")]
        [Int]
        $PageSize = "500",
        [parameter(Mandatory = $false)]
        [Alias('Profile','ProfileName')]
        [String]
        $ConfigName
    )
    Begin {
        if ($MyInvocation.InvocationName -eq 'Get-GSCalendarResourceList') {
            $Resource = 'Calendars'
        }
        $propHash = @{
            Calendars  = 'Items'
            Buildings = 'BuildingsValue'
            Features = 'FeaturesValue'
        }
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.resource.calendar'
            ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        try {
            foreach ($R in $Resource) {
                $request = $service.Resources.$R.List($(if($Script:PSGSuite.CustomerID) {$Script:PSGSuite.CustomerID}else {'my_customer'}))
                if ($R -eq 'Calendars') {
                    if ($PageSize) {
                        $request.MaxResults = $PageSize
                    }
                    if ($OrderBy) {
                        $request.OrderBy = "$($OrderBy -join ", ")"
                    }
                    if ($Filter) {
                        if ($Filter -eq '*') {
                            $Filter = ""
                        }
                        else {
                            $Filter = "$($Filter -join " ")"
                        }
                        $Filter = $Filter -replace " -eq ","=" -replace " -like ",":" -replace " -match ",":" -replace " -contains ",":" -creplace "'True'","True" -creplace "'False'","False"
                        $request.Query = $Filter.Trim()
                        Write-Verbose "Getting Resource $R matching filter: `"$($Filter.Trim())`""
                    }
                    else {
                        Write-Verbose "Getting all Resource $R"
                    }
                }
                else {
                    Write-Verbose "Getting all Resource $R"
                }
                [int]$i = 1
                do {
                    $result = $request.Execute()
                    $result.$($propHash[$R]) | ForEach-Object {
                        $obj = $_
                        $_Id = switch ($R) {
                            Calendars {
                                $obj.ResourceId
                            }
                            Buildings {
                                $obj.BuildingId
                            }
                            Features {
                                $obj.Name
                            }
                        }
                        $_ | Add-Member -MemberType NoteProperty -Name 'Id' -Value $_Id -PassThru | Add-Member -MemberType NoteProperty -Name 'Resource' -Value $R -PassThru | Add-Member -MemberType ScriptMethod -Name ToString -Value {$this.Id} -PassThru -Force
                    }
                    if ($result.NextPageToken) {
                        $request.PageToken = $result.NextPageToken
                    }
                    [int]$retrieved = ($i + $result.$($propHash[$R]).Count) - 1
                    Write-Verbose "Retrieved $retrieved resources..."
                    [int]$i = $i + $result.$($propHash[$R]).Count
                }
                until (!$result.NextPageToken)
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