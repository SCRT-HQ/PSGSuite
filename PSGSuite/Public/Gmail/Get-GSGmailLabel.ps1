function Get-GSGmailLabel {
    <#
    .SYNOPSIS
    Gets Gmail label information for the user

    .DESCRIPTION
    Gets Gmail label information for the user

    .PARAMETER LabelId
    The unique Id of the label to get information for. If excluded, returns the list of labels for the user

    .PARAMETER User
    The user to get label information for

    Defaults to the AdminEmail user

    .EXAMPLE
    Get-GSGmailLabel

    Gets the Gmail labels of the AdminEmail user
    #>
    [OutputType('Google.Apis.Gmail.v1.Data.Label')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [Alias("Id")]
        [string[]]
        $LabelId,
        [parameter(Mandatory = $false,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail")]
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
            Scope       = 'https://mail.google.com'
            ServiceType = 'Google.Apis.Gmail.v1.GmailService'
            User        = $User
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        try {
            if ($LabelId) {
                foreach ($label in $LabelId) {
                    $request = $service.Users.Labels.Get($User,$label)
                    Write-Verbose "Getting Label Id '$label' for user '$User'"
                    $request.Execute() | Add-Member -MemberType NoteProperty -Name 'User' -Value $User -PassThru
                }
            }
            else {
                $request = $service.Users.Labels.List($User)
                Write-Verbose "Getting Label List for user '$User'"
                $request.Execute() | Select-Object -ExpandProperty Labels | Add-Member -MemberType NoteProperty -Name 'User' -Value $User -PassThru
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
