function Get-GSDriveFileUploadStatus {
    <#
    .SYNOPSIS
    Gets the current Drive file upload status

    .DESCRIPTION
    Gets the current Drive file upload status

    .PARAMETER Id
    The upload Id for the task you'd like to retrieve the status of

    .PARAMETER InProgress
    If passed, only returns upload statuses that are not 'Failed' or 'Completed'. If nothing is returned when passing this parameter, all tracked uploads have stopped

    .EXAMPLE
    Get-GSDriveFileUploadStatus -InProgress

    Gets the upload status for all tasks currently in progress
    #>
    [CmdletBinding()]
    Param
    (
        [parameter(Mandatory = $false,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [Int[]]
        $Id,
        [parameter(Mandatory = $false)]
        [Switch]
        $InProgress
    )
    Begin {
        Write-Verbose "Getting Drive File Upload status"
    }
    Process {
        if ($script:DriveUploadTasks) {
            foreach ($task in $script:DriveUploadTasks) {
                $elapsed = ((Get-Date) - $task.StartTime)
                $progress = {$task.Request.GetProgress()}.InvokeReturnAsIs()
                if (-not $task.StreamDisposed -and $progress.Status -eq 'Completed') {
                    try {
                        Write-Verbose "[$($progress.Status)] Disposing stream of Task Id [$($task.Id)] | File [$($task.File.FullName)]"
                        $task.Stream.Dispose()
                        $task.StreamDisposed = $true
                    }
                    catch {
                        Write-Error $_
                    }
                }
                $bytesSent = $progress.BytesSent
                $remaining = try {
                    New-TimeSpan -Seconds $(($elapsed.TotalSeconds / ($bytesSent / ($task.Length))) - $elapsed.TotalSeconds) -ErrorAction Stop
                }
                catch {
                    New-TimeSpan
                }
                $percentComplete = if ($bytesSent) {
                    [Math]::Round((($bytesSent / $task.Length) * 100),4)
                }
                else {
                    0
                }
                if (-not $InProgress -or $progress.Status -notin @('Failed','Completed')) {
                    if ($Id) {
                        if ($Id -contains $task.Id) {
                            [PSCustomObject]@{
                                Id              = $task.Id
                                Status          = $progress.Status
                                PercentComplete = $percentComplete
                                Remaining       = $remaining
                                StartTime       = $task.StartTime
                                Elapsed         = $elapsed
                                File            = $task.File.FullName
                                Length          = $task.Length
                                Parents         = $task.Parents
                                BytesSent       = $bytesSent
                                FileLocked      = $(Test-FileLock -Path $task.File)
                                User            = $task.User
                                Exception       = $progress.Exception
                            }
                        }
                    }
                    else {
                        [PSCustomObject]@{
                            Id              = $task.Id
                            Status          = $progress.Status
                            PercentComplete = $percentComplete
                            Remaining       = $remaining
                            StartTime       = $task.StartTime
                            Elapsed         = $elapsed
                            File            = $task.File.FullName
                            Length          = $task.Length
                            Parents         = $task.Parents
                            BytesSent       = $bytesSent
                            FileLocked      = $(Test-FileLock -Path $task.File)
                            User            = $task.User
                            Exception       = $progress.Exception
                        }
                    }
                }
            }
        }
    }
}
