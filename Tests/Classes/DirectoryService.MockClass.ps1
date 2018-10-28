<#
Import-Module PSGSuite

$STypes = @(
    'Google.Apis.Admin.DataTransfer.datatransfer_v1.DataTransferService'
    'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
    'Google.Apis.Admin.Reports.reports_v1.ReportsService'
    'Google.Apis.Calendar.v3.CalendarService'
    'Google.Apis.Classroom.v1.ClassroomService'
    'Google.Apis.Drive.v3.DriveService'
    'Google.Apis.Gmail.v1.GmailService'
    'Google.Apis.Groupssettings.v1.GroupssettingsService'
    'Google.Apis.HangoutsChat.v1.HangoutsChatService'
    'Google.Apis.Licensing.v1.LicensingService'
    'Google.Apis.Sheets.v4.SheetsService'
    'Google.Apis.Tasks.v1.TasksService'
    'Google.Apis.Urlshortener.v1.UrlshortenerService'
)
$STypes | ForEach-Object {
    $shortName = $_.Split('.')[-1]
    New-Variable -Name $shortName -Value (New-Object $_) -Force
}
#>

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
[Void]$global:Users.Add((New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.User' -Property @{
    PrimaryEmail = "admin@domain.com"
    OrgUnitPath = "/Users"
}))

#region: Requests
class GoogleRequest {
    [String] $Customer
    [String] $CustomFieldMask
    [String] $Domain
    [String] $Fields
    [String] $Key
    [Int] $MaxResults
    [String] $OauthToken
    [String] $PageToken
    [Bool] $PrettyPrint
    [String] $Query
    [String] $QuotaUser
    [String] $ShowDeleted

    GoogleRequest() {

    }

    [Object[]] Execute() {
        throw "Must Override Method"
    }
    [Object[]] ExecuteAsStream() {
        throw "Must Override Method"
    }
    [Object[]] ExecuteAsStreamAsync() {
        throw "Must Override Method"
    }
    [Object[]] ExecuteAsync() {
        throw "Must Override Method"
    }
}

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
        if ( -not [String]::IsNullOrEmpty($this.Query)) {
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
            return ([PSCustomObject]@{
                UsersValue = $global:Users
            })
        }
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
            throw "User not found!"
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
}
class DirectoryGroupsResource {
    [DirectoryGroupsAliasesResource] $Aliases

    DirectoryGroupsResource() {
        $this.Aliases = [DirectoryGroupsAliasesResource]::new()
    }

}
#endregion

#region: Services
class GoogleService {
    [String] $APIKey
    [String] $ApplicationName
    [String] $BasePath
    [String] $BaseUri
    [String] $BatchPath
    [String] $BatchUri
    [System.Collections.Generic.List[String]] $Features
    [Bool] $GZipEnabled
    [String] $Name

    GoogleService() {

    }
}

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
