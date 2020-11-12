<#
 TODO

 -support changing student to teacher and vice versa.
 -Support chaning owner
#>

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
                        $_.Alias.Split(";") | ForEach-Object {
                            $Course.Alias += $_
                            $AliasCache[$_] = $Course.ID
                        }
                        $_.Student.Split(";") | ForEach-Object {
                            $Course.Student += $_
                        }
                        $_.Teacher.Split(";") | ForEach-Object {
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

        # Try and get the course direct from 
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
        $RemoveParameters = @{}

        Compare-Object -ReferenceObject $Student -DifferenceObject $CourseCache[$CourseId].Student | ForEach-Object {
            If ($_.SideIndicator -eq "<="){
                $StudentsToAdd += $_.inputObject
            } else {
                $StudentsToRemove += $_.inputObject
            }
        }
        Compare-Object -ReferenceObject $Teacher -DifferenceObject $CourseCache[$CourseId].Teacher | ForEach-Object {
            If ($_.SideIndicator -eq "<="){
                $TeachersToAdd += $_.inputObject
            } else {
                $TeachersToRemove += $_.inputObject
            }
        }

        If ($StudentsToAdd.count){
            Try {
                Add-GSCourseParticipant -CourseId $CourseAlias -Student $StudentsToAdd -ErrorAction Stop -Verbose:$Verbose | Select-Object -ExpandProperty Profile | ForEach-Object {
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
                Add-GSCourseParticipant -CourseId $CourseAlias -Teacher $TeachersToAdd -ErrorAction Stop -Verbose:$Verbose | Select-Object -ExpandProperty Profile | ForEach-Object {
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
            If ($RemoveStudents){
                Try {
                    Remove-GSCourseParticipant -CourseId $CourseAlias -Student $StudentsToAdd -Confirm:$Confirm -ErrorAction Stop -Verbose:$Verbose
                    $CourseCache[$CourseID].Student = Compare-Object -ReferenceObject $StudentsToRemove -DifferenceObject $CourseCache[$CourseID].Student -PassThru
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
                    Remove-GSCourseParticipant -CourseId $CourseAlias -Teacher $TeachersToAdd -Confirm:$Confirm -ErrorAction Stop -Verbose:$Verbose
                    $CourseCache[$CourseID].Teacher = Compare-Object -ReferenceObject $TeachersToRemove -DifferenceObject $CourseCache[$CourseID].Teacher -PassThru
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

        
        $UpdateParameters = @{}
        ForEach ($Parameter in @('Name', 'OwnerID', 'Section', 'Description', 'DescriptionHeading', 'Room', 'CourseState')){
            If ($PSBoundParameters[$Parameter] -cne $CourseCache[$CourseID].$Parameter){
                $UpdateParameters[$Parameter] = $PSBoundParameters[$Parameter]
            }
        }

        If ($UpdateParameters.ContainsKey('CourseState')){
            If (($CourseState -eq 'Archive') -and ($ArchiveCourses -eq $False)){
                $UpdateParameters.Remove('CourseState')
                write-warning "Unable to archive course '$CourseAlias'. The -ArchiveCourses switch is not present."
            }
        }
        
        If ($UpdateParameters.Count){
            Try {
                Update-GSCourse -Id $CourseAlias @UpdateParameters -ErrorAction Stop -Verbose:$Verbose | ForEach-Object {
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
                    $_.Alias = $_.Alias -join ";"
                    $_.Student = $_.Student -join ";"
                    $_.Teacher = $_.Teacher -join ";"
                    $_
                } | Export-CSV -Path $CachePath -Force -Verbose:$Verbose
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