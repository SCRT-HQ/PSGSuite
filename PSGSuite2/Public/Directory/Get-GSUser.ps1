function Get-GSUser {
    <#
    .SYNOPSIS
    Gets the specified G SUite User or a list of Users
    
    .DESCRIPTION
    Gets the specified G SUite User. Designed for parity with Get-ADUser as much as possible
    
    .PARAMETER User
    The primary email or UserID of the user who you are trying to get info for. You can exclude the '@domain.com' to insert the Domain in the config or use the special 'me' to indicate the AdminEmail in the config.

    Defaults to the AdminEmail in the config
    
    .PARAMETER Filter
    Query string for searching user fields
    
    For more information on constructing user queries, see: https://developers.google.com/admin-sdk/directory/v1/guides/search-users

    PowerShell filter syntax here is supported as "best effort". Please use Google's filter operators and syntax to ensure best results
    
    .PARAMETER SearchBase
    The organizational unit path that you would like to list users from
    
    .PARAMETER SearchScope
    The depth at which to return the list of Users

    Available choices are:
    * "Base": only return the users specified in the SearchBase
    * "Subtree": return the full list of users underneath the specified SearchBase
    * "OneLevel": return the SearchBase and the Users directly underneath it
    
    .PARAMETER ShowDeleted
    Returns deleted users
    
    .PARAMETER Projection
    What subset of fields to fetch for this user

    Acceptable values are:
    * "Basic": Do not include any custom fields for the user
    * "Custom": Include custom fields from schemas requested in customFieldMask
    * "Full": Include all fields associated with this user (default for this module)
    
    .PARAMETER CustomFieldMask
    A comma-separated list of schema names. All fields from these schemas are fetched. This should only be set when using '-Projection Custom'
    
    .PARAMETER ViewType
    Whether to fetch the administrator-only or domain-wide public view of the user. For more information, see Retrieve a user as a non-administrator

    Acceptable values are:
    * "Admin_View": Results include both administrator-only and domain-public fields for the user. (default)
    * "Domain_Public": Results only include fields for the user that are publicly visible to other users in the domain.
    
    .PARAMETER Fields
    The specific fields to fetch for this user
    
    .PARAMETER PageSize
    Page size of the result set
    
    .PARAMETER OrderBy
    Property to use for sorting results. 

    Acceptable values are:
    * "Email": Primary email of the user.
    * "FamilyName": User's family name.
    * "GivenName": User's given name.
    
    .PARAMETER SortOrder
    Whether to return results in ascending or descending order. 

    Acceptable values are:
    * "Ascending": Ascending order.
    * "Descending": Descending order.
    
    .EXAMPLE
    Get-GSUser

    Gets the user info for the AdminEmail on the config
    
    .EXAMPLE
    Get-GSUser -Filter *

    Gets the list of users
    
    .EXAMPLE
    Get-GSUser -Filter "IsAdmin -eq '$true'"

    Gets the list of SuperAdmin users
    
    .EXAMPLE
    Get-GSUser -Filter "IsEnrolledIn2Sv -eq '$false'" -SearchBase /Contractors -SearchScope Subtree

    Gets the list of users not currently enrolled in 2-Step Verification from the Contractors OrgUnit or any OrgUnits underneath it
    #>
    [cmdletbinding(DefaultParameterSetName = "Get")]
    Param
    (
        [parameter(Mandatory = $false,Position = 0,ValueFromPipelineByPropertyName = $true,ParameterSetName = "Get")]
        [Alias("PrimaryEmail","UserKey","Mail","Email")]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [Alias("Query")]
        [String[]]
        $Filter,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [Alias("OrgUnitPath")]
        [String]
        $SearchBase,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [ValidateSet("Base","OneLevel","Subtree")]
        [String]
        $SearchScope,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [Switch]
        $ShowDeleted,
        [parameter(Mandatory = $false)]
        [ValidateSet("Basic","Custom","Full")]
        [string]
        $Projection = "Full",
        [parameter(Mandatory = $false)]
        [String]
        $CustomFieldMask,
        [parameter(Mandatory = $false)]
        [ValidateSet("Admin_View","Domain_Public")]
        [String]
        $ViewType = "Admin_View",
        [parameter(Mandatory = $false)]
        [String[]]
        $Fields,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [ValidateRange(1,500)]
        [Alias("MaxResults")]
        [Int]
        $PageSize = "500",
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [ValidateSet("Email","GivenName","FamilyName")]
        [String]
        $OrderBy,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [ValidateSet("Ascending","Descending")]
        [String]
        $SortOrder
    )
    Begin {
        if ($PSCmdlet.ParameterSetName -eq 'Get') {
            $serviceParams = @{
                Scope       = 'https://www.googleapis.com/auth/admin.directory.user.readonly'
                ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
            }
            $service = New-GoogleService @serviceParams
        }
    }
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Get {
                    foreach ($U in $User) {
                        if ($U -ceq 'me') {
                            $U = $Script:PSGSuite.AdminEmail
                        }
                        elseif ($U -notlike "*@*.*") {
                            $U = "$($U)@$($Script:PSGSuite.Domain)"
                        }
                        Write-Verbose "Getting User '$U'"
                        $request = $service.Users.Get($U)
                        $request.Projection = $Projection
                        $request.ViewType = ($ViewType -replace '_','')
                        if ($CustomFieldMask) {
                            $request.CustomFieldMask = $CustomFieldMask
                        }
                        if ($Fields) {
                            $request.Fields = "$($Fields -join ",")"
                        }
                        $request.Execute() | Select-Object @{N = "User";E = {$_.PrimaryEmail}},*
                    }
                }
                List {
                    Get-GSUserListPrivate @PSBoundParameters
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}