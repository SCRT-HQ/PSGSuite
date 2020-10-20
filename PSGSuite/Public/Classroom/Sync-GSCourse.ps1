Function Sync-GSCourse {
    <#
    .SYNOPSIS
    Syncs one or more courses.
    .DESCRIPTION
    Syncs one or more courses.
    .PARAMETER Name
    Name of the course. For example, "10th Grade Biology". The name is required. It must be between 1 and 750 characters and a valid UTF-8 string.
    .EXAMPLE
    New-GSCourse -Name "The Rebublic" -OwnerId plato@athens.edu -Id the-republic-s01 -Section s01 -DescriptionHeading "The definition of justice, the order and character of the just city-state and the just man" -Room academy-01
    #>
    #[OutputType('Google.Apis.Classroom.v1.Data.Course')]
    [cmdletbinding(SupportsShouldProcess = $true,ConfirmImpact = "High")]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [ValidateLength(1,750)]
        [String]
        $Name,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [Alias('Teacher')]
        [String]
        $OwnerId,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
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
        $Student,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [String[]]
        $Teacher,
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
        $PassThru
    )
    Begin {
        
        If ($null -eq $Global:GSUserCache){
            Sync-GSUserCache
        }

        # Initialise a hashtable to store all of the cached courses and aliases
        $AliasCache = @{}
        $CourseCache = @{}

        If ($CachePath){
            # Load the cached course information
            If (Test-Path $CachePath){
                write-host "Loading cached courses from '$CachePath'"
                Try {
                    Import-CSV -Path $CachePath | ForEach-Object {
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
                        $Alias.Split(" ") | ForEach-Object {
                            $Course.Alias += $_
                            $AliasCache[$_] = $Course.ID
                        }
                        $Student.Split(" ") | ForEach-Object {
                            $Course.Student += $_
                        }
                        $Teacher.Split(" ") | ForEach-Object {
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

        If ($CourseCache.count -eq 0){
            # No courses were loaded from the course cache
            # Retrieve the courses directly from Google
            
            Write-Host "Loading courses from Google"
            Try {
                Get-GSCourse | ForEach-Object {
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
                    Get-GSCourseAlias -CourseId $_.ID | Select-Object -ExpandProperty Aliases | ForEach-Object {
                        $Course.Alias += $_.Alias
                        $AliasCache[$_.Alias] = $Course.ID
                    }

                    Get-GSCourseParticipant -CourseId $_.ID -Role Student | Select-Object -ExpandProperty Profile | ForEach-Object {
                        $Course.Student += $_.EmailAddress
                    }
                    Get-GSCourseParticipant -CourseId $_.ID -Role Teacher | Select-Object -ExpandProperty Profile | ForEach-Object {
                        $Course.Teacher += $_.EmailAddress
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

        Write-Verbose "Loaded $($CourseCache.Count) courses with $($AliasCache.count) aliases."
        
    }

    Process {
        
        Write-Host "Processing: $ID"

        # Get the course ID from the supplied alias/ID
        If ($Id -match "[0-9]+"){
            If ($CourseCache.ContainsKey($Id)){
                $CourseID = $Id
            } else {
                # The course does not exist and an alias was not specified. Course cannot be created.
                 write-warning "Unable to create course '$Id'. An alias value was not specified. Only courses with an Alias value can be created."
                # The course does not exist. No point executing the remaining logic.
                Return
            }
        } else {
            $CourseID = $AliasCache[$Id]
        }

        # Create non-existant courses
        If ($null -eq $CourseID){
            #Create the course now and add the course users further below.
            If ($CreateCourses.IsPresent){
                Try {
                    New-GSCourse -Name $Name -OwnerId $OwnerId -Id $Id -Section $Section -DescriptionHeading $DescriptionHeading -Description $Description -Room $Room -User $OwnerId | ForEach-Object {
                        $Course = New-Object PSObject -Property @{
                            Name = $_.Name
                            OwnerID = $Global:GSUserCache[$_.OwnerID].user
                            ID = $_.ID
                            Section = $_.Section
                            Description = $_.Description
                            DescriptionHeading = $_.DescriptionHeading
                            Room = $_.Room
                            CourseState = $_.CourseState
                            Alias = @($ID)
                            Student = @()
                            Teacher = @()
                        }
                        $Course.Teacher += $Course.OwnerID
                        $CourseCache[$Course.ID] = $Course
                        $AliasCache[$ID] = $Course.ID
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
                write-warning "Unable to create course '$Id'. The -createCourse switch is not present."
                # The course does not exist. No point executing the remaining logic.
                Return
            }      
        }

        # Check course users
        $StudentsToAdd = @()
        $StudentsToRemove = @()
        $TeachersToAdd = @()
        $TeachersToRemove = @()
        $RemoveParameters = @{}

        Compare-Object -ReferenceObject $Student -DifferenceObject $CourseCache[$Id].Student | ForEach-Object {
            If ($_.SideIndicator -eq "<="){
                $StudentsToAdd += $_.inputObject
            } else {
                $StudentsToRemove += $_.inputObject
            }
        }
        Compare-Object -ReferenceObject $Teacher -DifferenceObject $CourseCache[$Id].Teacher | ForEach-Object {
            If ($_.SideIndicator -eq "<="){
                $TeachersToAdd += $_.inputObject
            } else {
                $TeachersToRemove += $_.inputObject
            }
        }

        If ($StudentsToAdd.count){
            Try {
                Add-GSCourseParticipant -CourseId $CourseID -Student $StudentsToAdd | Select-Object -ExpandProperty Profile | ForEach-Object {
                    $CourseCache[$CourseID].Student += $_.EmailAddress
                }
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
                Add-GSCourseParticipant -CourseId $CourseID -Teacher $TeachersToAdd | Select-Object -ExpandProperty Profile | ForEach-Object {
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

        If ($StudentsToRemove.count){
            If ($RemoveStudents.IsPresent){
                Try {
                    Remove-GSCourseParticipant -CourseId $CourseID -Student $StudentsToAdd -WhatIf:$WhatIf -Confirm:$Confirm
                    $CourseCache[$CourseID].Student = Compare-Object -ReferenceObject $StudentsToRemove -DifferenceObject $CourseCache[$CourseID].Student -PassThru
                } catch {
                    if ($ErrorActionPreference -eq 'Stop') {
                        $PSCmdlet.ThrowTerminatingError($_)
                    } else {
                        Write-Error $_
                    }
                }
            } else {
                Write-Warning "Unable to remove $($StudentsToRemove.count) students from course '$Id'. The -RemoveStudents switch is not present."
            }
        }

        If ($TeachersToRemove.count){
            If ($RemoveTeachers.IsPresent){
                Try {
                    Remove-GSCourseParticipant -CourseId $CourseID -Teacher $TeachersToAdd -whatif:$WhatIf -Confirm:$Confirm
                    $CourseCache[$CourseID].Teacher = Compare-Object -ReferenceObject $TeachersToRemove -DifferenceObject $CourseCache[$CourseID].Teacher -PassThru
                } catch {
                if ($ErrorActionPreference -eq 'Stop') {
                    $PSCmdlet.ThrowTerminatingError($_)
                } else {
                    Write-Error $_
                }
            }
            } else {
                Write-Warning "Unable to remove $($TeachersToRemove.count) teachers from course '$Id'. The -RemoveTeachers switch is not present."
            }
        }

        
        $UpdateParameters = @{}
        ForEach ($Parameter in @('Name', 'OwnerID', 'Section', 'Description', 'DescriptionHeading', 'Room', 'CourseState')){
            If ($PSBoundParameters[$Parameter] -cne $CourseCache[$CourseID].$Parameter){
                $UpdateParameters[$Parameter] = $PSBoundParameters[$Parameter]
            }
        }

        If ($UpdateParameters.ContainsKey('CourseState')){
            If (($CourseState -eq 'Archive') -and ($ArchiveCourses.IsPresent -eq $False)){
                $UpdateParameters.Remove('CourseState')
                write-warning "Unable to archive course '$Id'. The -ArchiveCourses switch is not present."
            }
        }
        
        If ($UpdateParameters.Count){
            Try {
                Update-GSCourse -Id $CourseID @UpdateParameters | ForEach-Object {
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
                    $_.Alias = $_.Alias -join " "
                    $_.Student = $_.Student -join " "
                    $_.Teacher = $_.Teacher -join " "
                    $_
                } | Export-CSV -Path $CachePath -Force
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