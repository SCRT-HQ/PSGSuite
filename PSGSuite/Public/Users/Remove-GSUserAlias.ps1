function Remove-GSUserAlias {
    <#
    .SYNOPSIS
    Removes an alias from a G Suite user

    .DESCRIPTION
    Removes an alias from a G Suite user

    .PARAMETER User
    The user to remove the alias from

    .PARAMETER Alias
    The alias or list of aliases to remove from the user

    .EXAMPLE
    Remove-GSUserAlias -User john.smith@domain.com -Alias 'jsmith@domain.com','johns@domain.com'

    Removes 2 aliases from user John Smith: 'jsmith@domain.com' and 'johns@domain.com'
    #>
    [cmdletbinding(SupportsShouldProcess = $true,ConfirmImpact = "High")]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail","Email")]
        [ValidateNotNullOrEmpty()]
        [String]
        $User,
        [parameter(Mandatory = $true,Position = 1)]
        [String[]]
        $Alias
    )
    Process {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.user'
            ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        }
        $service = New-GoogleService @serviceParams
        foreach ($A in $Alias) {
            try {
                if ($User -ceq 'me') {
                    $User = $Script:PSGSuite.AdminEmail
                }
                elseif ($User -notlike "*@*.*") {
                    $User = "$($User)@$($Script:PSGSuite.Domain)"
                }
                if ($A -notlike "*@*.*") {
                    $A = "$($A)@$($Script:PSGSuite.Domain)"
                }
                if ($PSCmdlet.ShouldProcess("Removing alias '$A' from user '$User'")) {
                    Write-Verbose "Removing alias '$A' from user '$User'"
                    $request = $service.Users.Aliases.Delete($User,$A)
                    $request.Execute()
                    Write-Verbose "Alias '$A' has been successfully deleted from user '$User'"
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
}
