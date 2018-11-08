Function Remove-GSContact {
    <#
    .SYNOPSIS
    Removes the specified contact

    .DESCRIPTION
    Removes the specified contact

    .PARAMETER ContactID
    The ContactID to be removed.

    .PARAMETER User
    The primary email or UserID of the user. You can exclude the '@domain.com' to insert the Domain in the config or use the special 'me' to indicate the AdminEmail in the config.

    Defaults to the AdminEmail in the config.

    .PARAMETER Etag
    The Etag string from a Get-GSContactList object. Used to ensure that no changes have been made to the contact since it was viewed in order to prevent data loss.

    Defaults to special Etag value *, which can be used to bypass this verification and process the update regardless of updates from other clients.

    .EXAMPLE
    Recommended to use Get-GSContactList to find and pipe desired contacts to Remove-GSContact:

    Get-GSContactList -User user@domain.com | Where-Object {"@baddomain.com" -match $_.EmailAddresses} | Remove-GSContact

    Removes all contacts for user@domain.com that have an email address on the baddomain.com domain.

    #>
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    Param
    (
        [parameter(Mandatory = $false, Position = 0, ValueFromPipelineByPropertyName = $true)]
        [Alias("Id")]
        [string[]]
        $ContactId,
        [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail", "UserKey", "Mail")]
        [ValidateNotNullOrEmpty()]
        [string]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [string]
        $Etag = '*'
    )
    Process {
        if ($User -ceq 'me') {
            $User = $Script:PSGSuite.AdminEmail
        }
        elseif ($User -notlike "*@*.*") {
            $User = "$($User)@$($Script:PSGSuite.Domain)"
        }
        $Token = Get-GSToken -Scopes 'https://www.google.com/m8/feeds' -AdminEmail $User
        $headers = @{
            Authorization   = "Bearer $($Token)"
            'GData-Version' = '3.0'
            'If-Match'      = $Etag
        }
        foreach ($Id in $ContactID) {
            if ($PSCmdlet.ShouldProcess("Removing contact ID '$Id' for $User")) {
                Write-Verbose "Removing contact ID '$Id' for $User"
                try {
                    $Uri = "https://www.google.com/m8/feeds/contacts/$($User)/full/$($Id)"
                    $Response = Invoke-WebRequest -Method "Delete" -Uri ([Uri]$Uri) -Headers $headers -Verbose:$false
                    If ($Response.StatusCode -eq "200") {
                        Write-Verbose "Successfully deleted contact ID '$Id' for $User"
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
}
