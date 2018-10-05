function Remove-GSCourse {
    <#
    .SYNOPSIS
    Removes an existing course.

    .DESCRIPTION
    Removes an existing course.

    .PARAMETER Id
    Identifier for this course assigned by Classroom.

    .PARAMETER User
    The user to authenticate the request as

    .EXAMPLE
    Remove-GSCourse -Id the-republic-s01 -Confirm:$false
    #>
    [cmdletbinding(SupportsShouldProcess = $true,ConfirmImpact = "High")]
    Param
    (
        [parameter(Mandatory = $true,Position = 0)]
        [Alias('Alias')]
        [String]
        $Id,
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
            Scope       = 'https://www.googleapis.com/auth/classroom.courses'
            ServiceType = 'Google.Apis.Classroom.v1.ClassroomService'
            User        = $User
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        try {
            if ($PSCmdlet.ShouldProcess("Removing Course '$Id'")) {
                Write-Verbose "Removing Course '$Id'"
                $request = $service.Courses.Delete($Id)
                $request.Execute()
                Write-Verbose "Course '$Id' has been successfully removed"
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
