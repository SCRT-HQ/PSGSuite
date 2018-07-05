function Get-GSDocContent {
    <#
    .SYNOPSIS
    Gets the content of a Google Doc and returns it as an array of strings. Supports HTML or PlainText
    
    .DESCRIPTION
    Gets the content of a Google Doc and returns it as an array of strings. Supports HTML or PlainText
    
    .PARAMETER FileID
    The unique Id of the file to get content of
    
    .PARAMETER User
    The email or unique Id of the owner of the Drive file

    Defaults to the AdminEmail user
    
    .EXAMPLE
    Get-GSDocContent -FileId '1rhsAYTOB_vrpvfwImPmWy0TcVa2sgmQa_9u976'

    Exports the Drive file as a CSV to the current working directory
    #>
    [CmdLetBinding()]
    Param
    (      
        [parameter(Mandatory = $true,Position = 0)]
        [String]
        $FileID,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [Alias('Owner','PrimaryEmail','UserKey','Mail')]
        [string]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false)]
        [ValidateSet("HTML","PlainText")]
        [String]
        $Type
    )
    Begin {
        $typeParam = @{}
        if ($PSBoundParameters.Keys -notcontains 'Type') {
            $typeParam['Type'] = "PlainText"
        }
    }
    Process {
        try {
            (Export-GSDriveFile @PSBoundParameters -Projection Minimal @typeParam) -split "`n"
            Write-Verbose "Content retrieved for File '$FileID'"
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