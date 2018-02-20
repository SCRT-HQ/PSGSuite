function Add-GSEventAttendee {
    <#
    .SYNOPSIS
    Adds an event attendee to a calendar event
    
    .DESCRIPTION
    Adds an event attendee to a calendar event
    
    .PARAMETER Email
    The email address of the attendee
    
    .PARAMETER AdditionalGuests
    How many additional guests, if any
    
    .PARAMETER Comment
    Attendee comment
    
    .PARAMETER DisplayName
    The attendee's name, if available
    
    .PARAMETER Optional
    Whether this is an optional attendee
    
    .PARAMETER Organizer
    Whether the attendee is the organizer of the event
    
    .PARAMETER Resource
    Whether the attendee is a resource
    
    .PARAMETER ResponseStatus
    The attendee's response status. 
    
    Possible values are: 
    * "NeedsAction": The attendee has not responded to the invitation.
    * "Declined": The attendee has declined the invitation.
    * "Tentative": The attendee has tentatively accepted the invitation.
    * "Accepted": The attendee has accepted the invitation
    
    .PARAMETER InputObject
    Used for pipeline input of an existing UserAddress object to strip the extra attributes and prevent errors
    #>
    [CmdletBinding(DefaultParameterSetName = "InputObject")]
    Param
    (
        [Parameter(Mandatory = $true,ParameterSetName = "Fields")]
        [String]
        $Email,
        [Parameter(Mandatory = $false,ParameterSetName = "Fields")]
        [Int]
        $AdditionalGuests,
        [Parameter(Mandatory = $false,ParameterSetName = "Fields")]
        [String]
        $Comment,
        [Parameter(Mandatory = $false,ParameterSetName = "Fields")]
        [String]
        $DisplayName,
        [Parameter(Mandatory = $false,ParameterSetName = "Fields")]
        [Switch]
        $Optional,
        [Parameter(Mandatory = $false,ParameterSetName = "Fields")]
        [Switch]
        $Organizer,
        [Parameter(Mandatory = $false,ParameterSetName = "Fields")]
        [Switch]
        $Resource,
        [Parameter(Mandatory = $false,ParameterSetName = "Fields")]
        [ValidateSet('NeedsAction','Declined','Tentative','Accepted')]
        [String]
        $ResponseStatus,
        [Parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Calendar.v3.Data.EventAttendee[]]
        $InputObject
    )
    Begin {
        $propsToWatch = @(
            'AdditionalGuests'
            'Comment'
            'DisplayName'
            'Email'
            'Optional'
            'Organizer'
            'Resource'
            'ResponseStatus'
        )
    }
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    Write-Verbose "Adding event attendee '$Email'"
                    $obj = New-Object 'Google.Apis.Calendar.v3.Data.EventAttendee'
                    foreach ($prop in $PSBoundParameters.Keys | Where-Object {$obj.PSObject.Properties.Name -contains $_}) {
                        $obj.$prop = $PSBoundParameters[$prop]
                    }
                    $obj
                }
                InputObject {
                    foreach ($iObj in $InputObject) {
                        $obj = New-Object 'Google.Apis.Calendar.v3.Data.EventAttendee'
                        foreach ($prop in $iObj.PSObject.Properties.Name | Where-Object {$obj.PSObject.Properties.Name -contains $_ -and $propsToWatch -contains $_}) {
                            $obj.$prop = $iObj.$prop
                        }
                        $obj
                    }
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