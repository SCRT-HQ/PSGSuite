function Get-GSGmailFilter {
    <#
    .SYNOPSIS
    Gets Gmail filter details
    
    .DESCRIPTION
    Long description
    
    .PARAMETER FilterId
    The unique Id of the filter you would like to retrieve information for. If excluded, all filters for the user are returned
    
    .PARAMETER User
    The email of the user you are getting the filter information for
    
    .PARAMETER Raw
    If $true, returns the raw response. If not passed or -Raw:$false, response is formatted as a flat object for readability
    
    .EXAMPLE
    Get-GSGmailFilter -User joe

    Gets the list of filters for Joe
    #>
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [Alias("Id")]
        [string[]]
        $FilterId,
        [parameter(Mandatory = $false,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [string]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false)]
        [switch]
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
            if ($FilterId) {
                foreach ($fil in $FilterId) {
                    $request = $service.Users.Settings.Filters.Get($User,$fil)
                    Write-Verbose "Getting Filter Id '$fil' for user '$User'"
                    $response = $request.Execute() | Select-Object @{N = 'User';E = {$User}},*
                    if (!$Raw) {
                        $response = $response | Select-Object User,Id,@{N = "From";E = {$_.criteria.from}},@{N = "To";E = {$_.criteria.to}},@{N = "Subject";E = {$_.criteria.subject}},@{N = "Query";E = {$_.criteria.query}},@{N = "NegatedQuery";E = {$_.criteria.negatedQuery}},@{N = "HasAttachment";E = {$_.criteria.hasAttachment}},@{N = "ExcludeChats";E = {$_.criteria.excludeChats}},@{N = "Size";E = {$_.criteria.size}},@{N = "SizeComparison";E = {$_.criteria.sizeComparison}},@{N = "AddLabelIds";E = {$_.action.addLabelIds}},@{N = "RemoveLabelIds";E = {$_.action.removeLabelIds}},@{N = "Forward";E = {$_.action.forward}}
                    }
                    $response
                }
            }
            else {
                $request = $service.Users.Settings.Filters.List($User)
                Write-Verbose "Getting Filter List for user '$User'"
                $response = $request.Execute() | Select-Object -ExpandProperty Filter | Select-Object @{N = 'User';E = {$User}},*
                if (!$Raw) {
                    $response = $response | Select-Object User,Id,@{N = "From";E = {$_.criteria.from}},@{N = "To";E = {$_.criteria.to}},@{N = "Subject";E = {$_.criteria.subject}},@{N = "Query";E = {$_.criteria.query}},@{N = "NegatedQuery";E = {$_.criteria.negatedQuery}},@{N = "HasAttachment";E = {$_.criteria.hasAttachment}},@{N = "ExcludeChats";E = {$_.criteria.excludeChats}},@{N = "Size";E = {$_.criteria.size}},@{N = "SizeComparison";E = {$_.criteria.sizeComparison}},@{N = "AddLabelIds";E = {$_.action.addLabelIds}},@{N = "RemoveLabelIds";E = {$_.action.removeLabelIds}},@{N = "Forward";E = {$_.action.forward}}
                }
                $response
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