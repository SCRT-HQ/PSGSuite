function Get-GSGmailMessageList {
    [cmdletbinding()]
    Param
    (
      [parameter(Mandatory=$false,ValueFromPipelineByPropertyName = $true)]
      [String[]]
      $User = $Script:PSGSuite.AdminEmail,
      [parameter(Mandatory=$false)]
      [Alias('Query')]
      [String[]]
      $Filter,
      [parameter(Mandatory=$false)]
      [Alias('LabelId')]
      [String[]]
      $LabelIds,
      [parameter(Mandatory=$false)]
      [switch]
      $ExcludeChats,
      [parameter(Mandatory=$false)]
      [switch]
      $IncludeSpamTrash,
      [parameter(Mandatory=$false)]
      [ValidateScript({if([int]$_ -le 500){$true}else{throw "PageSize must be 500 or less!"}})]
      [Int]
      $PageSize="500"
    )
    Process {
        try {
            foreach ($U in $User) {
                if ($U -ceq 'me') {
                    $U = $Script:PSGSuite.AdminEmail
                }
                elseif ($U -notlike "*@*.*") {
                    $U = "$($U)@$($Script:PSGSuite.Domain)"
                }
                $serviceParams = @{
                    Scope       = 'https://mail.google.com'
                    ServiceType = 'Google.Apis.Gmail.v1.GmailService'
                    User        = $U
                }
                if ($ExcludeChats){
                    if($Filter){
                        $Filter+="-in:chats"
                    }
                    else{
                        $Filter="-in:chats"
                    }
                }
                $service = New-GoogleService @serviceParams
                $request = $service.Users.Messages.List($U)
                foreach ($key in $PSBoundParameters.Keys) {
                    switch ($key) {
                        Filter {
                            $request.Q = $($Filter -join " ")
                        }
                        LabelIds {
                            $request.LabelIds = [String[]]$LabelIds
                        }
                        Default {
                            if ($request.PSObject.Properties.Name -contains $key) {
                                $request.$key = $PSBoundParameters[$key]
                            }
                        }
                    }
                }
                if ($PageSize) {
                    $request.MaxResults = $PageSize
                }
                if ($Filter) {
                    Write-Verbose "Getting all Messages matching filter '$Filter' for user '$U'"
                }
                else {
                    Write-Verbose "Getting all Messages for user '$U'"
                }
                $response = @()
                [int]$i = 1
                do {
                    $result = $request.Execute()
                    $response += $result.Messages | Select-Object @{N = 'User';E = {$U}},@{N = 'Filter';E = {$Filter}},*
                    if ($result.NextPageToken) {
                        $request.PageToken = $result.NextPageToken
                    }
                    [int]$retrieved = ($i + $result.Messages.Count) - 1
                    Write-Verbose "Retrieved $retrieved Messages..."
                    [int]$i = $i + $result.Messages.Count
                }
                until (!$result.NextPageToken)
                $response
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}