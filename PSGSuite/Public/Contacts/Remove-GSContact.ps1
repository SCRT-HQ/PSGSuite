Function Remove-GSContact {
    <#
    .SYNOPSIS
    Removes the specified contact

    .DESCRIPTION
    Removes the specified contact

    .PARAMETER User
    The primary email or UserID of the user. You can exclude the '@domain.com' to insert the Domain in the config or use the special 'me' to indicate the AdminEmail in the config.

    Defaults to the AdminEmail in the config.

    .PARAMETER Etag
    The Etag string from a Get-GSContactList object.  Used to ensure that no changes have been made to the contact since it was viewed, to ensure no data loss.

    .PARAMETER ContactID
    The ContactID to be removed.

    .EXAMPLE
    Recommended to use Get-GSContactList to find and pipe desired contacts to Remove-GSContact:

    Get-GSContactList -User user@domain.com | Where-Object {"@baddomain.com" -match $_.EmailAddresses} | Remove-GSContact

    Removes all contacts for user@domain.com that have an email address on the baddomain.com domain.

    #>
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    Param
    (
        [parameter(Mandatory = $false, Position = 0, ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail", "UserKey", "Mail")]
        [ValidateNotNullOrEmpty()]
        [string]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $true, Position = 1, ValueFromPipelineByPropertyName = $true)]
        [string]
        $Etag,
        [parameter(Mandatory = $false, Position = 2, ValueFromPipelineByPropertyName = $true)]
        [Alias("Id")]
        [string]
        $ContactID
    )
    Begin {
        if ($User -ceq 'me') {
            $User = $Script:PSGSuite.AdminEmail
        }
        elseif ($User -notlike "*@*.*") {
            $User = "$($User)@$($Script:PSGSuite.Domain)"
        }
    }
    Process {
        if ($PSCmdlet.ShouldProcess("Removing contact ID: $ContactID for $User")) {
            Write-Verbose "Removing contact ID: $ContactID for $User"
            try {
                $serviceParams = @{
                    Scope       = 'https://www.google.com/m8/feeds'
                    ServiceType = 'Google.Apis.Gmail.v1.GmailService'
                    User        = $User
                }
                $service = New-GoogleService @serviceParams
                $Token = ($service.HttpClientInitializer.GetAccessTokenForRequestAsync()).Result
                $Uri = "https://www.google.com/m8/feeds/contacts/$($User)/full/$($ContactID)"
                $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
                $headers.Add("GData-Version", "3.0")
                $headers.Add("Authorization", "Bearer $($Token)")
                $headers.Add("If-Match", "$Etag")
                $Response = Invoke-WebRequest -Method "Delete" -Uri $Uri -Headers $headers
                If ($Response.StatusCode -eq "200") {
                    Write-Verbose "Successfully deleted contact ID: $ContactID for $User"
                }
                Else {
                    Write-Verbose "HTTP $($Response.StatusCode): $($Response.StatusDescription)"
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
