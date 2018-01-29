function Get-GSDriveFileUploadStatus {
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
                $remaining = try {
                    New-TimeSpan -Seconds $(($elapsed.TotalSeconds / (({$task.Request.GetProgress().BytesSent}.InvokeReturnAsIs()) / ($task.Length))) - $elapsed.TotalSeconds) -ErrorAction Stop
                }
                catch {
                    New-TimeSpan
                }
                if ($Id) {
                    if ($Id -contains $task.Id) {
                        [PSCustomObject]@{
                            Id = $task.Id
                            Status = $({$task.Request.GetProgress().Status}.InvokeReturnAsIs())
                            PercentComplete = $([Math]::Round(((({$task.Request.GetProgress().BytesSent}.InvokeReturnAsIs()) / $task.Length) * 100),4))
                            Remaining = $remaining
                            StartTime = $task.StartTime
                            Elapsed = $elapsed
                            File = $task.File
                            Length = $task.Length
                            BytesSent = $({$task.Request.GetProgress().BytesSent}.InvokeReturnAsIs())
                            FileLocked = $(Test-FileLock -Path $task.File)
                            User = $task.User
                            Exception = $({$task.Upload.Exception}.InvokeReturnAsIs())
                        }
                    }
                }
                else {
                    [PSCustomObject]@{
                        Id = $task.Id
                        Status = $({$task.Request.GetProgress().Status}.InvokeReturnAsIs())
                        PercentComplete = $([Math]::Round(((({$task.Request.GetProgress().BytesSent}.InvokeReturnAsIs()) / $task.Length) * 100),4))
                        Remaining = $remaining
                        StartTime = $task.StartTime
                        Elapsed = $elapsed
                        File = $task.File
                        Length = $task.Length
                        BytesSent = $({$task.Request.GetProgress().BytesSent}.InvokeReturnAsIs())
                        FileLocked = $(Test-FileLock -Path $task.File)
                        User = $task.User
                        Exception = $({$task.Upload.Exception}.InvokeReturnAsIs())
                    }
                }
            }
        }
    }
}