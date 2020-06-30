function Add-GSDocContent {
    <#
    .SYNOPSIS
    Adds content to a Google Doc via appending new text. This does not overwrite existing content

    .DESCRIPTION
    Adds content to a Google Doc via appending new text. This does not overwrite existing content

    .PARAMETER FileID
    The unique Id of the file to add content to

    .PARAMETER Value
    The content to add

    .PARAMETER User
    The email or unique Id of the owner of the Drive file

    Defaults to the AdminEmail user

    .EXAMPLE
    $newLogStrings | Add-GSDocContent -FileId '1rhsAYTOB_vrpvfwImPmWy0TcVa2sgmQa_9u976'

    Appends the strings in the $newLogStrings variable to the existing the content of the specified Google Doc.
    #>
    [CmdLetBinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0)]
        [String]
        $FileID,
        [parameter(Mandatory = $true,ValueFromPipeline = $true)]
        [String[]]
        $Value,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [Alias('Owner','PrimaryEmail','UserKey','Mail')]
        [string]
        $User = $Script:PSGSuite.AdminEmail
    )
    Begin {
        $currentContent = Get-GSDocContent -FileID $FileID -User $User -Verbose:$false
    }
    Process {
        $stream = New-Object 'System.IO.MemoryStream'
        $writer = New-Object 'System.IO.StreamWriter' $stream
        $concatStrings = @($currentContent)
        if ($User -ceq 'me') {
            $User = $Script:PSGSuite.AdminEmail
        }
        elseif ($User -notlike "*@*.*") {
            $User = "$($User)@$($Script:PSGSuite.Domain)"
        }
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/drive'
            ServiceType = 'Google.Apis.Drive.v3.DriveService'
            User        = $User
        }
        $service = New-GoogleService @serviceParams
        foreach ($string in $Value) {
            $concatStrings += $string
        }
    }
    End {
        try {
            $concatStrings = $concatStrings -join "`n"
            $writer.Write($concatStrings)
            $writer.Flush()
            $contentType = 'text/plain'
            $body = New-Object 'Google.Apis.Drive.v3.Data.File'
            $request = $service.Files.Update($body,$FileId,$stream,$contentType)
            $request.QuotaUser = $User
            $request.ChunkSize = 512KB
            $request.SupportsAllDrives = $true
            Write-Verbose "Adding content to File '$FileID'"
            $request.Upload() | Out-Null
        }
        catch {
            if ($ErrorActionPreference -eq 'Stop') {
                $PSCmdlet.ThrowTerminatingError($_)
            }
            else {
                Write-Error $_
            }
        }
        finally {
            if ($stream) {
                $stream.Close()
            }
        }
    }
}
