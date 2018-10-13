function New-GSGmailLabel {
    <#
    .SYNOPSIS
    Adds a Gmail label
    
    .DESCRIPTION
    Adds a Gmail label
    
    .PARAMETER User
    The primary email of the user to add the label to

    Defaults to the AdminEmail user
    
    .PARAMETER Name
    The name of the label to add
    
    .EXAMPLE
    New-GSGmailLabel -Name Label1

    Adds the label "Label1" to the AdminEmail
    #>
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false, Position = 0, ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail", "UserKey", "Mail")]
        [ValidateNotNullOrEmpty()]
        [string]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $true, Position = 1, ValueFromPipelineByPropertyName = $true)]
        [string]
        $Name,
        [parameter(Mandatory = $false, Position = 2, ValueFromPipelineByPropertyName = $true)]
        [string]
        $LabelListVisibility = "labelShow",
        [parameter(Mandatory = $false, Position = 3, ValueFromPipelineByPropertyName = $true)]
        [string]
        $MessageListVisibility = "show",
        [parameter(Mandatory = $false, Position = 4, ValueFromPipelineByPropertyName = $true)]
        [string]
        $Color,
        [parameter(Mandatory = $false, Position = 5, ValueFromPipelineByPropertyName = $true)]
        [string]
        $BackgroundColor,
        [parameter(Mandatory = $false, Position = 6, ValueFromPipelineByPropertyName = $true)]
        [string]
        $TextColor
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
        $body = New-Object 'Google.Apis.Gmail.v1.Data.Label'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$body.PSObject.Properties.Name -contains $_}) {
            $body.$prop = $PSBoundParameters[$prop]
        }
        if ($PSBoundParameters.Keys -contains 'BackgroundColor' -or $PSBoundParameters.Keys -contains 'TextColor') {
            $color = New-Object 'Google.Apis.Gmail.v1.Data.LabelColor'
            foreach ($prop in $PSBoundParameters.Keys | Where-Object {$color.PSObject.Properties.Name -contains $_}) {
                $color.$prop = $colorDict[$PSBoundParameters[$prop]]
            }
            $body.Color = $color
        }
        try {
            Write-Verbose "Creating Label '$Name' for user '$User'"
            $request = $service.Users.Labels.Create($body, $User)
            $request.Execute() | Add-Member -MemberType NoteProperty -Name 'User' -Value $User -PassThru
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