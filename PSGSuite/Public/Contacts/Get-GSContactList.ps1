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

    .NOTES
    Updated: 6 Oct 2020 by Chris O'Sullivan / CompareCloud 
    Updates: Added Organization details to output object
    #>
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false, Position = 0, ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail", "UserKey", "Mail")]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $User = $Script:PSGSuite.AdminEmail
    )
    Process {
        foreach ($U in $User) {
            try {
                if ($U -ceq 'me') {
                    $U = $Script:PSGSuite.AdminEmail
                }
                elseif ($U -notlike "*@*.*") {
                    $U = "$($U)@$($Script:PSGSuite.Domain)"
                }
                $Token = Get-GSToken -Scopes 'https://www.google.com/m8/feeds' -AdminEmail $U
                $Uri = "https://www.google.com/m8/feeds/contacts/$($U)/full?max-results=5000"
                $headers = @{
                    Authorization = "Bearer $($Token)"
                    'GData-Version' = '3.0'
                }
                Write-Verbose "Getting all contacts for user '$U'"
                $Raw = @()
                do {
                    $Response = Invoke-WebRequest -Method Get -Uri ([Uri]$Uri) -Headers $headers -ContentType 'application/xml' -Verbose:$false
                    $Feed = [xml]$Response.Content
                    $Raw += $feed.feed.entry
                    $Uri = $Feed.Feed.Link | Where-Object {$_.rel -eq "next"} | Select-Object -ExpandProperty Href
                    Write-Verbose "Retrieved $($Raw.Count) contacts..."
                }
                until (-not $Uri)
                If ($Raw) {
                    ForEach ($i in $Raw) {
                        [PSCustomObject]@{
                            User           = $U
                            Id             = ($i.id.Split("/")[-1])
                            Title          = $i.title
                            FullName       = $i.name.fullName
                            GivenName      = $i.name.givenName
                            FamilyName     = $i.name.familyName
                            EmailAddresses = $(if($i.email.address){$i.email.address}else{$null})
                            PhoneNumber    = $i.phonenumber
                            JobTitle       = $i.organization.orgTitle           #added by CompareCloud 6 Oct 2020
                            Department     = $i.organization.orgDepartment      #added by CompareCloud 6 Oct 2020
                            CompanyName    = $i.organization.orgName            #added by CompareCloud 6 Oct 2020
                            Updated        = $i.updated
                            Edited         = $i.edited.'#text'
                            Path           = $(if($i.email.rel){$i.email.rel}else{$null})
                            Etag           = $i.etag
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
}
