function Set-GSGmailMessageLabel {
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
        $MessageId,
        [parameter(Mandatory = $false, Position = 0, ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail", "UserKey", "Mail")]
        [ValidateNotNullOrEmpty()]
        [string]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false, Position = 1, ValueFromPipelineByPropertyName = $true)]
        [string[]] 
        $RemoveLabel,
        [parameter(Mandatory = $false, Position = 2, ValueFromPipelineByPropertyName = $true)]
        [string[]] 
        $AddLabel
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
            foreach ($message in $MessageId) {
                $updateObj = New-Object 'Google.Apis.Gmail.v1.Data.ModifyMessageRequest' -Property @{
                    addLabelIds    = [string[]]$AddLabel
                    removeLabelIds = [string[]]$RemoveLabel
                }
                $request = $service.Users.Messages.Modify($updateObj, $user, $message)
                Write-Verbose "Updating label Ids on Message '$message' for user '$User'"
                $request.Execute() #| Add-Member -MemberType NoteProperty -Name 'User' -Value $User -PassThru
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