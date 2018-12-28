function New-GSStudentGuardianInvitation {
    <#
    .SYNOPSIS
    Creates a guardian invitation, and sends an email to the guardian asking them to confirm that they are the student's guardian.

    .DESCRIPTION
    Creates a guardian invitation, and sends an email to the guardian asking them to confirm that they are the student's guardian.

    .PARAMETER StudentId
    Identifier of the user to invite. The identifier can be one of the following:

    * the numeric identifier for the user
    * the email address of the user

    .PARAMETER GuardianEmail
    The email address of the guardian to invite.

    .PARAMETER User
    The user to authenticate the request as

    .EXAMPLE
    New-GSStudentGuardianInvitation -StudentId aristotle@athens.edu -GuardianEmail zeus@olympus.io

    .EXAMPLE
    Import-Csv .\Student_Guardian_List.csv | New-GSStudentGuardianInvitation

    Process a CSV with two columns containing headers "Student" and "Guardian" and send the invites accordingly, i.e.

    |      StudentId       |  GuardianEmail  |
    |:--------------------:|:---------------:|
    | aristotle@athens.edu | zeus@olympus.io |
    | plato@athens.edu     | hera@olympus.io |
    #>
    [OutputType('Google.Apis.Classroom.v1.Data.GuardianInvitation')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias('Student')]
        [String]
        $StudentId,
        [parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias('Guardian')]
        [String]
        $GuardianEmail,
        [parameter(Mandatory = $false)]
        [String]
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
            Scope       = 'https://www.googleapis.com/auth/classroom.guardianlinks.students'
            ServiceType = 'Google.Apis.Classroom.v1.ClassroomService'
            User        = $User
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        try {
            if ( -not ($StudentId -as [decimal])) {
                if ($StudentId -ceq 'me') {
                    $StudentId = $Script:PSGSuite.AdminEmail
                }
                elseif ($StudentId -notlike "*@*.*") {
                    $StudentId = "$($StudentId)@$($Script:PSGSuite.Domain)"
                }
            }
            $body = New-Object 'Google.Apis.Classroom.v1.Data.GuardianInvitation' -Property @{
                StudentId = $StudentId
                InvitedEmailAddress = $GuardianEmail
            }
            Write-Verbose "Inviting Guardian '$GuardianEmail' for Student '$StudentId'"
            $request = $service.UserProfiles.GuardianInvitations.Create($body,$StudentId)
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
