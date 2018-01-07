function Get-GSGroupMember {
<#
.Synopsis
   Gets the group member list for a given group in Google Apps
.DESCRIPTION
   Retrieves the full group list for the entire account
.EXAMPLE
   Get-GSGroupMemberList -AccessToken $(Get-GSToken @TokenParams) -GroupEmail "my.group@domain.com" -MaxResults 10
.EXAMPLE
   Get-GSGroupMemberList -AccessToken $(Get-GSToken @TokenParams)
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
      [ValidateScript( {[int]$_ -le 200 -and [int]$_ -ge 1})]
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
                    Get-GSGroupMemberList @PSBoundParameters
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}