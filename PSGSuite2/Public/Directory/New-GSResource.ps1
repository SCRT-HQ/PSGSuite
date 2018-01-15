function New-GSResource {
    [CmdletBinding(DefaultParameterSetName = 'Features')]
    Param
    (
        [parameter(Mandatory = $true,Position = 0)]
        [String]
        $Name,
        [parameter(Mandatory = $false,ParameterSetName = 'Calendars')]
        [Alias('ResourceId')]
        [String]
        $Id,
        [parameter(Mandatory = $false,ParameterSetName = 'Calendars')]
        [parameter(Mandatory = $false,ParameterSetName = 'Buildings')]
        [String]
        $BuildingId,
        [parameter(Mandatory = $false,ParameterSetName = 'Calendars')]
        [parameter(Mandatory = $false,ParameterSetName = 'Buildings')]
        [String]
        $Description,
        [parameter(Mandatory = $false,ParameterSetName = 'Calendars')]
        [Int]
        $Capacity,
        [parameter(Mandatory = $false,ParameterSetName = 'Calendars')]
        [String]
        $FloorName,
        [parameter(Mandatory = $false,ParameterSetName = 'Buildings')]
        [String[]]
        $FloorNames,
        [parameter(Mandatory = $false,ParameterSetName = 'Calendars')]
        [String]
        $FloorSection,
        [parameter(Mandatory = $false,ParameterSetName = 'Calendars')]
        [ValidateSet('CONFERENCE_ROOM','OTHER')]
        [String]
        $Category,
        [parameter(Mandatory = $false,ParameterSetName = 'Calendars')]
        [String]
        $ResourceType,
        [parameter(Mandatory = $false,ParameterSetName = 'Calendars')]
        [String]
        $UserVisibleDescription,
        [parameter(Mandatory = $false)]
        [ValidateSet('Calendars','Buildings','Features')]
        [String]
        $Resource
    )
    Begin {
        $resType = if ($MyInvocation.InvocationName -eq 'New-GSCalendarResource') {
            'Calendars'
        }
        elseif ($Resource) {
            $Resource
        }
        else {
            $PSCmdlet.ParameterSetName
        }
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.resource.calendar'
            ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        try {
            Write-Verbose "Creating Resource $resType '$Name'"
            $body = New-Object "$(switch ($resType) {
                Calendars {
                    'Google.Apis.Admin.Directory.directory_v1.Data.CalendarResource'
                }
                Buildings {
                    'Google.Apis.Admin.Directory.directory_v1.Data.Building'
                }
                Features {
                    'Google.Apis.Admin.Directory.directory_v1.Data.Feature'
                }
            })"
            foreach ($key in $PSBoundParameters.Keys) {
                switch ($key) {
                    Category {
                        $body.ResourceCategory = $PSBoundParameters[$key]
                    }
                    Id {
                        if ($resType -eq 'Calendars') {
                            $body.ResourceId = $PSBoundParameters[$key]
                        }
                        else {
                            $body.$key = $PSBoundParameters[$key]
                        }
                        
                    }
                    Name {
                        if ($resType -eq 'Calendars') {
                            $body.ResourceName = $PSBoundParameters[$key]
                        }
                        elseif ($resType -eq 'Buildings') {
                            $body.BuildingName = $PSBoundParameters[$key]
                        }
                        else {
                            $body.$key = $PSBoundParameters[$key]
                        }
                    }
                    Description {
                        if ($resType -eq 'Calendars') {
                            $body.ResourceDescription = $PSBoundParameters[$key]
                        }
                        else {
                            $body.$key = $PSBoundParameters[$key]
                        }
                    }
                    Default {
                        if ($body.PSObject.Properties.Name -contains $key) {
                            $body.$key = $PSBoundParameters[$key]
                        }
                    }
                }
            }
            $request = $service.Resources.$resType.Insert($body,$(if ($Script:PSGSuite.CustomerID) {
                        $Script:PSGSuite.CustomerID
                    }
                    else {
                        'my_customer'
                    }))
            $request.Execute() | Select-Object @{N = 'Resource';E = {$resType}},*
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}