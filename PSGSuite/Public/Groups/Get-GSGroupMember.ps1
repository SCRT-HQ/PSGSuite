function Get-GSGroupMember {
    <#
    .SYNOPSIS
    Gets the group member list of a target group
    
    .DESCRIPTION
    Gets the group member list of a target group. Designed for parity with Get-ADGroupMember
    
    .PARAMETER Identity
    The email or GroupID of the target group
    
    .PARAMETER Member
    If specified, returns only the information for this member of the target group
    
    .PARAMETER Roles
    If specified, returns only the members of the specified role(s)
    
    .PARAMETER PageSize
    Page size of the result set
    
    .EXAMPLE
    Get-GSGroupMember "admins@domain.com" -Roles Owner,Manager

    Returns the list of owners and managers of the group "admins@domain.com"
    #>
    [cmdletbinding(DefaultParameterSetName = "List")]
    Param
    (
      [parameter(Mandatory = $true,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
      [Alias('GroupEmail','Group','Email')]
      [String]
      $Identity,
      [parameter(Mandatory = $false,Position = 1,ParameterSetName = "Get")]
      [Alias("PrimaryEmail","UserKey","Mail","User","UserEmail")]
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
      $PageSize="200"
    )
    Begin {
        if ($PSCmdlet.ParameterSetName -eq 'Get') {
            $serviceParams = @{
                Scope       = 'https://www.googleapis.com/auth/admin.directory.group'
                ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
            }
            $service = New-GoogleService @serviceParams
        }
    }
    Process {
        try {
            if ($Identity -notlike "*@*.*") {
                $Identity = "$($Identity)@$($Script:PSGSuite.Domain)"
            }
            switch ($PSCmdlet.ParameterSetName) {
                Get {
                    foreach ($G in $Member) {
                        if ($G -notlike "*@*.*") {
                            $G = "$($G)@$($Script:PSGSuite.Domain)"
                        }
                        Write-Verbose "Getting member '$G' of group '$Identity'"
                        $request = $service.Members.Get($Identity,$G)
                        $request.Execute() | Select-Object @{N = "Group";E = {$Identity}},*
                    }
                }
                List {
                    Get-GSGroupMemberListPrivate @PSBoundParameters
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}