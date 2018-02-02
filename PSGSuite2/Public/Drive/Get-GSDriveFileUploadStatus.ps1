function Get-GSDriveFileUploadStatus {
    [CmdletBinding()]
    Param
    (
        [parameter(Mandatory = $false,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [Int[]]
        $Id
    )
    Process {
        if ($script:DriveUploadTasks) {
            foreach ($task in $script:DriveUploadTasks) {
                $elapsed = ((Get-Date) - $task.StartTime)
                $progress = {$task.Request.GetProgress()}.InvokeReturnAsIs()
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
                if ($Id) {
                    if ($Id -contains $task.Id) {
                        [PSCustomObject]@{
                            Id = $task.Id
                            Status = $progress.Status
                            PercentComplete = $percentComplete
                            Remaining = $remaining
                            StartTime = $task.StartTime
                            Elapsed = $elapsed
                            File = $task.File.FullName
                            Length = $task.Length
                            Parents = $task.Parents
                            BytesSent = $bytesSent
                            FileLocked = $(Test-FileLock -Path $task.File)
                            User = $task.User
                            Exception = $progress.Exception
                        }
                    }
                }
                else {
                    [PSCustomObject]@{
                        Id = $task.Id
                        Status = $progress.Status
                        PercentComplete = $percentComplete
                        Remaining = $remaining
                        StartTime = $task.StartTime
                        Elapsed = $elapsed
                        File = $task.File.FullName
                        Length = $task.Length
                        Parents = $task.Parents
                        BytesSent = $bytesSent
                        FileLocked = $(Test-FileLock -Path $task.File)
                        User = $task.User
                        Exception = $progress.Exception
                    }
                }
            }
        }
    }
}