function Get-GSDriveFileUploadStatus {
    foreach ($task in @($script:DriveUploadTasks)) {
        [PSCustomObject]@{
            Id = $task.Id
            User = $task.User
            UploadStatus = $({$task.Upload.Status}.InvokeReturnAsIs())
            Exception = $({$task.Upload.Exception}.InvokeReturnAsIs())
            File = $task.File
            FileLocked = $(Test-FileLock -Path $task.File)
        }
    }
}