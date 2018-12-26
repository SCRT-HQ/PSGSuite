function Get-GSChatSpace {
    <#
    .SYNOPSIS
    Gets a Chat space

    .DESCRIPTION
    Gets a Chat space

    .PARAMETER Space
    The resource name of the space for which membership list is to be fetched, in the form "spaces".

    If left blank, returns the list of spaces the bot is a member of

    Example: spaces/AAAAMpdlehY

    .EXAMPLE
    Get-GSChatSpace

    Gets the list of Chat spaces the bot is a member of
    #>
    [OutputType('Google.Apis.HangoutsChat.v1.Data.Space')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [Alias("Name")]
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
        if ($Space) {
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
                    $request = $service.Spaces.Get($sp)
                    Write-Verbose "Getting Chat Space '$sp'"
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
        else {
            try {
                $spaceArray = @()
                $request = $service.Spaces.List()
                Write-Verbose "Getting Chat Space List"
                [int]$i = 1
                do {
                    $result = $request.Execute()
                    $result.Spaces
                    $spaceArray += $result.Spaces
                    if ($result.NextPageToken) {
                        $request.PageToken = $result.NextPageToken
                    }
                    [int]$retrieved = ($i + $result.Spaces.Count) - 1
                    Write-Verbose "Retrieved $retrieved Spaces..."
                    [int]$i = $i + $result.Spaces.Count
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
    End {
        Write-Verbose "Updating PSGSuite Config with Space list"
        $spaceHashArray = @()
        $spaceArray | ForEach-Object {
            if ($_.DisplayName) {
                $spaceHashArray += @{$_.DisplayName = $_.Name}

            }
            else {
                $member = Get-GSChatMember -Space $_.Name -Verbose:$false
                $id = $member.Member.Name
                $primaryEmail = (Get-GSUser -User ($id.Replace('users/',''))).PrimaryEmail
                $spaceHashArray += @{
                    $id = $_.Name
                    $member.Member.DisplayName = $_.Name
                    $primaryEmail = $_.Name
                }
            }
        }
        Set-PSGSuiteConfig -Space $spaceHashArray -Verbose:$false
    }
}
