function Get-GSDriveProfile {
    <#
    .SYNOPSIS
    Gets Drive profile for the user
    
    .DESCRIPTION
    Gets Drive profile for the user
    
    .PARAMETER User
    The user to get profile of

    Defaults to the AdminEmail user
    
    .EXAMPLE
    Get-GSDriveProfile

    Gets the Drive profile of the AdminEmail user
    #>
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [Alias('Owner','PrimaryEmail','UserKey','Mail')]
        [string]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false,Position = 1)]
        [ValidateSet('AppInstalled','ExportFormats','FolderColorPalette','ImportFormats','Kind','MaxImportSizes','MaxUploadSize','StorageQuota','TeamDriveThemes','User')]
        [string[]]
        $Fields = @('AppInstalled','ExportFormats','FolderColorPalette','ImportFormats','Kind','MaxImportSizes','MaxUploadSize','StorageQuota','TeamDriveThemes','User')
    )
    Begin {
        $fieldDict = @{
            AppInstalled = 'appInstalled'
            ExportFormats = 'exportFormats'
            FolderColorPalette = 'folderColorPalette'
            ImportFormats = 'importFormats'
            Kind = 'kind'
            MaxImportSizes = 'maxImportSizes'
            MaxUploadSize = 'maxUploadSize'
            StorageQuota = 'storageQuota'
            TeamDriveThemes = 'teamDriveThemes'
            User = 'user'
        }
    }
    Process {
        foreach ($U in $User) {
            if ($U -ceq 'me') {
                $U = $Script:PSGSuite.AdminEmail
            }
            elseif ($U -notlike "*@*.*") {
                $U = "$($U)@$($Script:PSGSuite.Domain)"
            }
            $serviceParams = @{
                Scope       = 'https://www.googleapis.com/auth/drive'
                ServiceType = 'Google.Apis.Drive.v3.DriveService'
                User        = $U
            }
            $service = New-GoogleService @serviceParams
            try {
                $request = $service.About.Get()
                $request.Fields = "$(($Fields | ForEach-Object {$fieldDict[$_]}) -join ",")"
                Write-Verbose "Getting Drive profile for user '$U'"
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
}