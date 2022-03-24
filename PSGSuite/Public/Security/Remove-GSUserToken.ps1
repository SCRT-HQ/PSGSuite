function Remove-GSUserToken {
    <#
    .SYNOPSIS
    Removes a security token from a user

    .DESCRIPTION
    Removes a security token from a user

    .PARAMETER User
    The user to remove the security token from

    .PARAMETER ClientID
    The client Id of the security token. If excluded, all security tokens for the user are removed

    .EXAMPLE
    An example

    .NOTES
    General notes
    #>
    [cmdletbinding(SupportsShouldProcess = $true,ConfirmImpact = "High")]
    Param
    (
        [parameter(Mandatory = $false,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $User,
        [parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true)]
        [String[]]
        $ClientID
    )
    Process {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.user.security'
            ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        }
        $service = New-GoogleService @serviceParams
        try {
            foreach ($U in $User) {
                if ($U -ceq 'me') {
                    $U = $Script:PSGSuite.AdminEmail
                }
                elseif ($U -notlike "*@*.*") {
                    $U = "$($U)@$($Script:PSGSuite.Domain)"
                }
                if ($PSBoundParameters.Keys -contains 'ClientID') {
                    foreach ($C in $ClientID) {
                        if ($PSCmdlet.ShouldProcess("Deleting Token ClientID '$C' for user '$U'")) {
                            Write-Verbose "Deleting Token ClientID '$C' for user '$U'"
                            $request = $service.Tokens.Delete($U,$C)
                            $request.Execute()
                            Write-Verbose "Token ClientID '$C' has been successfully deleted for user '$U'"
                        }
                    }
                }
                else {
                    if ($PSCmdlet.ShouldProcess("Deleting ALL tokens for user '$U'")) {
                        Write-Verbose "Deleting ALL tokens for user '$U'"
                        Get-GSUserToken -User $U -Verbose:$false | ForEach-Object {
                            $request = $service.Tokens.Delete($U,$_.ClientID)
                            $request.Execute()
                            Write-Verbose "Token ClientID '$($_.ClientID)' has been successfully deleted for user '$U'"
                        }
                    }
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
