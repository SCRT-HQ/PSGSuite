function Watch-GSDriveUpload {
    <#
    .SYNOPSIS
    Shows progress in the console of current Drive file uploads
    
    .DESCRIPTION
    Shows progress in the console of current Drive file uploads
    
    .PARAMETER Id
    The upload Id(s) that you would like to watch
    
    .PARAMETER Action
    Whether the action is uploading or retrying. This is mainly for use in Start-GSDriveFileUpload and defaults to 'Uploading'
    
    .PARAMETER CountUploaded
    Current file count being uploaded
    
    .PARAMETER TotalUploading
    Total file count being uploaded
    
    .EXAMPLE
    Watch-GSDriveUpload

    Watches the files currently being uploaded from the active session
    #>
    [CmdletBinding()]
    Param
    (
        [parameter(Mandatory = $false,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [Int[]]
        $Id,
        [parameter(Mandatory = $false)]
        [ValidateSet('Uploading','Retrying')]
        [String]
        $Action = "Uploading",
        [parameter(Mandatory = $false)]
        [Int]
        $CountUploaded,
        [parameter(Mandatory = $false)]
        [Int]
        $TotalUploading
    )
    Begin {
        Write-Verbose "Watching Drive File Upload"
    }
    Process {
        do {
            $i = 1
            if ($PSBoundParameters.Keys -contains 'Id') {
                $statusList = Get-GSDriveFileUploadStatus -Verbose:$false
            }
            else {
                $statusList = Get-GSDriveFileUploadStatus -Id @($Id) -Verbose:$false
            }
            if ($statusList) {
                $totalPercent = 0
                $totalSecondsRemaining = 0
                $count = 0
                $statusList | ForEach-Object {
                    $count++
                    $totalPercent += $_.PercentComplete
                    $totalSecondsRemaining += $_.Remaining.TotalSeconds
                }
                $curCount = if ($PSBoundParameters.Keys -contains 'CountUploaded') {
                    $CountUploaded
                }
                else {
                    $count
                }
                $totalCount = if ($PSBoundParameters.Keys -contains 'TotalUploading') {
                    $TotalUploading
                }
                else {
                    $count
                }
                $totalPercent = $totalPercent / $totalCount
                $totalSecondsRemaining = $totalSecondsRemaining / $totalCount
                $parentParams = @{
                    Activity = "[$([Math]::Round($totalPercent,4))%] $Action [$curCount / $totalCount] files to Google Drive"
                    SecondsRemaining = $($statusList.Remaining.TotalSeconds | Sort-Object | Select-Object -Last 1)
                }
                if (!($statusList | Where-Object {$_.Status -ne "Completed"})) {
                    $parentParams['Completed'] = $true
                }
                else {
                    $parentParams['PercentComplete'] = [Math]::Round($totalPercent,4)
                }
                if ($psEditor -or $IsMacOS -or $IsLinux) {
                    Write-InlineProgress @parentParams
                }
                else {
                    $parentParams['Id'] = 1
                    Write-Progress @parentParams
                }
                if (!$psEditor -and !$IsMacOS -and !$IsLinux -and ($statusList.Count -le 5)) {
                    foreach ($status in $statusList) {
                        $i++
                        $statusFmt = if ($status.Status -eq "Completed") {
                            "Completed uploading"
                        }
                        else {
                            $status.Status
                        }
                        $progParams = @{
                            Activity = "[$($status.PercentComplete)%] [ID: $($status.Id)] $($statusFmt) file '$($status.File)' to Google Drive$(if($status.Parents){" (Parents: '$($status.Parents -join "', '")')"})"
                            SecondsRemaining = $status.Remaining.TotalSeconds
                            Id = $i
                            ParentId = 1
                        }
                        if ($_.Status -eq "Completed") {
                            $progParams['Completed'] = $true
                        }
                        else {
                            $progParams['PercentComplete'] = [Math]::Round($status.PercentComplete,4)
                        }
                        Write-Progress @progParams
                    }
                }
                Start-Sleep -Seconds 1
            }
        }
        until (!$statusList -or !($statusList | Where-Object {$_.Status -notin @("Failed","Completed")}))
    }
}