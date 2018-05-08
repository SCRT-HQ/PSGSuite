function Get-GSUserASP {
    <#
    .SYNOPSIS
    Gets Application Specific Passwords for a user
    
    .DESCRIPTION
    Gets Application Specific Passwords for a user
    
    .PARAMETER User
    The primary email or UserID of the user who you are trying to get info for. You can exclude the '@domain.com' to insert the Domain in the config or use the special 'me' to indicate the AdminEmail in the config.

    Defaults to the AdminEmail in the config
    
    .PARAMETER CodeId
    The ID of the ASP you would like info for. If excluded, returns the full list of ASP's for the user
    
    .EXAMPLE
    Get-GSUserASP

    Gets the list of Application Specific Passwords for the user
    #>
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false,Position = 1,ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $CodeId
    )
    Begin {
        if ($PSBoundParameters.Keys -contains 'CodeId') {
            $serviceParams = @{
                Scope       = 'https://www.googleapis.com/auth/admin.directory.user.security'
                ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
            }
            $service = New-GoogleService @serviceParams
        }
    }
    Process {
        try {
            foreach ($U in $User) {
                if ($U -ceq 'me') {
                    $U = $Script:PSGSuite.AdminEmail
                }
                elseif ($U -notlike "*@*.*") {
                    $U = "$($U)@$($Script:PSGSuite.Domain)"
                }
                if ($PSBoundParameters.Keys -contains 'CodeId') {
                    Write-Verbose "Getting ASP '$CodeId' for User '$U'"
                    $request = $service.Asps.Get($U,$CodeId)
                    $request.Execute() | Add-Member -MemberType NoteProperty -Name 'User' -Value $U -PassThru
                }
                else {
                    $PSBoundParameters['User'] = $U
                    Get-GSUserASPListPrivate @PSBoundParameters
                }
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