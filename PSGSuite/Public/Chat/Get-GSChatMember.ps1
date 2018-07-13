function Get-GSChatMember {
    <#
    .SYNOPSIS
    Gets Chat member information
    
    .DESCRIPTION
    Gets Chat member information

    .PARAMETER Member
    Resource name of the membership to be retrieved, in the form "spaces/members".

    Example: spaces/AAAAMpdlehY/members/105115627578887013105
    
    .PARAMETER Space
    The resource name of the space for which membership list is to be fetched, in the form "spaces".

    Example: spaces/AAAAMpdlehY
    
    .EXAMPLE
    Get-GSChatMember -Space 'spaces/AAAAMpdlehY'

    Gets the list of human members in the Chat space specified
    #>
    [cmdletbinding(DefaultParameterSetName = "List")]
    Param
    (
        [parameter(Mandatory = $true,ParameterSetName = "Get")]
        [string[]]
        $Member,
        [parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true,ParameterSetName = "List")]
        [Alias('Parent','Name')]
        [string[]]
        $Space
    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/chat.bot'
            ServiceType = 'Google.Apis.HangoutsChat.v1.HangoutsChatService'
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        switch ($PSCmdlet.ParameterSetName) {
            Get {
                foreach ($mem in $Member) {
                    try {
                        $request = $service.Spaces.Members.Get($mem)
                        Write-Verbose "Getting Member '$mem'"
                        $request.Execute()
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
            List {
                foreach ($sp in $Space) {
                    try {   
                        if ($sp -notlike "spaces/*") {
                            try {
                                $sp = Get-GSChatConfig -SpaceName $sp -ErrorAction Stop
                            }
                            catch {
                                $sp = "spaces/$sp"
                            }
                        }
                        $request = $service.Spaces.Members.List($sp)
                        Write-Verbose "Getting Member List of Chat Space '$sp'"
                        [int]$i = 1
                        do {
                            $result = $request.Execute()
                            $result.Memberships
                            if ($result.NextPageToken) {
                                $request.PageToken = $result.NextPageToken
                            }
                            [int]$retrieved = ($i + $result.Memberships.Count) - 1
                            Write-Verbose "Retrieved $retrieved Memberships..."
                            [int]$i = $i + $result.Memberships.Count
                        }
                        until (!$result.NextPageToken)
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
}