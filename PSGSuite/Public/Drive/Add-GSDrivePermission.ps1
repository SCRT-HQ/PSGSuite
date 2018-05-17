function Add-GSDrivePermission {
    <#
    .SYNOPSIS
    Adds a new permission to a Drive file
    
    .DESCRIPTION
    Adds a new permission to a Drive file
    
    .PARAMETER User
    The owner of the Drive file

    Defaults to the AdminEmail user
    
    .PARAMETER FileId
    The unique Id of the Drive file you would like to add the permission to
    
    .PARAMETER Role
    The role/permission set you would like to give the email $EmailAddress

    Available values are:
    * "Owner"
    * "Writer"
    * "Commenter"
    * "Reader"
    * "Organizer"
    
    .PARAMETER Type
    The type of the grantee

    Available values are:
    * "User": a user email
    * "Group": a group email
    * "Domain": the entire domain
    * "Anyone": public access
    
    .PARAMETER EmailAddress
    The email address of the user or group to which this permission refers
    
    .PARAMETER Domain
    The domain to which this permission refers
    
    .PARAMETER ExpirationTime
    The time at which this permission will expire. 
    
    Expiration times have the following restrictions: 
    * They can only be set on user and group permissions
    * The time must be in the future
    * The time cannot be more than a year in the future 
    
    .PARAMETER EmailMessage
    A plain text custom message to include in the notification email
    
    .PARAMETER SendNotificationEmail
    Whether to send a notification email when sharing to users or groups. This defaults to true for users and groups, and is not allowed for other requests. It must not be disabled for ownership transfers
    
    .PARAMETER AllowFileDiscovery
    Whether the permission allows the file to be discovered through search. This is only applicable for permissions of type domain or anyone
    
    .PARAMETER TransferOfOwnership
    Confirms transfer of ownership if the Role is set to 'Owner'. You can also force the same behavior by passing -Confirm:$false instead
    
    .PARAMETER UseDomainAdminAccess
    Whether the request should be treated as if it was issued by a domain administrator; if set to true, then the requester will be granted access if they are an administrator of the domain to which the item belongs
    
    .EXAMPLE
    Add-GSDrivePermission -FileId "1rhsAYTOB_vrpvfwImPmWy0TcVa2sgmQa_9u976" -Role Owner -Type User -EmailAddress joe -SendNotificationEmail -Confirm:$false

    Adds user joe@domain.com as the new owner of the file Id and sets the AdminEmail user as a Writer on the file
    #>
    [cmdletbinding(SupportsShouldProcess = $true,ConfirmImpact = "High",DefaultParameterSetName = "Email")]
    Param
    (
        [parameter(Mandatory = $false,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [Alias('Owner','PrimaryEmail','UserKey','Mail')]
        [string]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $true)]
        [String]
        $FileId,
        [parameter(Mandatory = $true)]
        [ValidateSet("Owner","Writer","Commenter","Reader","Organizer")]
        [String]
        $Role,
        [parameter(Mandatory = $true)]
        [ValidateSet("User","Group","Domain","Anyone")]
        [String]
        $Type,
        [parameter(Mandatory = $false,ParameterSetName = "Email")]
        [String]
        $EmailAddress,
        [parameter(Mandatory = $false,ParameterSetName = "Domain")]
        [String]
        $Domain,
        [parameter(Mandatory = $false)]
        [DateTime]
        $ExpirationTime,
        [parameter(Mandatory = $false)]
        [string]
        $EmailMessage,
        [parameter(Mandatory = $false)]
        [Switch]
        $SendNotificationEmail,
        [parameter(Mandatory = $false)]
        [Switch]
        $AllowFileDiscovery,
        [parameter(Mandatory = $false)]
        [Alias('ConfirmTransferOfOwnership')]
        [switch]
        $TransferOfOwnership,
        [parameter(Mandatory = $false)]
        [switch]
        $UseDomainAdminAccess
    )
    Begin {
        if ($User -ceq 'me') {
            $User = $Script:PSGSuite.AdminEmail
        }
        elseif ($User -notlike "*@*.*") {
            $User = "$($User)@$($Script:PSGSuite.Domain)"
        }
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/drive'
            ServiceType = 'Google.Apis.Drive.v3.DriveService'
            User        = $User
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        try {
            if ($Role -eq "Owner" -and !$TransferOfOwnership) {
                if ($PSCmdlet.ShouldProcess("Confirm transfer of ownership of FileId '$FileID' from user '$User' to user '$EmailAddress'")) {
                    $PSBoundParameters['TransferOfOwnership'] = $true
                    $TransferOfOwnership = $true
                }
                else {
                    throw "The TransferOfOwnership parameter is required when setting the 'Owner' role."
                }
            }
            if (($Type -eq "User" -or $Type -eq "Group") -and !$EmailAddress) {
                throw "The EmailAddress parameter is required for types 'User' or 'Group'."
            }
            if (($Type -eq "User" -or $Type -eq "Group") -and ($PSBoundParameters.Keys -contains 'AllowFileDiscovery')) {
                Write-Warning "The AllowFileDiscovery parameter is only applicable for types 'Domain' or 'Anyone' This parameter will be excluded from this request."
                $PSBoundParameters.Remove('AllowFileDiscovery') | Out-Null
            }
            if ($TransferOfOwnership -and !$SendNotificationEmail) {
                $PSBoundParameters['SendNotificationEmail'] = $true
                Write-Warning "Setting SendNotificationEmail to 'True' to prevent errors (required for Ownership transfers)"
            }
            $body = New-Object 'Google.Apis.Drive.v3.Data.Permission'
            foreach ($key in $PSBoundParameters.Keys) {
                switch ($key) {
                    EmailAddress {
                        if ($EmailAddress -ceq 'me') {
                            $EmailAddress = $Script:PSGSuite.AdminEmail
                        }
                        elseif ($EmailAddress -notlike "*@*.*") {
                            $EmailAddress = "$($EmailAddress)@$($Script:PSGSuite.Domain)"
                        }
                        $body.EmailAddress = $EmailAddress
                    }
                    Role {
                        $body.$key = ($PSBoundParameters[$key]).ToLower()
                    }
                    Type {
                        $body.$key = ($PSBoundParameters[$key]).ToLower()
                    }
                    Default {
                        if ($body.PSObject.Properties.Name -contains $key) {
                            $body.$key = $PSBoundParameters[$key]
                        }
                    }
                }
            }
            $request = $service.Permissions.Create($body,$FileId)
            $request.SupportsTeamDrives = $true
            foreach ($key in $PSBoundParameters.Keys) {
                if ($request.PSObject.Properties.Name -contains $key -and $key -ne 'FileId') {
                    $request.$key = $PSBoundParameters[$key]
                }
            }
            Write-Verbose "Adding Drive Permission of '$Role' for user '$User' on Id '$FileID'"
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