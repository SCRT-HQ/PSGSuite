function Set-GSDocContent {
    <#
    .SYNOPSIS
    Sets the content of a Google Doc. This overwrites any existing content on the Doc

    .DESCRIPTION
    Sets the content of a Google Doc. This overwrites any existing content on the Doc

    .PARAMETER FileID
    The unique Id of the file to set content on

    .PARAMETER Value
    The content to set

    .PARAMETER User
    The email or unique Id of the owner of the Drive file

    Defaults to the AdminEmail user

    .EXAMPLE
    $logStrings | Set-GSDocContent -FileId '1rhsAYTOB_vrpvfwImPmWy0TcVa2sgmQa_9u976'

    Sets the content of the specified Google Doc to the strings in the $logStrings variable. Any existing content on the doc will be overwritten.
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
        $service = New-GoogleService @serviceParams
        $stream = New-Object 'System.IO.MemoryStream'
        $writer = New-Object 'System.IO.StreamWriter' $stream
        $concatStrings = @()
    }
    Process {
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
            $request.SupportsTeamDrives = $true
            Write-Verbose "Setting content for File '$FileID'"
            $request.Upload() | Out-Null
            $stream.Close()
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
