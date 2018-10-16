Mock 'New-GoogleService' -ModuleName PSGSuite -ParameterFilter {$ServiceType -eq 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'} -MockWith {
    Write-Verbose "Mocking New-GoogleService for ServiceType '$ServiceType'"
    $o = New-Object PSObject -Property @{Users = [PSCustomObject]@{};ApplicationName = ""}
    $o.Users | Add-Member -Force -MemberType ScriptMethod -Name List -Value {
        New-Object -TypeName PSObject -Property @{
            Projection = ""
            Domain = ""
            Customer = ""
            MaxResults = ""
            OrderBy = ""
            SortOrder = ""
            CustomFieldMask = ""
            ShowDeleted = $false
            ViewType = ""
            Query = ""
            PageToken = ""
        } | Add-Member -MemberType ScriptMethod -Name Execute -Value {
            $userList = @()
            1..2 | ForEach-Object {
                $userList += New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.User' -Property @{
                    PrimaryEmail = "user$($_)@domain.com"
                    OrgUnitPath = "/Users/$_"
                }
                foreach ($sub in (1..2)) {
                    $userList += New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.User' -Property @{
                        PrimaryEmail = "user$($_).$($sub)@domain.com"
                        OrgUnitPath = "/Users/$_/$sub"
                    }
                }
            }
            if ( -not [String]::IsNullOrEmpty($this.Query)) {
                $filter = $this.Query.Trim()
                $left = $filter.Split('=',2)[1].Trim()
                $right = $filter.Split('=',2)[2].Trim("'")
                $filtered = $userList | Where-Object {$_.$left -like "$right*"}
                Write-Verbose "The query is `"$filter`" : Left [$left] : Right [$right]"
                return ([PSCustomObject]@{
                    UsersValue = $filtered
                })
            }
            else {
                return ([PSCustomObject]@{
                    UsersValue = $userList
                })
            }
        } -Force -PassThru
    }
    $o.Users | Add-Member -Force -MemberType ScriptMethod -Name Get -Value {
        Process {
            $UserKey = $args[0]
            New-Object -TypeName PSObject -Property @{
                Projection = ""
                Domain = ""
                Customer = ""
                MaxResults = ""
                OrderBy = ""
                SortOrder = ""
                CustomFieldMask = ""
                ViewType = ""
                Fields = ""
                UserKey = $UserKey
            } | Add-Member -MemberType ScriptMethod -Name Execute -Value {
                $userList = @()
                1..2 | ForEach-Object {
                    $userList += New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.User' -Property @{
                        PrimaryEmail = "user$($_)@domain.com"
                        OrgUnitPath = "/Users/$_"
                    }
                    foreach ($sub in (1..2)) {
                        $userList += New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.User' -Property @{
                            PrimaryEmail = "user$($_).$($sub)@domain.com"
                            OrgUnitPath = "/Users/$_/$sub"
                        }
                    }
                }
                if ($userFound = $userList | Where-Object {$_.PrimaryEmail -eq $this.UserKey}) {
                    return $userFound
                }
                else {
                    Write-Error "User not found!"
                }
            } -Force -PassThru
        }
    }
    return $o
}
