function Get-GSClassroomUserProfile {
    <#
    .SYNOPSIS
    Gets a classroom user profile

    .DESCRIPTION
    Gets a classroom user profile

    .PARAMETER UserId
    Identifier of the profile to return. The identifier can be one of the following:

    * the numeric identifier for the user
    * the email address of the user
    * the string literal "me", indicating the requesting user

    .EXAMPLE
    Get-GSClassroomUserProfile -UserId aristotle@athens.edu
    #>
    [cmdletbinding(DefaultParameterSetName = "List")]
    Param
    (
        [parameter(Mandatory = $true,Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String[]]
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
        foreach ($part in $UserId) {
            try {
                if ( -not ($part -as [decimal])) {
                    if ($part -ceq 'me') {
                        $part = $Script:PSGSuite.AdminEmail
                    }
                    elseif ($part -notlike "*@*.*") {
                        $part = "$($part)@$($Script:PSGSuite.Domain)"
                    }
                }
                Write-Verbose "Getting Classroom User Profile for '$part'"
                $request = $service.UserProfiles.Get($part)
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
}
