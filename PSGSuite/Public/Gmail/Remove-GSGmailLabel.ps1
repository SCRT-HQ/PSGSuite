function Remove-GSGmailLabel {
    <#
    .SYNOPSIS
    Removes a Gmail label
    
    .DESCRIPTION
    Removes a Gmail label
    
    .PARAMETER User
    The primary email of the user to remove the label from

    Defaults to the AdminEmail user
    
    .PARAMETER LabelId
    The unique Id of the label to remove
    
    .PARAMETER Raw
    If $true, returns the raw response. If not passed or -Raw:$false, response is formatted as a flat object for readability
    
    .EXAMPLE
    Remove-GSGmailLabel -LabelId ANe1Bmj5l3089jd3k1eQbY90g9rXswjS03LVOw

    Removes the Label from the AdminEmail user after confirmation
    #>
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false, Position = 0, ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail", "UserKey", "Mail")]
        [ValidateNotNullOrEmpty()]
        [string]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias("Id")]
        [string[]]
        $LabelId
        #[parameter(Mandatory = $false)]
        #[switch]
        #$Raw
    )
    Begin {
        if ($User -ceq 'me') {
            $User = $Script:PSGSuite.AdminEmail
        }
        elseif ($User -notlike "*@*.*") {
            $User = "$($User)@$($Script:PSGSuite.Domain)"
        }
        $serviceParams = @{
            Scope       = 'https://mail.google.com'
            ServiceType = 'Google.Apis.Gmail.v1.GmailService'
            User        = $User
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        try {
            foreach ($label in $LabelId) {
                Write-Verbose "Deleting Label Id '$label' from user '$User'"
                $request = $service.Users.Labels.Delete($User, $label)
                $request.Execute()
                Write-Verbose "Label Id '$label' deleted successfully from user '$User'"
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