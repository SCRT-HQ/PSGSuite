function Remove-GSUserPhone {
    <#
    .SYNOPSIS
    Remove User Phone
    
    .DESCRIPTION
    Remove User Phone

    .PARAMETER User
    Email Address of User

    .EXAMPLE
    Remove-GSUserPhone -User <username> 

    #>
    [cmdletbinding(DefaultParameterSetName = "Update")]
    Param
    (
        [parameter(Mandatory = $true)]
        [string[]]
        $User
    )
    Begin {
     
    }
    Process {
        try {
            $header = @{
                Authorization = "Bearer $(Get-GSToken -P12KeyPath $global:PSGSuite.P12KeyPath -Scopes "https://www.googleapis.com/auth/admin.directory.user" -AppEmail $global:PSGSuite.AppEmail -AdminEmail $global:PSGSuite.AdminEmail -Verbose:$false)"
            }
            $body = '{ "phones": null }'
            $hook = "https://www.googleapis.com/admin/directory/v1/users/$User"
            Write-Verbose "Removing Phone on User: $User"
            Invoke-RestMethod -Method Put -Uri ([Uri]$hook) -Headers $header -Body $body -ContentType 'application/json' -Verbose:$false 
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
    End {

          
    }
}
