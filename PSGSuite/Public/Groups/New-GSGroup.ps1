function New-GSGroup {
    <#
    .SYNOPSIS
    Creates a new Google Group
    
    .DESCRIPTION
    Creates a new Google Group
    
    .PARAMETER Email
    The desired email of the new group. If the group already exists, a GoogleApiException will be thrown. You can exclude the '@domain.com' to insert the Domain in the config
    
    .PARAMETER Name
    The name of the new group
    
    .PARAMETER Description
    The description of the new group
    
    .EXAMPLE
    New-GSGroup -Email appdev -Name "Application Developers" -Description "App Dev team members"

    Creates a new group named "Application Developers" with the email "appdev@domain.com" and description "App Dev team members"
    #>
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true)]
        [String]
        $Email,
        [parameter(Mandatory = $true)]
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
            if ($Email -notlike "*@*.*") {
                $Email = "$($Email)@$($Script:PSGSuite.Domain)"
            }
            Write-Verbose "Creating group '$Email'"
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
            $request = $service.Groups.Insert($body)
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