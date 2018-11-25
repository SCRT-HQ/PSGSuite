function Update-GSGroupMember {
    <#
    .SYNOPSIS
    Updates a group member's role and/or delivery preference

    .DESCRIPTION
    Updates a group member's role and/or delivery preference

    .PARAMETER GroupEmail
    The email or GroupID of the group to update members of

    .PARAMETER Member
    The member email or list of member emails that you would like to update

    .PARAMETER Role
    The role that you would like to update the members to

    Acceptable values are:
    * MEMBER
    * MANAGER
    * OWNER

    .PARAMETER DeliverySettings
    Defines mail delivery preferences of member

    Acceptable values are:
    * "ALL_MAIL": All messages, delivered as soon as they arrive.
    * "DAILY": No more than one message a day.
    * "DIGEST": Up to 25 messages bundled into a single message.
    * "DISABLED": Remove subscription.
    * "NONE": No messages.

    .EXAMPLE
    Get-GSGroupMember myGroup | Update-GSGroupMember -DeliverySettings ALL_MAIL

    Updates the delivery preference for all members of group 'myGroup@domain.com' to 'ALL_MAIL'
    #>
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias('Group')]
        [String]
        $GroupEmail,
        [parameter(Mandatory = $true,Position = 1,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail","User","UserEmail","Email")]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Member,
        [parameter(Mandatory = $false)]
        [ValidateSet("MEMBER","MANAGER","OWNER")]
        [String]
        $Role,
        [parameter(Mandatory = $false)]
        [ValidateSet("ALL_MAIL","DAILY","DIGEST","DISABLED","NONE")]
        [String]
        $DeliverySettings
    )
    Begin {
        $serviceParams = @{
            Scope       = @(
                'https://www.googleapis.com/auth/admin.directory.group'
            )
            ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        try {
            if ($GroupEmail -notlike "*@*.*") {
                $GroupEmail = "$($GroupEmail)@$($Script:PSGSuite.Domain)"
            }
            #$groupObj = Get-GSGroup -Group $Identity -Verbose:$false
            try {
                foreach ($U in $Member) {
                    if ($U -notlike "*@*.*") {
                        $U = "$($U)@$($Script:PSGSuite.Domain)"
                    }
                    Write-Verbose "Updating member '$U' of group '$GroupEmail'"
                    $body = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.Member'
                    if ($PSBoundParameters.Keys -contains 'DeliverySettings') {
                        $body.DeliverySettings = $PSBoundParameters['DeliverySettings']
                    }
                    if ($PSBoundParameters.Keys -contains 'Role') {
                        $body.Role = $PSBoundParameters['Role']
                    }
                    $request = $service.Members.Patch($body,$GroupEmail,$U)
                    $request.Execute() | Add-Member -MemberType NoteProperty -Name 'Group' -Value $GroupEmail -PassThru
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
