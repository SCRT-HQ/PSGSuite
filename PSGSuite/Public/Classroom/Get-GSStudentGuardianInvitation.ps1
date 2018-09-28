function Get-GSStudentGuardianInvitation {
    <#
    .SYNOPSIS
    Gets a guardian invitation or list of guardian invitations.

    .DESCRIPTION
    Gets a guardian invitation or list of guardian invitations.

    .PARAMETER InvitationId
    The id field of the GuardianInvitation being requested.

    .PARAMETER StudentId
    The identifier of the student whose guardian invitation is being requested. The identifier can be one of the following:

    * the numeric identifier for the user
    * the email address of the user
    * the string literal "me", indicating the requesting user
    * the string literal "-", indicating that results should be returned for all students that the requesting user is permitted to view guardian invitations. [Default]
        * **This is only allowed when excluding the `InvitationId` parameter to perform a List request!**

    .PARAMETER GuardianEmail
    If specified, only results with the specified GuardianEmail will be returned.

    .PARAMETER State
    If specified, only results with the specified state values will be returned. Otherwise, results with a state of PENDING will be returned.

    The State can be one of the following:

    * PENDING
    * COMPLETE

    .EXAMPLE
    Get-GSStudentGuardianInvitation -StudentId aristotle@athens.edu

    Gets the list of guardian invitations for this student.
    #>
    [cmdletbinding(DefaultParameterSetName = "List")]
    Param
    (
        [parameter(Mandatory = $true,ParameterSetName = "Get")]
        [Alias('Id')]
        [String[]]
        $InvitationId,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [Alias('Student')]
        [String[]]
        $StudentId = "-",
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true,ParameterSetName = "List")]
        [Alias('Guardian')]
        [String]
        $GuardianEmail,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [ValidateSet('PENDING','COMPLETE')]
        [String[]]
        $States = @('PENDING','COMPLETE')
    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/classroom.guardianlinks.students'
            ServiceType = 'Google.Apis.Classroom.v1.ClassroomService'
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        foreach ($stuId in $StudentId) {
            try {
                if ($stuId -ne '-') {
                    if ( -not ($stuId -as [decimal])) {
                        if ($stuId -ceq 'me') {
                            $stuId = $Script:PSGSuite.AdminEmail
                        }
                        elseif ($stuId -notlike "*@*.*") {
                            $stuId = "$($stuId)@$($Script:PSGSuite.Domain)"
                        }
                    }
                }
                elseif ($PSCmdlet.ParameterSetName -eq 'Get') {
                    Write-Error "You must specify a valid StudentId when using InvitationId! Current value '$stuId'"
                }
                switch ($PSCmdlet.ParameterSetName) {
                    Get {
                        foreach ($invId in $InvitationId) {
                            try {
                                Write-Verbose "Getting Guardian Invitation '$invId' for Student '$stuId'"
                                $request = $service.UserProfiles.GuardianInvitations.Get($stuId,$invId)
                                $request.Execute()
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
                    List {
                        try {
                            if ($stuId -eq '-') {
                                Write-Verbose "Listing all Guardian Invitations"
                            }
                            else {
                                Write-Verbose "Listing Guardian Invitations for Student '$stuId'"
                            }
                            $request = $service.UserProfiles.GuardianInvitations.List($stuId)
                            foreach ($s in $States) {
                                $request.States += [Google.Apis.Classroom.v1.UserProfilesResource+GuardianInvitationsResource+ListRequest+StatesEnum]::$s
                            }
                            if ($PSBoundParameters.Keys -contains 'GuardianEmail') {
                                $request.InvitedEmailAddress = $GuardianEmail
                            }
                            [int]$i = 1
                            do {
                                $result = $request.Execute()
                                if ($null -ne $result.GuardianInvitations) {
                                    $result.GuardianInvitations
                                }
                                $request.PageToken = $result.NextPageToken
                                [int]$retrieved = ($i + $result.GuardianInvitations.Count) - 1
                                Write-Verbose "Retrieved $retrieved Guardian Invitations..."
                                [int]$i = $i + $result.GuardianInvitations.Count
                            }
                            until (!$result.NextPageToken)
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
