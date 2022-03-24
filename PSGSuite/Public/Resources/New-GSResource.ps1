function New-GSResource {
    <#
    .SYNOPSIS
    Creates a new Calendar Resource

    .DESCRIPTION
    Creates a new Calendar Resource. Supports Resource types 'Calendars','Buildings' & 'Features'

    .PARAMETER Name
    The name of the new Resource

    .PARAMETER Id
    The unique ID for the calendar resource.

    .PARAMETER BuildingId
    Unique ID for the building a resource is located in.

    .PARAMETER Description
    Description of the resource, visible only to admins.

    .PARAMETER Capacity
    Capacity of a resource, number of seats in a room.

    .PARAMETER FloorName
    Name of the floor a resource is located on (Calendars Resource type)

    .PARAMETER FloorNames
    The names of the floors in the building (Buildings Resource type)

    .PARAMETER FloorSection
    Name of the section within a floor a resource is located in.

    .PARAMETER Category
    The category of the calendar resource. Either CONFERENCE_ROOM or OTHER. Legacy data is set to CATEGORY_UNKNOWN.

    Acceptable values are:
    * "CATEGORY_UNKNOWN"
    * "CONFERENCE_ROOM"
    * "OTHER"

    Defaults to 'CATEGORY_UNKNOWN' if creating a Calendar Resource

    .PARAMETER ResourceType
    The type of the calendar resource, intended for non-room resources.

    .PARAMETER UserVisibleDescription
    Description of the resource, visible to users and admins.

    .PARAMETER Resource
    The resource type you would like to create

    Available values are:
    * "Calendars": create a Resource Calendar or legacy resource type
    * "Buildings": create a Resource Building
    * "Features": create a Resource Feature

    .EXAMPLE
    New-GSResource -Name "Training Room" -Id "Train01" -Capacity 75 -Category 'CONFERENCE_ROOM' -ResourceType "Conference Room" -Description "Training room for new hires - has 1 LAN port per station" -UserVisibleDescription "Training room for new hires"

    Creates a new training room Resource Calendar that will be bookable on Google Calendar
    #>
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
        [ValidateSet('CATEGORY_UNKNOWN','CONFERENCE_ROOM','OTHER')]
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
    Process {
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
        if ($PSBoundParameters -notcontains 'Category' -and $PSCmdlet.ParameterSetName -eq 'Calendars') {
            $PSBoundParameters['Category'] = 'CATEGORY_UNKNOWN'
        }
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
            $request.Execute() | Add-Member -MemberType NoteProperty -Name 'Resource' -Value $resType -PassThru
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
