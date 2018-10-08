function Set-GSGmailLabel {
    <#
    .SYNOPSIS
    Updates Gmail label information for the specified labelid
    
    .DESCRIPTION
    Updates Gmail label information for the specified labelid
    
    .PARAMETER LabelId
    The unique Id of the label to update.  Required.
    
    .PARAMETER User
    The user to update label information for

    Defaults to the AdminEmail user
    
    .EXAMPLE
    Set-GSGmailLabel -user user@domain.com -LabelId Label_798170282134616520 -

    Gets the Gmail labels of the AdminEmail user
    #>
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias("Id")]
        [string[]]
        $LabelId,
        [parameter(Mandatory = $false, Position = 0, ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail", "UserKey", "Mail")]
        [ValidateNotNullOrEmpty()]
        [string]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $false)]
        [ValidateNotNullOrEmpty()]
        [object[]]
        $sourceObject = (Get-GSGmailLabel -user $user -LabelId $LabelId),
        [parameter(Mandatory = $false, Position = 1, ValueFromPipelineByPropertyName = $true)]
        [ValidateSet("labelHide","labelShow","labelShowIfUnread")]
        [string] 
        $labelListVisibility = $sourceObject.labelListVisibility,
        [parameter(Mandatory = $false, Position = 2, ValueFromPipelineByPropertyName = $true)]
        [ValidateSet("hide","show")]
        [string] 
        $messageListVisibility = $sourceObject.messageListVisibility,
        [parameter(Mandatory = $false, Position = 1, ValueFromPipelineByPropertyName = $true)]
        [string] 
        $name = $sourceObject.Name
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
                $updateObj = New-Object 'Google.Apis.Gmail.v1.Data.Label' -Property @{
                    Name = $name
                    LabelListVisibility = $labelListVisibility
                    MessageListVisibility = $messageListVisibility
                }
                $request = $service.Users.Labels.Update($User, $label, $updateObj)
                Write-Verbose "Updating Label Id '$label' for user '$User'"
                $request.Execute() | Add-Member -MemberType NoteProperty -Name 'User' -Value $User -PassThru
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