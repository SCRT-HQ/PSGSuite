function Stop-GSDriveFileUpload {
    <#
    .SYNOPSIS
    Stops all Drive file uploads in progress and disposes of all streams.

    .DESCRIPTION
    Stops all Drive file uploads in progress and disposes of all streams.

    .EXAMPLE
    Stop-GSDriveFileUpload

    Stops all Drive file uploads in progress and disposes of all streams.
    #>
    [cmdletbinding()]
    Param ()
    Begin {
        Write-Verbose "Stopping all remaining Drive file uploads!"
    }
    Process {
        foreach ($task in $script:DriveUploadTasks | Where-Object {$_.Stream -and -not $_.StreamDisposed}) {
            try {
                $progress = {$task.Request.GetProgress()}.InvokeReturnAsIs()
                Write-Verbose "[$($progress.Status)] Stopping stream of Task Id [$($task.Id)] | File [$($task.File.FullName)]"
                $task.Stream.Dispose()
                $task.StreamDisposed = $true
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
