function New-GSCourseInvitation {
    <#
    .SYNOPSIS
    Creates a course invitation.

    .DESCRIPTION
    Creates a course invitation.

    .PARAMETER CourseId
    Identifier of the course to invite the user to. This identifier can be either the Classroom-assigned identifier or an alias.

    .PARAMETER UserId
    Identifier of the user to invite. The identifier can be one of the following:

    * the numeric identifier for the user
    * the email address of the user
    * the string literal "me", indicating the requesting user

    .PARAMETER Role
    Role to invite the user to have from the following:

    * STUDENT
    * TEACHER
    * OWNER

    .PARAMETER User
    The user to authenticate the request as

    .EXAMPLE
    New-GSCourseInvitation -CourseId philosophy-101 -UserId aristotle@athens.edu -Role TEACHER
    #>
    [OutputType('Google.Apis.Classroom.v1.Data.Invitation')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true)]
        [String]
        $CourseId,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias('PrimaryEmail','Email','Mail')]
        [String[]]
        $UserId,
        [parameter(Mandatory = $false)]
        [ValidateSet('STUDENT','TEACHER','OWNER')]
        [String]
        $Role = 'STUDENT',
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [String]
        $User = $Script:PSGSuite.AdminEmail
    )
    Process {
        if ($User -ceq 'me') {
            $User = $Script:PSGSuite.AdminEmail
        }
        elseif ($User -notlike "*@*.*") {
            $User = "$($User)@$($Script:PSGSuite.Domain)"
        }
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/classroom.rosters'
            ServiceType = 'Google.Apis.Classroom.v1.ClassroomService'
            User        = $User
        }
        $service = New-GoogleService @serviceParams
        foreach ($U in $UserId) {
            try {
                if ( -not ($U -as [decimal])) {
                    if ($U -ceq 'me') {
                        $U = $Script:PSGSuite.AdminEmail
                    }
                    elseif ($U -notlike "*@*.*") {
                        $U = "$($U)@$($Script:PSGSuite.Domain)"
                    }
                }
                Write-Verbose "Inviting User '$U' to Course '$CourseId' for Role '$Role'"
                $body = New-Object 'Google.Apis.Classroom.v1.Data.Invitation'
                foreach ($prop in $PSBoundParameters.Keys | Where-Object {$body.PSObject.Properties.Name -contains $_}) {
                    $body.$prop = $PSBoundParameters[$prop]
                }
                if ($PSBoundParameters.Keys -notcontains 'Role') {
                    $body.Role = $Role
                }
                $request = $service.Invitations.Create($body)
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
