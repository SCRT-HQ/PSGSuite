function Get-GSDriveFolderSize {
    <#
    .SYNOPSIS
    Gets the size of the files with the specified ParentFolderId in Drive.

    .DESCRIPTION
    Gets the size of the files with the specified ParentFolderId in Drive.

    .PARAMETER ParentFolderId
    ID of parent folder to search to add to the filter

    .PARAMETER Recurse
    If True, recurses through subfolders found underneath primary search results

    .PARAMETER Depth
    Internal use only. Used to track how deep in the subfolder structure the command is currently searching when used with -Verbose

    .EXAMPLE
    Get-GSDriveFolderSize -ParentFolderId $id1,$id2 -Recurse
    #>

    [CmdletBinding()]
    Param (
        [parameter(Mandatory,Position = 0,ValueFromPipelineByPropertyName)]
        [Alias('Id')]
        [String[]]
        $ParentFolderId,
        [parameter()]
        [Switch]
        $Recurse,
        [parameter()]
        [Int]
        $Depth = 0
    )
    Begin {
        $final = @{
            TotalSize = 0
        }
    }
    Process {
        foreach ($id in $ParentFolderId) {
            $files = Get-GSDriveFileList -ParentFolderId $id -IncludeTeamDriveItems -Fields "files(name, id, size, mimeType)" -Verbose:$false
            $folderTotal = ($files.Size | Measure-Object -Sum).Sum
            if ($folderTotal){
                Write-Verbose ("Total file size in bytes in folder ID '$id': {0}" -f $folderTotal)
                $final.TotalSize +=  $folderTotal
            }
            if ($Recurse -and ($subfolders = $files | Where-Object {$_.MimeType -eq 'application/vnd.google-apps.folder'})) {
                $newDepth = $Depth + 1
                Write-Verbose "[Depth: $Depth > $newDepth] Recursively searching subfolder Ids: [ $($subfolders.Id -join ", ") ]"
                $subFolderTotal = Get-GSDriveFolderSize -ParentFolderId $subfolders.Id -Recurse -Depth $newDepth
                if ($subFolderTotal) {
                    $final.TotalSize += $subFolderTotal.TotalSize
                }
            }
        }
    }
    End {
        $final['TotalSizeInMB'] = $final['TotalSize'] / 1MB
        $final['TotalSizeInGB'] = $final['TotalSize'] / 1GB
        [PSCustomObject]$final
    }
}
