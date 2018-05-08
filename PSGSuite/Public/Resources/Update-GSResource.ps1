function Update-GSResource {
    <#
    .SYNOPSIS
    Updates a Calendar Resource
    
    .DESCRIPTION
    Updates a Calendar Resource
    
    .PARAMETER ResourceId
    The unique Id of the Resource Calendar that you would like to update
    
    .PARAMETER BuildingId
    If updating a Resource Building, the unique Id of the building you would like to update

    If updating a Resource Calendar, the new Building Id for the resource
    
    .PARAMETER FeatureKey
    The unique key of the Feature you would like to update
    
    .PARAMETER Name
    The new name of the resource
    
    .PARAMETER Id
    The unique ID for the calendar resource.
    
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
    The new category of the calendar resource. Either CONFERENCE_ROOM or OTHER. Legacy data is set to CATEGORY_UNKNOWN. 

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
    Update-GSResource -ResourceId Train01 -Id TrainingRoom01

    Updates the resource Id 'Train01' to the new Id 'TrainingRoom01'
    #>
    [CmdletBinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipelineByPropertyName = $true,ParameterSetName = 'Calendars')]
        [Alias('CalendarResourceId')]
        [String]
        $ResourceId,
        [parameter(Mandatory = $true,Position = 0,ValueFromPipelineByPropertyName = $true,ParameterSetName = 'Buildings')]
        [parameter(Mandatory = $false,ParameterSetName = 'Calendars')]
        [String]
        $BuildingId,
        [parameter(Mandatory = $true,Position = 0,ValueFromPipelineByPropertyName = $true,ParameterSetName = 'Features')]
        [String]
        $FeatureKey,
        [parameter(Mandatory = $false,Position = 0)]
        [String]
        $Name,
        [parameter(Mandatory = $false,ParameterSetName = 'Calendars')]
        [String]
        $Id,
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
    Begin {
        $resType = if ($MyInvocation.InvocationName -eq 'Update-GSCalendarResource') {
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
            $resId = switch ($PSCmdlet.ParameterSetName) {
                Calendars {
                    $ResourceId
                }
                Buildings {
                    $BuildingId
                }
                Features {
                    $FeatureKey
                }
            }
            $request = $service.Resources.$resType.Patch($body,$(if ($Script:PSGSuite.CustomerID) {
                        $Script:PSGSuite.CustomerID
                    }
                    else {
                        'my_customer'
                    }),$resId)
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