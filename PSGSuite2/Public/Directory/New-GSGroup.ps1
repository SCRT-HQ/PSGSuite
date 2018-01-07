function New-GSGroup {
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
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}