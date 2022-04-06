function Update-GSGroup {
    <#
    .SYNOPSIS
    Updates the specified groups information

    .DESCRIPTION
    Updates the specified groups information

    .PARAMETER Identity
    The primary email or unique Id of the group to update

    .PARAMETER Email
    The new email id of the group. The previous email will become an alias automatically

    .PARAMETER Name
    The new name of the group

    .PARAMETER Description
    The new description of the group

    .EXAMPLE
    Update-GSGroup -Identity myGroup -Email myNewGroupName

    Updates the email address of group 'myGroup@domain.com' with the email 'myNewGroupname@domain.com'
    #>
    [OutputType('Google.Apis.Admin.Directory.directory_v1.Data.Group')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true)]
        [String]
        $Identity,
        [parameter(Mandatory = $false)]
        [String]
        $Email,
        [parameter(Mandatory = $false)]
        [String]
        $Name,
        [parameter(Mandatory = $false)]
        [String]
        $Description
    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.group'
            ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        
        try {
            Resolve-Email ([ref]$Identity) -IsGroup
            Write-Verbose "Updating group '$Identity'"
            $body = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.Group'
            foreach ($prop in $PSBoundParameters.Keys | Where-Object {$body.PSObject.Properties.Name -contains $_}) {
                switch ($prop) {
                    Email {
                        if ($PSBoundParameters[$prop] -notlike "*@*.*") {
                            $PSBoundParameters[$prop] = "$($PSBoundParameters[$prop])@$($Script:PSGSuite.Domain)"
                        }
                        $body.$prop = $PSBoundParameters[$prop]
                    }
                    Default {
                        $body.$prop = $PSBoundParameters[$prop]
                    }
                }
            }
            $request = $service.Groups.Patch($body, $Identity)
            $request.Alt = "Json"
            $request.Execute()
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
