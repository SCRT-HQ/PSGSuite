function Get-GSGroupMember {
    <#
    .SYNOPSIS
    Gets the group member list of a target group

    .DESCRIPTION
    Gets the group member list of a target group. Designed for parity with Get-ADGroupMember

    .PARAMETER Identity
    The email or unique ID of the target group

    .PARAMETER Member
    If specified, returns only the information for this member of the target group

    .PARAMETER Roles
    If specified, returns only the members of the specified role(s)

    .PARAMETER PageSize
    Page size of the result set

    .PARAMETER Limit
    The maximum amount of results you want returned. Exclude or set to 0 to return all results

    .EXAMPLE
    Get-GSGroupMember "admins@domain.com" -Roles Owner,Manager

    Returns the list of owners and managers of the group "admins@domain.com"
    #>
    [OutputType('Google.Apis.Admin.Directory.directory_v1.Data.Member')]
    [cmdletbinding(DefaultParameterSetName = "List")]
    Param (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias('GroupEmail','Group','Email')]
        [String[]]
        $Identity,
        [parameter(Mandatory = $false,Position = 1,ParameterSetName = "Get")]
        [Alias("PrimaryEmail","UserKey","Mail","User","UserEmail","Members")]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Member,
        [parameter(Mandatory=$false,ParameterSetName = "List")]
        [ValidateSet("Owner","Manager","Member")]
        [String[]]
        $Roles,
        [parameter(Mandatory=$false,ParameterSetName = "List")]
        [ValidateRange(1,200)]
        [Int]
        $PageSize = 200,
        [parameter(Mandatory=$false,ParameterSetName = "List")]
        [Alias('First')]
        [Int]
        $Limit = 0
    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.group'
            ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        switch ($PSCmdlet.ParameterSetName) {
            Get {
                foreach ($I in $Identity) {
                    try {
                        Resolve-Email ([ref]$I) -IsGroup
                        foreach ($G in $Member) {
                            Resolve-Email ([ref]$G)
                            Write-Verbose "Getting member '$G' of group '$I'"
                            $request = $service.Members.Get($I,$G)
                            $request.Execute() | Add-Member -MemberType NoteProperty -Name 'Group' -Value $I -PassThru
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
            List {
                foreach ($Id in $Identity) {
                    try {
                        Resolve-Email ([ref]$Id) -IsGroup
                        $request = $service.Members.List($Id)
                        if ($Limit -gt 0 -and $PageSize -gt $Limit) {
                            Write-Verbose ("Reducing PageSize from {0} to {1} to meet limit with first page" -f $PageSize,$Limit)
                            $PageSize = $Limit
                        }
                        $request.MaxResults = $PageSize
                        if ($Roles) {
                            Write-Verbose "Getting all members of group '$Id' in the following role(s): $($Roles -join ',')"
                            $request.Roles = "$($Roles -join ',')"
                        }
                        else {
                            Write-Verbose "Getting all members of group '$Id'"
                        }
                        [int]$i = 1
                        $overLimit = $false
                        do {
                            $result = $request.Execute()
                            if ($null -ne $result.MembersValue) {
                                $result.MembersValue | Add-Member -MemberType NoteProperty -Name 'Group' -Value $Id -PassThru  | Add-Member -MemberType ScriptMethod -Name ToString -Value {$this.Email} -PassThru -Force
                            }
                            $request.PageToken = $result.NextPageToken
                            [int]$retrieved = ($i + $result.MembersValue.Count) - 1
                            Write-Verbose "Retrieved $retrieved members..."
                            if ($Limit -gt 0 -and $retrieved -eq $Limit) {
                                Write-Verbose "Limit reached: $Limit"
                                $overLimit = $true
                            }
                            elseif ($Limit -gt 0 -and ($retrieved + $PageSize) -gt $Limit) {
                                $newPS = $Limit - $retrieved
                                Write-Verbose ("Reducing PageSize from {0} to {1} to meet limit with next page" -f $PageSize,$newPS)
                                $request.MaxResults = $newPS
                            }
                            [int]$i = $i + $result.MembersValue.Count
                        }
                        until ($overLimit -or !$result.NextPageToken)
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
