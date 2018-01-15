function Add-GSGmailFilter {
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [string]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [string]
        $From,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [string]
        $To,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [string]
        $Subject,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [string]
        $Query,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [string]
        $NegatedQuery,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [Switch]
        $HasAttachment,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [Switch]
        $ExcludeChats,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [string[]]
        $AddLabelIDs,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [string[]]
        $RemoveLabelIDs,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [string]
        $Forward,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [int]
        $Size,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [string]
        $SizeComparison,
        [parameter(Mandatory = $false)]
        [Switch]
        $Raw
    )
    Begin {
        if ($User -ceq 'me') {
            $User = $Script:PSGSuite.AdminEmail
        }
        elseif ($User -notlike "*@*.*") {
            $User = "$($User)@$($Script:PSGSuite.Domain)"
        }
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/gmail.settings.basic'
            ServiceType = 'Google.Apis.Gmail.v1.GmailService'
            User        = $User
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        try {
            $body = New-Object 'Google.Apis.Gmail.v1.Data.Filter'
            $action = New-Object 'Google.Apis.Gmail.v1.Data.FilterAction'
            $criteria = New-Object 'Google.Apis.Gmail.v1.Data.FilterCriteria'
            foreach ($key in $PSBoundParameters.Keys) {
                switch ($key) {
                    AddLabelIDs {
                        $action.$key = [String[]]($PSBoundParameters[$key])
                    }
                    RemoveLabelIds {
                        $action.$key = [String[]]($PSBoundParameters[$key])
                    }
                    Forward {
                        $action.$key = $PSBoundParameters[$key]
                    }
                    Default {
                        if ($criteria.PSObject.Properties.Name -contains $key) {
                            $criteria.$key = $PSBoundParameters[$key]
                        }
                    }
                }
            }
            $body.Action = $action
            $body.Criteria = $criteria
            $request = $service.Users.Settings.Filters.Create($body,$User)
            Write-Verbose "Creating Filter for user '$User'"
            $response = $request.Execute() | Select-Object @{N = 'User';E = {$User}},*
            if (!$Raw) {
                $response = $response | Select-Object User,Id,@{N = "From";E = {$_.criteria.from}},@{N = "To";E = {$_.criteria.to}},@{N = "Subject";E = {$_.criteria.subject}},@{N = "Query";E = {$_.criteria.query}},@{N = "NegatedQuery";E = {$_.criteria.negatedQuery}},@{N = "HasAttachment";E = {$_.criteria.hasAttachment}},@{N = "ExcludeChats";E = {$_.criteria.excludeChats}},@{N = "Size";E = {$_.criteria.size}},@{N = "SizeComparison";E = {$_.criteria.sizeComparison}},@{N = "AddLabelIds";E = {$_.action.addLabelIds}},@{N = "RemoveLabelIds";E = {$_.action.removeLabelIds}},@{N = "Forward";E = {$_.action.forward}}
            }
            $response
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}