function Get-GSGroupListPrivate {
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [Alias('User','PrimaryEmail','Mail','UserKey')]
        [String]
        $Where_IsAMember,
        [parameter(Mandatory = $false)]
        [ValidateRange(1,200)]
        [Alias('MaxResults')]
        [Int]
        $PageSize = "200"
    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.group'
            ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        try {
            $request = $service.Groups.List()
            if ($Where_IsAMember) {
                if ($Where_IsAMember -ceq "me") {
                    $Where_IsAMember = $Script:PSGSuite.AdminEmail
                }
                if ($Where_IsAMember -notlike "*@*.*") {
                    $Where_IsAMember = "$($Where_IsAMember)@$($Script:PSGSuite.Domain)"
                }
                Write-Verbose "Getting all G Suite groups where '$Where_IsAMember' is a member"
                $request.UserKey = $Where_IsAMember
            }
            else {
                switch ($Script:PSGSuite.Preference) {
                    Domain {
                        Write-Verbose "Getting all G Suite groups for domain '$($Script:PSGSuite.Domain)'"
                        $request.Domain = $Script:PSGSuite.Domain
                    }
                    CustomerId {
                        Write-Verbose "Getting all G Suite groups for customer '$($Script:PSGSuite.CustomerID)'"
                        $request.Customer = $Script:PSGSuite.CustomerId
                    }
                    Default {
                        Write-Verbose "Getting all G Suite groups for 'my_customer'"
                        $request.Customer = "my_customer"
                    }
                }
            }
            if ($PageSize) {
                $request.MaxResults = $PageSize
            }
            [int]$i = 1
            do {
                $result = $request.Execute()
                if ($null -ne $result.GroupsValue) {
                    $result.GroupsValue | Add-Member -MemberType ScriptMethod -Name ToString -Value {$this.Email} -PassThru -Force
                }
                $request.PageToken = $result.NextPageToken
                [int]$retrieved = ($i + $result.GroupsValue.Count) - 1
                Write-Verbose "Retrieved $retrieved groups..."
                [int]$i = $i + $result.GroupsValue.Count
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