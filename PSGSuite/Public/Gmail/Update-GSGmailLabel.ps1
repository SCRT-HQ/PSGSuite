function Update-GSGmailLabel {
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
    Set-GSGmailLabel -User user@domain.com -LabelId Label_798170282134616520 -

    Gets the Gmail labels of the AdminEmail user
    #>
    [cmdletbinding(DefaultParameterSetName = "Fields")]
    Param
    (
        [parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true, ParameterSetName = "Fields")]
        [Alias("Id")]
        [string[]]
        $LabelId,
        [parameter(Mandatory = $false, Position = 1)]
        [ValidateSet("labelHide","labelShow","labelShowIfUnread")]
        [string]
        $LabelListVisibility,
        [parameter(Mandatory = $false, Position = 2)]
        [ValidateSet("hide","show")]
        [string]
        $MessageListVisibility,
        [parameter(Mandatory = $false, Position = 3)]
        [string]
        $Name,
        [parameter(Mandatory = $false)]
        [ValidateSet('#000000','#434343','#666666','#999999','#cccccc','#efefef','#f3f3f3','#ffffff','#fb4c2f','#ffad47','#fad165','#16a766','#43d692','#4a86e8','#a479e2','#f691b3','#f6c5be','#ffe6c7','#fef1d1','#b9e4d0','#c6f3de','#c9daf8','#e4d7f5','#fcdee8','#efa093','#ffd6a2','#fce8b3','#89d3b2','#a0eac9','#a4c2f4','#d0bcf1','#fbc8d9','#e66550','#ffbc6b','#fcda83','#44b984','#68dfa9','#6d9eeb','#b694e8','#f7a7c0','#cc3a21','#eaa041','#f2c960','#149e60','#3dc789','#3c78d8','#8e63ce','#e07798','#ac2b16','#cf8933','#d5ae49','#0b804b','#2a9c68','#285bac','#653e9b','#b65775','#822111','#a46a21','#aa8831','#076239','#1a764d','#1c4587','#41236d','#83334c')]
        [string]
        $BackgroundColor,
        [parameter(Mandatory = $false)]
        [ValidateSet('#000000','#434343','#666666','#999999','#cccccc','#efefef','#f3f3f3','#ffffff','#fb4c2f','#ffad47','#fad165','#16a766','#43d692','#4a86e8','#a479e2','#f691b3','#f6c5be','#ffe6c7','#fef1d1','#b9e4d0','#c6f3de','#c9daf8','#e4d7f5','#fcdee8','#efa093','#ffd6a2','#fce8b3','#89d3b2','#a0eac9','#a4c2f4','#d0bcf1','#fbc8d9','#e66550','#ffbc6b','#fcda83','#44b984','#68dfa9','#6d9eeb','#b694e8','#f7a7c0','#cc3a21','#eaa041','#f2c960','#149e60','#3dc789','#3c78d8','#8e63ce','#e07798','#ac2b16','#cf8933','#d5ae49','#0b804b','#2a9c68','#285bac','#653e9b','#b65775','#822111','#a46a21','#aa8831','#076239','#1a764d','#1c4587','#41236d','#83334c')]
        [string]
        $TextColor,
        [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = "Fields")]
        [Alias("PrimaryEmail", "UserKey", "Mail")]
        [ValidateNotNullOrEmpty()]
        [string]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = "InputObject")]
        [Google.Apis.Gmail.v1.Data.Label]
        $InputObject
    )
    Process {
        switch ($PSCmdlet.ParameterSetName) {
            InputObject {
                $U = $InputObject.User
                $labels = @($InputObject.Id)
            }
            Fields {
                $U = $User
                $labels = $LabelId
            }
        }
        if ($U -ceq 'me') {
            $U = $Script:PSGSuite.AdminEmail
        }
        elseif ($U -notlike "*@*.*") {
            $U = "$($U)@$($Script:PSGSuite.Domain)"
        }
        $serviceParams = @{
            Scope       = 'https://mail.google.com'
            ServiceType = 'Google.Apis.Gmail.v1.GmailService'
            User        = $U
        }
        $service = New-GoogleService @serviceParams
        try {
            $body = New-Object 'Google.Apis.Gmail.v1.Data.Label'
            foreach ($prop in $PSBoundParameters.Keys | Where-Object {$body.PSObject.Properties.Name -contains $_}) {
                $body.$prop = $PSBoundParameters[$prop]
            }
            if ($PSBoundParameters.Keys -contains 'BackgroundColor' -or $PSBoundParameters.Keys -contains 'TextColor') {
                $color = New-Object 'Google.Apis.Gmail.v1.Data.LabelColor'
                foreach ($prop in $PSBoundParameters.Keys | Where-Object {$color.PSObject.Properties.Name -contains $_}) {
                    $color.$prop = $PSBoundParameters[$prop]
                }
                $body.Color = $color
            }
            foreach ($label in $labels) {
                Write-Verbose "Updating Label Id '$label' for user '$U'"
                $request = $service.Users.Labels.Patch($body, $U, $label)
                $request.Execute() | Add-Member -MemberType NoteProperty -Name 'User' -Value $U -PassThru
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
