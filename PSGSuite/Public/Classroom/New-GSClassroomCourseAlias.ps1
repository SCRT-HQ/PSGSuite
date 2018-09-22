function New-GSClassroomCourseAlias {
    <#
    .SYNOPSIS
    Creates a course alias.

    .DESCRIPTION
    Creates a course alias.

    .PARAMETER Alias
    Alias string

    .PARAMETER CourseId
    Identifier of the course to alias. This identifier can be either the Classroom-assigned identifier or an alias.

    .PARAMETER Scope
    An alias uniquely identifies a course. It must be unique within one of the following scopes:

    * Domain - A domain-scoped alias is visible to all users within the alias creator's domain and can be created only by a domain admin. A domain-scoped alias is often used when a course has an identifier external to Classroom.
    * Project - A project-scoped alias is visible to any request from an application using the Developer Console project ID that created the alias and can be created by any project. A project-scoped alias is often used when an application has alternative identifiers. A random value can also be used to avoid duplicate courses in the event of transmission failures, as retrying a request will return ALREADY_EXISTS if a previous one has succeeded.

    .EXAMPLE
    New-GSClassroomCourseAlias -Alias "abc123" -CourseId 'architecture-101' -Scope Domain

    .EXAMPLE
    New-GSClassroomCourseAlias -Alias "d:abc123" -CourseId 'architecture-101'
    #>
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0)]
        [String]
        $Alias,
        [parameter(Mandatory = $true,Position = 1)]
        [String]
        $CourseId,
        [parameter(Mandatory = $false)]
        [ValidateSet('Domain','Project')]
        [String]
        $Scope = $(if($Alias -match "^p\:"){'Project'}else{'Domain'})
    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/classroom.courses'
            ServiceType = 'Google.Apis.Classroom.v1.ClassroomService'
        }
        $service = New-GoogleService @serviceParams
        $formatted = if ($Alias -match "^(d\:|p\:)") {
            $Alias
            $Scope = if ($Alias -match "^d\:") {
                'Domain'
            }
            else {
                'Project'
            }
        }
        else {
            switch ($Scope) {
                Domain {
                    'd:' + ($Alias -replace "^(d\:|p\:)","")
                }
                Project {
                    'p:' + ($Alias -replace "^(d\:|p\:)","")
                }
            }

        }
    }
    Process {
        try {
            Write-Verbose "Creating new Course Alias '$Alias' at '$Scope' scope"
            $body = New-Object 'Google.Apis.Classroom.v1.Data.CourseAlias' -Property @{
                Alias = $formatted
            }
            $request = $service.Courses.Aliases.Create($body,$CourseId)
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
