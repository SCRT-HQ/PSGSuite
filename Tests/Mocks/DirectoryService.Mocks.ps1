#region: Test object collections
$global:Users = New-Object System.Collections.ArrayList
1..2 | ForEach-Object {
    [Void]$global:Users.Add((New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.User' -Property @{
        PrimaryEmail = "user$($_)@domain.com"
        OrgUnitPath = "/Users/$_"
    }))
    foreach ($sub in (1..2)) {
        [Void]$global:Users.Add((New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.User' -Property @{
            PrimaryEmail = "user$($_).$($sub)@domain.com"
            OrgUnitPath = "/Users/$_/$sub"
        }))
    }
}
1..2 | ForEach-Object {
    [Void]$global:Users.Add((New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.User' -Property @{
        PrimaryEmail = "user$($_)@domain2.com"
        OrgUnitPath = "/Users/$_"
    }))
}
[Void]$global:Users.Add((New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.User' -Property @{
    PrimaryEmail = "admin@domain.com"
    OrgUnitPath = "/Users"
}))
#endregion

#region: Requests - These should inherit from the GoogleRequest core class
class DirectoryUsersListRequest : GoogleRequest {
    [String] $Projection
    [String] $Domain
    [String] $Customer
    [String] $MaxResults
    [String] $OrderBy
    [String] $SortOrder
    [String] $CustomFieldMask
    [String] $ShowDeleted = $false
    [String] $ViewType
    [String] $Query
    [String] $PageToken

    DirectoryUsersListRequest() {

    }
    DirectoryUsersListRequest([String] $Query) : base ($Query) {

    }
    [Object[]] Execute() {
        $results = if ( -not [String]::IsNullOrEmpty($this.Query)) {
            Write-Verbose "Query: $($this.Query.Trim())"
            $filter = $this.Query.Trim()
            $i = 0
            if ($null -eq $filter.Split('=',2)[$i].Trim()) {
                $i++
            }
            $left = $filter.Split('=',2)[$i].Trim()
            $right = $filter.Split('=',2)[$i+1].Trim("'")
            $filtered = $global:Users | Where-Object {$_.$left -like "$right*"}
            return ([PSCustomObject]@{
                UsersValue = $filtered
            })
        }
        else {
            $global:Users
        }
        if ( -not [String]::IsNullOrEmpty($this.Domain)) {
            $results = $results | Where-Object {$_.PrimaryEmail -like "*$($this.domain)"}
        }
        return ([PSCustomObject]@{
            UsersValue = $results
        })
    }
}

class DirectoryUsersGetRequest : GoogleRequest {
    [String] $UserKey
    [String] $Projection
    [String] $Domain
    [String] $Customer
    [String] $MaxResults
    [String] $OrderBy
    [String] $SortOrder
    [String] $CustomFieldMask
    [String] $ShowDeleted = $false
    [String] $ViewType

    DirectoryUsersGetRequest([String] $UserKey) {
        $this.UserKey = $UserKey
    }
    [Object] Execute() {
        if ($user = $global:Users | Where-Object {$_.PrimaryEmail -eq $this.UserKey -or $_.Id -eq $this.UserKey}) {
            return $user
        }
        else {
            throw "User $($this.UserKey) not found!"
        }
    }
}

class DirectoryUsersInsertRequest : GoogleRequest {
    [Object] $Body
    [String] $Projection
    [String] $Domain
    [String] $Customer
    [String] $MaxResults
    [String] $OrderBy
    [String] $SortOrder
    [String] $CustomFieldMask
    [String] $ShowDeleted = $false
    [String] $ViewType

    DirectoryUsersInsertRequest([Object] $Body) {
        $this.Body = $Body
    }
    [Object] Execute() {
        if ($global:Users | Where-Object {$_.PrimaryEmail -eq $this.Body.PrimaryEmail}) {
            throw "User $($this.Body.PrimaryEmail) already exists!"
        }
        else {
            [Void]$global:Users.Add($this.Body)
            return ($this.Body)
        }
    }
}
#endregion

#region: Resources
class DirectoryUsersAliasesResource {
    DirectoryUsersAliasesResource() {

    }
}

class DirectoryUsersPhotosResource {
    DirectoryUsersPhotosResource() {

    }
}

class DirectoryGroupsAliasesResource {
    DirectoryGroupsAliasesResource() {

    }
}

class DirectoryUsersResource {
    [DirectoryUsersAliasesResource] $Aliases
    [DirectoryUsersPhotosResource] $Photos

    DirectoryUsersResource() {
        $this.Aliases = [DirectoryUsersAliasesResource]::new()
        $this.Photos = [DirectoryUsersPhotosResource]::new()
    }

    [DirectoryUsersListRequest] List() {
        return [DirectoryUsersListRequest]::new()
    }

    [DirectoryUsersGetRequest] Get([String] $UserKey) {
        return [DirectoryUsersGetRequest]::new($UserKey)
    }

    [DirectoryUsersInsertRequest] Insert([Object] $Body) {
        return [DirectoryUsersInsertRequest]::new($Body)
    }
}
class DirectoryGroupsResource {
    [DirectoryGroupsAliasesResource] $Aliases

    DirectoryGroupsResource() {
        $this.Aliases = [DirectoryGroupsAliasesResource]::new()
    }

}
#endregion

#region: Service - This should inherit from the GoogleService core class
class DirectoryService : GoogleService {
    [DirectoryUsersResource] $Users
    [DirectoryGroupsResource] $Groups
    [String] $ApplicationName = $null

    DirectoryService() {
        $this.Users = [DirectoryUsersResource]::new()
        $this.Groups = [DirectoryGroupsResource]::new()
        $this.ApplicationName = $null
    }
}
#endregion

#region: New-GoogleService mock
Mock 'New-GoogleService' -ModuleName PSGSuite -ParameterFilter {$ServiceType -eq 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'} -MockWith {
    Write-Verbose "Mocking New-GoogleService for ServiceType '$ServiceType' using the DirectoryService class"
    return [DirectoryService]::new()
}
#endregion
