function Update-GSUserPhoto {
    <#
    .SYNOPSIS
    Updates the photo for the specified user

    .DESCRIPTION
    Updates the photo for the specified user

    .PARAMETER User
    The primary email or UserID of the user who you are trying to update the photo for. You can exclude the '@domain.com' to insert the Domain in the config or use the special 'me' to indicate the AdminEmail in the config.

    .PARAMETER Path
    The path of the photo that you would like to update the user with.

    .EXAMPLE
    Update-GSUserPhoto -User me -Path .\myphoto.png

    Updates the Google user photo of the AdminEmail with the image at the specified path
    #>
    [OutputType('Google.Apis.Admin.Directory.directory_v1.Data.UserPhoto')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [String]
        $User,
        [parameter(Mandatory = $true,Position = 1)]
        [ValidateScript({Test-Path $_})]
        [String]
        $Path
    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.user'
            ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        }
        $service = New-GoogleService @serviceParams
        $Path = (Resolve-Path $Path).Path
    }
    Process {
        try {
            if ($User -ceq 'me') {
                $User = $Script:PSGSuite.AdminEmail
            }
            elseif ($User -notlike "*@*.*") {
                $User = "$($User)@$($Script:PSGSuite.Domain)"
            }
            $mimeType = Get-MimeType -File $Path
            $photoData = [System.Convert]::ToBase64String(([System.IO.File]::ReadAllBytes($Path))) | Convert-Base64 -From Base64String -To WebSafeBase64String
            $body = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.UserPhoto' -Property @{
                PhotoData = $photoData
                MimeType = $mimeType
            }
            Write-Verbose "Updating the photo for User '$User' with file '$Path'"
            $request = $service.Users.Photos.Update($body,$User)
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
