function Get-GSGmailProfile {
    <#
    .SYNOPSIS
    Gets Gmail profile for the user
    
    .DESCRIPTION
    Gets Gmail profile for the user
    
    .PARAMETER User
    The user to get profile of

    Defaults to the AdminEmail user
    
    .EXAMPLE
    Get-GSGmailProfile

    Gets the Gmail profile of the AdminEmail user
    #>
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $User = $Script:PSGSuite.AdminEmail
    )
    Process {
        foreach ($U in $User) {
            try {
                if ($U -ceq 'me') {
                    $U = $Script:PSGSuite.AdminEmail
                }
                elseif ($U -notlike "*@*.*") {
                    $U = "$($U)@$($Script:PSGSuite.Domain)"
                }
                $serviceParams = @{
                    Scope       = 'https://mail.google.com'
                    ServiceType = 'Google.Apis.Gmail.v1.GmailService'
                    User        = $U
                }
                $service = New-GoogleService @serviceParams
                $request = $service.Users.GetProfile($U)
                Write-Verbose "Getting Gmail profile for user '$U'"
                $request.Execute() | Add-Member -MemberType NoteProperty -Name 'User' -Value $U -PassThru
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
}