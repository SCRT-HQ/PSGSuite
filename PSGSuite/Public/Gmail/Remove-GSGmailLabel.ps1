function Remove-GSGmailLabel {
    <#
    .SYNOPSIS
    Removes a Gmail label

    .DESCRIPTION
    Removes a Gmail label

    .PARAMETER LabelId
    The unique Id of the label to remove

    .PARAMETER User
    The primary email of the user to remove the label from

    Defaults to the AdminEmail user

    .EXAMPLE
    Remove-GSGmailLabel -LabelId ANe1Bmj5l3089jd3k1eQbY90g9rXswjS03LVOw

    Removes the Label from the AdminEmail user after confirmation
    #>
    [cmdletbinding(SupportsShouldProcess = $true,ConfirmImpact = "High")]
    Param
    (
        [parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
        [Alias("Id")]
        [string[]]
        $LabelId,
        [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail", "UserKey", "Mail")]
        [ValidateNotNullOrEmpty()]
        [string]
        $User = $Script:PSGSuite.AdminEmail
    )
    Process {
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
        foreach ($label in $LabelId) {
            try {
                if ($PSCmdlet.ShouldProcess("Deleting Label Id '$label' from user '$User'")) {
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
}
