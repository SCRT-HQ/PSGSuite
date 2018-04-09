function Remove-GSGroupAlias {
    <#
    .SYNOPSIS
    Removes an alias from a G Suite group
    
    .DESCRIPTION
    Removes an alias from a G Suite group
    
    .PARAMETER Group
    The group to remove the alias from
    
    .PARAMETER Alias
    The alias or list of aliases to remove from the group
    
    .EXAMPLE
    Remove-GSGroupAlias -Group humanresources@domain.com -Alias 'hr@domain.com','hrhelp@domain.com'

    Removes 2 aliases for group Human Resources: 'hr@domain.com' and 'hrhelp@domain.com'
    #>
    [cmdletbinding(SupportsShouldProcess = $true,ConfirmImpact = "High")]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [Alias("Email")]
        [ValidateNotNullOrEmpty()]
        [String]
        $Group,
        [parameter(Mandatory = $true,Position = 1)]
        [String[]]
        $Alias
    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.group'
            ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        foreach ($A in $Alias) {
            try {
                if ($Group -notlike "*@*.*") {
                    $Group = "$($Group)@$($Script:PSGSuite.Domain)"
                }
                if ($A -notlike "*@*.*") {
                    $A = "$($A)@$($Script:PSGSuite.Domain)"
                }
                if ($PSCmdlet.ShouldProcess("Removing alias '$A' from Group '$Group'")) {
                    Write-Verbose "Removing alias '$A' from Group '$Group'"
                    $request = $service.Groups.Aliases.Delete($Group,$A)
                    $request.Execute()
                    Write-Verbose "Alias '$A' has been successfully deleted from Group '$Group'"
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