Function Sync-GSCourse {
    <#
    .SYNOPSIS
    Syncs one or more courses with Google Classroom.
    .DESCRIPTION
    Syncs one or more courses with Google Classroom by comparing the course values supplied to Sync-GSCourse with the values found in Classroom. Where a discrepancy is found Sync-GSCourse will update Classroom to match.
    It is intended to primarily be used in conjunction with enrolment data retrieved from School Information Systems (SIS) to allow easily managing courses and enrolments in Classroom.
    .PARAMETER Name
    Name of the course. For example, "10th Grade Biology". The name is required. It must be between 1 and 750 characters and a valid UTF-8 string.
    .PARAMETER OwnerId
    The identifier of the owner of a course.
    The identifier can be one of the following:
    * the numeric identifier for the user
    * the email address of the user
    .PARAMETER Id
    Identifier for this course assigned by Classroom.
    The identifier can be one of the following:
    * the numeric identifier assigned by Classroom
    * an alias string assigned to the course
    It is recommended to use alias strings where possible. If the course is created by SYnc-GSCourse and an alis string was specified the alias string will be automatically assigned to the course for future use.
    .PARAMETER Section
    Section of the course. For example, "Period 2". If set, this field must be a valid UTF-8 string and no longer than 2800 characters.
    .PARAMETER DescriptionHeading
    Optional heading for the description. For example, "Welcome to 10th Grade Biology." If set, this field must be a valid UTF-8 string and no longer than 3600 characters.
    .PARAMETER Description
    Optional description. For example, "We'll be learning about the structure of living creatures from a combination of textbooks, guest lectures, and lab work. Expect to be excited!" If set, this field must be a valid UTF-8 string and no longer than 30,000 characters.
    .PARAMETER Room
    Optional room location. For example, "301". If set, this field must be a valid UTF-8 string and no longer than 650 characters.
    .PARAMETER CourseState
    State of the course. If unspecified, the default state is PROVISIONED
    Available values are:
    * ACTIVE - The course is active.
    * ARCHIVED - The course has been archived. You cannot modify it except to change it to a different state.
    * PROVISIONED - The course has been created, but not yet activated. It is accessible by the primary teacher and domain administrators, who may modify it or change it to the ACTIVE or DECLINED states. A course may only be changed to PROVISIONED if it is in the DECLINED state.
    * DECLINED - The course has been created, but declined. It is accessible by the course owner and domain administrators, though it will not be displayed in the web UI. You cannot modify the course except to change it to the PROVISIONED state. A course may only be changed to DECLINED if it is in the PROVISIONED state.
    .PARAMETER Student
    Email address of the user partcipating in the course as a student
    .PARAMETER Teacher
    Email address of the user partcipating in the course as a teacher
    .PARAMETER CachePath
    The file path to the Classroom course cache CSV file.
    If specified Sync-GSCourse will attempt to read and write course properties to this file during execution. By caching course properties on the local file system the current course properties do not need to be retrieved from Classroom saving API calls and reducing the time taken to execute. 
    If unspecified no caching will be used.
    .PARAMETER RemoveStudents
    If $True Sync-GSCourse will remove students from the course if required
    .PARAMETER RemoveTeachers
    If $True Sync-GSCourse will remove teachers from the course if required
    .PARAMETER AddStudents
    If $True Sync-GSCourse will add students to the course if required
    .PARAMETER AddTeachers
    If $True Sync-GSCourse will add teachers to the course if requried
    .PARAMETER CreateCourses
    If $True Sync-GSCourse will create the course if required.
    .PARAMETER UpdateCourses
    If $True Sync-GSCourse will update the course properties if required
    .PARAMETER ArchiveCourses
    If $True Sync-GSCourse will archive the course if required
    .PARAMETER Passthru
    If $True Sync-GSCourse will return the course details to the pipeline
    .EXAMPLE
    $Courses = @()

    $Courses += New-Object PSObject -Property @{
        Name = "Example Course 1"
        OwnerID = "teacher1@foo.com"
        ID = "Example1"
        Description = "This is an example course."
        DescriptionHeading = "Example Course 1"
        Room = "Room 1"
        CourseState = "Active"
        Teacher = @('teacher1@foo.com','teacher2@foo.com')
    }

    $Courses += New-Object PSObject -Property @{
        Name = "Example Course 2"
        OwnerID = "teacher1@foo.com"
        ID = "Example2"
        CourseState = "Active"
        Teacher = @('teacher1@foo.com')
        Student = @('student1@foo.com','student2@foo.com')
    }

    $Courses | Sync-GSCourse -CachePath 'C:\CourseCache.CSV' -CreateCourses

    This command would search for the two courses identified by the alias strings 'd:Exmaple1' and 'd:example2'.
    If the courses do not exist in Classroom they will be created. However, the only particiapnts added to the courses are the course owners due to the -AddStudents and -AddTeachers switches being $False.
    If the courses exist in Classroom they will not be updated due to the -UpdateCourses switch being $False. NO changes will be made to the course participants due to the -AddStudents, -RemoveStudents, -AddTeachers and -RemoveTeachers switches all being $False.
    .EXAMPLE
    Get-GSCourse | ForEach-Object {$_.CourseState = 'ARCHIVED';$_} | Sync-GSCourse -ArchiveCourses

    This command would archive all courses found in Classroom.
    .EXAMPLE
    Get-GSCourse | ForEach-Object {
        New-Object PSObject -property @{
            ID = $_.ID
            Student = @('student1@foo.com','student2@foo.com')
        }
    } | Sync-GSCourse -AddStudents

    This command would add student1@foo.com and student2@foo.com to all courses found in Classroom.
    .EXAMPLE
    @('123456789', 'd:Example2', 'Example3', 'Example4') | ForEach-Object {
        New-Object PSObject -property @{
            ID = $_.ID
            Teacher = @('teacher1@foo.com','teacher2@foo.com')
        }
    } | Sync-GSCourse -AddTeachers

    This command would add teacher1@foo.com and teacher2@foo.com to the specified courses.

    #>
    [cmdletbinding(SupportsShouldProcess = $true,ConfirmImpact = "High")]
    Param
    (
        [parameter(Mandatory = $false,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [ValidateLength(1,750)]
        [String]
        $Name,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [String]
        $OwnerId,
        [parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias('Alias')]
        [String]
        $Id,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [ValidateLength(1,2800)]
        [String]
        $Section,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [ValidateLength(1,3600)]
        [Alias('Heading')]
        [String]
        $DescriptionHeading,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [ValidateLength(1,30000)]
        [String]
        $Description,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [String]
        $Room,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [Alias('Status')]
        [ValidateSet('PROVISIONED','ACTIVE','ARCHIVED','DECLINED')]
        [String]
        $CourseState,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [String[]]
        $Student = @(),
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [String[]]
        $Teacher = @(),
        [parameter(Mandatory = $false)]
        [String]
        $CachePath,
        [parameter(Mandatory = $false)]
        [switch]
        $RemoveStudents,
        [parameter(Mandatory = $false)]
        [switch]
        $RemoveTeachers,
        [parameter(Mandatory = $false)]
        [switch]
        $ArchiveCourses,
        [parameter(Mandatory = $false)]
        [switch]
        $CreateCourses,
        [parameter(Mandatory = $false)]
        [switch]
        $UpdateCourses,
        [parameter(Mandatory = $false)]
        [switch]
        $PassThru
    )
    Begin {
        If ($VerbosePreference -eq "Continue"){
            $verbose = $True
        } else {
            $Verbose = $False
        }
        
        If ($null -eq $Global:GSUserCache){
            Sync-GSUserCache -Verbose:$Verbose
        }

        # Initialise a hashtable to store all of the cached courses and aliases
        $AliasCache = @{}
        $CourseCache = @{}

        If ($CachePath){
            # Load the cached course information
            If (Test-Path $CachePath){
                write-host "Loading cached courses from '$CachePath'"
                Try {
                    Import-CSV -Path $CachePath -verbose:$verbose | ForEach-Object {
                        $Course = New-Object PSObject -Property @{
                            Name = $_.Name
                            OwnerID = $_.OwnerID
                            ID = $_.ID
                            Section = $_.Section
                            Description = $_.Description
                            DescriptionHeading = $_.DescriptionHeading
                            Room = $_.Room
                            CourseState = $_.CourseState
                            Alias = @()
                            Student = @()
                            Teacher = @()
                        }
                        $_.Alias.Split(";") | Where-Object {$_} | ForEach-Object {
                            $Course.Alias += $_
                            $AliasCache[$_] = $Course.ID
                        }
                        $_.Student.Split(";") | Where-Object {$_} | ForEach-Object {
                            $Course.Student += $_
                        }
                        $_.Teacher.Split(";") | Where-Object {$_} | ForEach-Object {
                            $Course.Teacher += $_
                        }
                        $CourseCache[$Course.ID] = $Course
                    }
                } catch {
                    if ($ErrorActionPreference -eq 'Stop') {
                        $PSCmdlet.ThrowTerminatingError($_)
                    } else {
                        Write-Error $_
                    }
                }
            }
        }
        Write-Verbose "Loaded $($CourseCache.Count) courses and $($AliasCache.count) aliases from cache."
        
    }

    Process {

        Trap {
            $_
            write-host "Error"
        }
        
        # Get the course ID from the supplied alias/ID in the cache.
        $CourseID = $null
        $CourseAlias = $null
        If ($Id -match "^[0-9]+$"){
            If ($CourseCache.ContainsKey($Id)){
                $CourseID = $Id
            }
            $CourseAlias = $Id
        } else {
            If ($Id -match "^d:"){
                $CourseAlias = $Id
            } else {
                $CourseAlias = "d:$Id"
            }
            $CourseID = $AliasCache[$CourseAlias]
        }

        Write-Host "Processing: $CourseAlias"

        # Try and get the course direct from Google Classroom
        If ($null -eq $CourseID){
            Write-Verbose "Course '$CourseAlias' not found in cache"
            Try {
                Get-GSCourse -ErrorAction Stop -id $CourseAlias -Verbose:$Verbose | ForEach-Object {
                    $Course = New-Object PSObject -Property @{
                        Name = $_.Name
                        OwnerID = $Global:GSUserCache[$_.OwnerID].user
                        ID = $_.ID
                        Section = $_.Section
                        Description = $_.Description
                        DescriptionHeading = $_.DescriptionHeading
                        Room = $_.Room
                        CourseState = $_.CourseState
                        Alias = @()
                        Student = @()
                        Teacher = @()
                    }
                    Get-GSCourseAlias -CourseId $_.ID -ErrorAction Stop -Verbose:$Verbose | Select-Object -ExpandProperty Aliases | ForEach-Object {
                        $Course.Alias += $_.Alias
                        $AliasCache[$_.Alias] = $Course.ID
                    }

                    Get-GSCourseParticipant -CourseId $_.ID -Role Student -ErrorAction Stop -Verbose:$Verbose | Select-Object -ExpandProperty Profile | ForEach-Object {
                        $Course.Student += $_.EmailAddress
                    }
                    Get-GSCourseParticipant -CourseId $_.ID -Role Teacher -ErrorAction Stop -Verbose:$Verbose | Select-Object -ExpandProperty Profile | ForEach-Object {
                        $Course.Teacher += $_.EmailAddress
                    }
                    $CourseCache[$Course.ID] = $Course
                    $CourseID = $Course.ID
                }
            } catch {
                Switch -regex ($_.exception.message){
                    "Message\[Requested entity was not found\.\]" {
                        write-verbose "Course '$CourseAlias' not found in Google Classroom"
                    }
                    Default {
                        if ($ErrorActionPreference -eq 'Stop') {
                            $PSCmdlet.ThrowTerminatingError($_)
                        } else {
                            Write-Error $_
                        }
                    }
                }   
            }
        }


        # Create non-existant courses
        If ($null -eq $CourseID){
            #Create the course now and add the course users further below.
            If ($CreateCourses){
                
                If ($CourseAlias -match "^[0-9]+$"){
                    write-warning "Course '$CourseAlias' cannot be created. Please specify an alias string instead of an ID number."
                    Return
                }
                
                Try {
                    $Params = @{}
                    ForEach ($Param in @('Section', 'DescriptionHeading', 'Description', 'Room')){
                        If ($PSBoundParameters[$Param]){
                            $Params[$Param] = $PSBoundParameters[$Param]
                        }    
                    }
                    New-GSCourse @Params -Name $Name -OwnerId $OwnerId -Id $CourseAlias -User $OwnerId -ErrorAction Stop -Verbose:$Verbose | ForEach-Object {
                        $Course = New-Object PSObject -Property @{
                            Name = $_.Name
                            OwnerID = $Global:GSUserCache[$_.OwnerID].user
                            ID = $_.ID
                            Section = $_.Section
                            Description = $_.Description
                            DescriptionHeading = $_.DescriptionHeading
                            Room = $_.Room
                            CourseState = $_.CourseState
                            Alias = @($CourseAlias)
                            Student = @()
                            Teacher = @()
                        }
                        $Course.Teacher += $Course.OwnerID
                        $CourseCache[$Course.ID] = $Course
                        $AliasCache[$CourseAlias] = $Course.ID
                        $CourseID = $Course.ID
                    }
                } catch {
                    if ($ErrorActionPreference -eq 'Stop') {
                        $PSCmdlet.ThrowTerminatingError($_)
                    } else {
                        Write-Error $_
                    }
                }
            } else {
                write-warning "Unable to create course '$CourseAlias'. The -createCourse switch is not present."
                # The course does not exist. No point executing the remaining logic.
                Return
            }      
        }

        # Check course users
        $StudentsToAdd = @()
        $StudentsToRemove = @()
        $TeachersToAdd = @()
        $TeachersToRemove = @()
        $MembershipUpdated = $False

        Compare-Object -ReferenceObject $Student -DifferenceObject $CourseCache[$CourseId].Student | ForEach-Object {
            If ($_.SideIndicator -eq "<="){
                $StudentsToAdd += $_.inputObject
            } else {
                $StudentsToRemove += $_.inputObject
            }
        }
        $TempTeacher = $Teacher.Clone()
        $TempTeacher = $TempTeacher += $OwnerID | Select-Object -Unique
        Compare-Object -ReferenceObject $Teacher -DifferenceObject $CourseCache[$CourseId].Teacher | ForEach-Object {
            If ($_.SideIndicator -eq "<="){
                $TeachersToAdd += $_.inputObject
            } else {
                $TeachersToRemove += $_.inputObject
            }
        }

        If ($StudentsToRemove.count){
            If ($RemoveStudents){
                Try {
                    $MembershipUpdated = $True
                    Remove-GSCourseParticipant -CourseId $CourseAlias -Student $StudentsToRemove -Confirm:$Confirm -ErrorAction Stop -Verbose:$Verbose | Out-Null
                } catch {
                    if ($ErrorActionPreference -eq 'Stop') {
                        $PSCmdlet.ThrowTerminatingError($_)
                    } else {
                        Write-Error $_
                    }
                }
            } else {
                Write-Warning "Unable to remove $($StudentsToRemove.count) students from course '$CourseAlias'. The -RemoveStudents switch is not present."
            }
        }

        If ($TeachersToRemove.count){
            If ($RemoveTeachers){
                Try {
                    $MembershipUpdated = $True
                    Remove-GSCourseParticipant -CourseId $CourseAlias -Teacher $TeachersToRemove -Confirm:$Confirm -ErrorAction Stop -Verbose:$Verbose | Out-Null
                } catch {
                if ($ErrorActionPreference -eq 'Stop') {
                    $PSCmdlet.ThrowTerminatingError($_)
                } else {
                    Write-Error $_
                }
            }
            } else {
                Write-Warning "Unable to remove $($TeachersToRemove.count) teachers from course '$CourseAlias'. The -RemoveTeachers switch is not present."
            }
        }

        If ($StudentsToAdd.count){
            Try {
                $MembershipUpdated = $True
                Add-GSCourseParticipant -CourseId $CourseAlias -Student $StudentsToAdd -ErrorAction Stop -Verbose:$Verbose | Out-Null
            } catch {
                if ($ErrorActionPreference -eq 'Stop') {
                    $PSCmdlet.ThrowTerminatingError($_)
                } else {
                    Write-Error $_
                }
            }
        }

        If ($TeachersToAdd.count){
            Try {
                $MembershipUpdated = $True
                Add-GSCourseParticipant -CourseId $CourseAlias -Teacher $TeachersToAdd -ErrorAction Stop -Verbose:$Verbose | Out-Null
            } catch {
                if ($ErrorActionPreference -eq 'Stop') {
                    $PSCmdlet.ThrowTerminatingError($_)
                } else {
                    Write-Error $_
                }
            }
        }

        # Update the course properties
        $UpdateParameters = @{}
        $ArchiveParameters = @{}
        ForEach ($Parameter in @('Name', 'OwnerID', 'Section', 'Description', 'DescriptionHeading', 'Room', 'CourseState')){
            Switch ($Parameter){
                OwnerID {
                    If ($Global:GSUserCache[$OwnerID].user -ne $CourseCache[$CourseID].OwnerID){
                        $UpdateParameters["OwnerID"] = $Global:GSUserCache[$OwnerID].user
                    }
                }
                CourseState {
                    If ($PSBoundParameters[$Parameter] -cne $CourseCache[$CourseID].$Parameter){
                        If ($PSBoundParameters[$Parameter] -eq 'Archived'){
                            $ArchiveParameters[$Parameter] = $PSBoundParameters[$Parameter]
                        } else {
                            $UpdateParameters[$Parameter] = $PSBoundParameters[$Parameter]
                        }
                    }
                }
                Default {
                    If ($PSBoundParameters[$Parameter] -cne $CourseCache[$CourseID].$Parameter){
                        $UpdateParameters[$Parameter] = $PSBoundParameters[$Parameter]
                        
                    }
                }
            }
        }

        If ($ArchiveParameters.count -and ($ArchiveCourses -eq $False)){
            $ArchiveParameters = @{}
            write-warning "Unable to archive course '$CourseAlias'. The -ArchiveCourses switch is not present."
        }

        If ($UpdateParameters.count -and ($UpdateCourses -eq $False)){
            $UpdateParameters = @{}
            write-warning "Unable to update course '$CourseAlias'. The -UpdateCourses switch is not present."
        }
        
        If ($UpdateParameters.Count -or $ArchiveParameters.count){
            Try {
                Update-GSCourse -Id $CourseAlias @UpdateParameters @ArchiveParameters -ErrorAction Stop -Verbose:$Verbose | ForEach-Object {
                    $CourseCache[$_.ID].Name = $_.Name
                    $CourseCache[$_.ID].OwnerID = $Global:GSUserCache[$_.OwnerID].user
                    $CourseCache[$_.ID].ID = $_.ID
                    $CourseCache[$_.ID].Section = $_.Section
                    $CourseCache[$_.ID].Description = $_.Description
                    $CourseCache[$_.ID].DescriptionHeading = $_.DescriptionHeading
                    $CourseCache[$_.ID].Room = $_.Room
                    $CourseCache[$_.ID].CourseState = $_.CourseState
                }
            } catch {
                if ($ErrorActionPreference -eq 'Stop') {
                    $PSCmdlet.ThrowTerminatingError($_)
                } else {
                    Write-Error $_
                }
            }
        }

        #Update the cached membership
        If ($MembershipUpdated){
            Try {
                $CourseCache[$CourseID].Student = @()
                Get-GSCourseParticipant -CourseId $CourseAlias -Role Student -ErrorAction Stop -Verbose:$Verbose | Select-Object -ExpandProperty Profile | ForEach-Object {
                    $CourseCache[$CourseID].Student += $_.EmailAddress
                }
                $CourseCache[$CourseID].Teacher = @()
                Get-GSCourseParticipant -CourseId $CourseAlias -Role Teacher -ErrorAction Stop -Verbose:$Verbose | Select-Object -ExpandProperty Profile | ForEach-Object {
                    $CourseCache[$CourseID].Teacher += $_.EmailAddress
                }
            } catch {
                if ($ErrorActionPreference -eq 'Stop') {
                    $PSCmdlet.ThrowTerminatingError($_)
                } else {
                    Write-Error $_
                }
            }
        }


        
        If ($PassThru.IsPresent){
            $CourseCache[$CourseID]
        }

    }

    End {

         If ($CachePath){
            # Load the cached course information
            write-host "Writing course cache at '$CachePath'."
            Try {
                $CourseCache.Values | ForEach-Object {
                    $_.Alias = $_.Alias -join ";"
                    $_.Student = $_.Student -join ";"
                    $_.Teacher = $_.Teacher -join ";"
                    $_
                } | Export-CSV -Path $CachePath -Force -confirm:$Confirm -Verbose:$Verbose
            } catch {
                if ($ErrorActionPreference -eq 'Stop') {
                    $PSCmdlet.ThrowTerminatingError($_)
                } else {
                    Write-Error $_
                }
            }
        }

    }
}