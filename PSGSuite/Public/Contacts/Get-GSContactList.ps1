Function Get-GSContactList {
    <#
    .SYNOPSIS
    Gets all contacts for the specified user
    
    .DESCRIPTION
    Gets all contacts for the specified user
    
    .PARAMETER User
    The primary email or UserID of the user. You can exclude the '@domain.com' to insert the Domain in the config or use the special 'me' to indicate the AdminEmail in the config. 

    Defaults to the AdminEmail in the config.
    
    .EXAMPLE
    Get-GSContactList -User user@domain.com

    #>
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false, Position = 0, ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail", "UserKey", "Mail")]
        [ValidateNotNullOrEmpty()]
        [string]
        $User = $Script:PSGSuite.AdminEmail
    )
    Begin {
        if ($User -ceq 'me') {
            $User = $Script:PSGSuite.AdminEmail
        }
        elseif ($User -notlike "*@*.*") {
            $User = "$($User)@$($Script:PSGSuite.Domain)"
        }
        $serviceParams = @{
            Scope       = 'https://www.google.com/m8/feeds'
            ServiceType = 'Google.Apis.Gmail.v1.GmailService'
            User        = $User
        }
        $service = New-GoogleService @serviceParams
        $Token = ($service.HttpClientInitializer.GetAccessTokenForRequestAsync()).Result
        $Uri = "https://www.google.com/m8/feeds/contacts/$($User)/full?max-results=150"
        $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
        $headers.Add("GData-Version", "3.0")
        $headers.Add("Authorization", "Bearer $($Token)")
    }
    Process {
        Write-Verbose "Getting all contacts for user '$User'"
        $Raw = @()
        $Response = Invoke-WebRequest -Method Get -Uri $Uri -Headers $headers -ContentType Application/xml
        $Feed = [xml]$Response.Content
        $Raw += $feed.feed.entry
        $Next = $Feed.Feed.Link | Where-Object {$_.rel -eq "next"} | Select-Object -ExpandProperty Href
        While ($Next) {
            $Response = Invoke-WebRequest -Method Get -Uri $Next -Headers $headers -ContentType Application/xml
            $Feed = [xml]$Response.Content
            $Raw += $feed.feed.entry
            $Next = $Feed.Feed.Link | Where-Object {$_.rel -eq "next"} | Select-Object -ExpandProperty Href
        }
        If ($Raw) {
            ForEach ($i in $Raw) {
                New-Object PSObject -Property @{
                    Etag           = $iEtag
                    Id             = $i.Id.Split("/")[$i.Id.Split("/").Count - 1]
                    User           = $User
                    Updated        = $i.Updated
                    Edited         = $i.Edited
                    Category       = $i.Category
                    Title          = $i.Title
                    Path           = $i.email | Select-Object -ExpandProperty rel -Unique -EA 0
                    EmailAddresses = $i.email | Select-Object -ExpandProperty address -EA 0
                }
            }
        }
    }
}
