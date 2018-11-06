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

    .PARAMETER Fields
    The specific fields to fetch

    .EXAMPLE
    Get-GSClassroomUserProfile -UserId aristotle@athens.edu
    #>
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [Alias('Id','PrimaryEmail','Mail','UserKey')]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $UserId,
        [parameter(Mandatory = $false)]
        [String[]]
        $Fields = '*'
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
                $request.Fields = "$($Fields -join ",")"
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
