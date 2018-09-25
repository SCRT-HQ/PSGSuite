function Get-GSCourseInvitation {
    <#
    .SYNOPSIS
    Gets a course invitation or list of invitations

    .DESCRIPTION
    Gets a course invitation or list of invitations

    .PARAMETER Id
    Identifier of the invitation to return.

    .PARAMETER CourseId
    Restricts returned invitations to those for a course with the specified identifier. This identifier can be either the Classroom-assigned identifier or an alias.

    .PARAMETER UserId
    Restricts returned invitations to those for a specific user. The identifier can be one of the following:

    * the numeric identifier for the user
    * the email address of the user
    * the string literal "me", indicating the requesting user

    .EXAMPLE
    Get-GSCourseInvitation -CourseId philosophy-101
    #>
    [cmdletbinding(DefaultParameterSetName = "List")]
    Param
    (
        [parameter(Mandatory = $true,ParameterSetName = "Get")]
        [String[]]
        $Id,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [String]
        $CourseId,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [String]
        $UserId
    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/classroom.rosters'
            ServiceType = 'Google.Apis.Classroom.v1.ClassroomService'
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        switch ($PSCmdlet.ParameterSetName) {
            Get {
                foreach ($part in $Id) {
                    try {
                        Write-Verbose "Getting Invitation ID '$part'"
                        $request = $service.Invitations.Get($part)
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
                    if ($PSBoundParameters.Keys -notcontains 'CourseId' -and $PSBoundParameters.Keys -notcontains 'UserId') {
                        Write-Error "You must specify a CourseId and/or a UserId!"
                    }
                    else {
                        $request =  $service.Invitations.List()
                        $verbMsg = ""
                        if ($PSBoundParameters.Keys -contains 'CourseId') {
                            $verbMsg += " [Course: $CourseId]"
                            $request.CourseId = $CourseId
                        }
                        if ($PSBoundParameters.Keys -contains 'UserId') {
                            try {
                                [decimal]$UserId | Out-Null
                            }
                            catch {
                                if ($UserId -ceq 'me') {
                                    $UserId = $Script:PSGSuite.AdminEmail
                                }
                                elseif ($UserId -notlike "*@*.*") {
                                    $UserId = "$($UserId)@$($Script:PSGSuite.Domain)"
                                }
                            }
                            $verbMsg += " [User: $UserId]"
                            $request.UserId = $UserId
                        }
                        Write-Verbose "Getting List of Invitations for$($verbMsg)"
                        [int]$retrieved = 0
                        [int]$i = 1
                        do {
                            $result = $request.Execute()
                            if ($null -ne $result.Invitations) {
                                $result.Invitations
                            }
                            [int]$retrieved = ($i + $result.Invitations.Count) - 1
                            [int]$i = $i + $result.Invitations.Count
                            $request.PageToken = $result.NextPageToken
                            Write-Verbose "Retrieved $retrieved Invitations..."
                        }
                        until (!$result.NextPageToken)
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
}
