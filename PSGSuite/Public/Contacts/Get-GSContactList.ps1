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
        try {
            Write-Verbose "Getting all contacts for user '$User'"
            $Raw = @()
            $Response = Invoke-WebRequest -Method Get -Uri $Uri -Headers $headers -ContentType 'application/xml'
            $Feed = [xml]$Response.Content
            $Raw += $feed.feed.entry
            $Next = $Feed.Feed.Link | Where-Object {$_.rel -eq "next"} | Select-Object -ExpandProperty Href
            While ($Next) {
                $Response = Invoke-WebRequest -Method Get -Uri $Next -Headers $headers -ContentType 'application/xml'
                $Feed = [xml]$Response.Content
                $Raw += $feed.feed.entry
                $Next = $Feed.Feed.Link | Where-Object {$_.rel -eq "next"} | Select-Object -ExpandProperty Href
            }
            If ($Raw) {
                ForEach ($i in $Raw) {
                    New-Object PSObject -Property @{
                        Etag           = $i.etag
                        Id             = ($i.id.Split("/")[-1])
                        User           = $User
                        Updated        = $i.updated
                        Edited         = $i.edited.'#text'
                        Category       = $i.category
                        Title          = $i.title
                        Name           = $i.name
                        PhoneNumber    = $i.phonenumber
                        Path           = $(if($i.email.rel){$i.email.rel}else{$null})
                        EmailAddresses = $(if($i.email.address){$i.email.address}else{$null})
                        FullObject     = $i
                    }
                }
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
