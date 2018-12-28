function Get-GSUserPhoto {
    <#
    .SYNOPSIS
    Gets the photo data for the specified user

    .DESCRIPTION
    Gets the photo data for the specified user

    .PARAMETER User
    The primary email or UserID of the user who you are trying to get info for. You can exclude the '@domain.com' to insert the Domain in the config or use the special 'me' to indicate the AdminEmail in the config.

    Defaults to the AdminEmail in the config

    .PARAMETER OutFilePath
    The directory path that you would like to save the photos to. If excluded, this will return the photo information

    .PARAMETER OutFileFormat
    The format that you would like to save the photo as.

    Available values are:
    * "PNG": saves the photo in .png format
    * "JPG": saves the photo in .jpg format
    * "Base64": saves the photo as a .txt file containing standard (non-WebSafe) Base64 content.

    Defaults to PNG

    .EXAMPLE
    Get-GSUserPhoto -OutFilePath .

    Saves the Google user photo of the AdminEmail in the current working directory as a .png image
    #>
    [OutputType('Google.Apis.Admin.Directory.directory_v1.Data.UserPhoto')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true,ParameterSetName = "Get")]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false)]
        [ValidateScript({(Get-Item $_).PSIsContainer})]
        [String]
        $OutFilePath,
        [parameter(Mandatory = $false)]
        [ValidateSet('Base64','PNG','JPG')]
        [String]
        $OutFileFormat = 'PNG'
    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.user.readonly'
            ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        try {
            foreach ($U in $User) {
                if ($U -ceq 'me') {
                    $U = $Script:PSGSuite.AdminEmail
                }
                elseif ($U -notlike "*@*.*") {
                    $U = "$($U)@$($Script:PSGSuite.Domain)"
                }
                Write-Verbose "Getting photo for User '$U'"
                $request = $service.Users.Photos.Get($U)
                $res = $request.Execute()
                $base64 = $res.PhotoData | Convert-Base64 -From WebSafeBase64String -To Base64String
                $bytes = [Convert]::FromBase64String($base64)
                if ($OutFilePath) {
                    $fileBaseName = "$($U -replace '@.*','')"
                    switch ($OutFileFormat) {
                        JPG {
                            $filePath = Join-Path $OutFilePath "$($fileBaseName).jpg"
                            Write-Verbose "Saving photo at '$filePath'"
                            [System.IO.File]::WriteAllBytes($filePath, $bytes)
                        }
                        PNG {
                            $filePath = Join-Path $OutFilePath "$($fileBaseName).png"
                            Write-Verbose "Saving photo at '$filePath'"
                            [System.IO.File]::WriteAllBytes($filePath, $bytes)
                        }
                        Base64 {
                            $filePath = Join-Path $OutFilePath "$($fileBaseName).txt"
                            Write-Verbose "Saving Base64 photo content at '$filePath'"
                            [System.IO.File]::WriteAllText($filePath,$base64)
                        }
                    }
                }
                else {
                    $res | Add-Member -MemberType NoteProperty -Name 'User' -Value $U -PassThru | Add-Member -MemberType NoteProperty -Name 'PhotoBytes' -Value $bytes -PassThru | Add-Member -MemberType NoteProperty -Name 'PhotoBase64' -Value $base64 -PassThru
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
