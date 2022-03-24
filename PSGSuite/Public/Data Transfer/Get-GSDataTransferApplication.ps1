function Get-GSDataTransferApplication {
    <#
    .SYNOPSIS
    Gets the list of available Data Transfer Applications and their parameters

    .DESCRIPTION
    Gets the list of available Data Transfer Applications and their parameters

    .PARAMETER ApplicationId
    The Application Id of the Data Transfer Application you would like to return info for specifically. Exclude to return the full list

    .PARAMETER PageSize
    PageSize of the result set.

    Defaults to 500 (although it's typically a much smaller number for most Customers)

    .PARAMETER Limit
    The maximum amount of results you want returned. Exclude or set to 0 to return all results

    .EXAMPLE
    Get-GSDataTransferApplication

    Gets the list of available Data Transfer Applications
    #>
    [OutputType('Google.Apis.Admin.DataTransfer.datatransfer_v1.Data.Application')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false,Position = 0)]
        [String[]]
        $ApplicationId,
        [parameter(Mandatory = $false)]
        [ValidateRange(1,500)]
        [Int]
        $PageSize = 500,
        [parameter(Mandatory = $false)]
        [Alias('First')]
        [Int]
        $Limit = 0
    )
    Process {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.datatransfer'
            ServiceType = 'Google.Apis.Admin.DataTransfer.datatransfer_v1.DataTransferService'
        }
        $service = New-GoogleService @serviceParams
        try {
            if ($ApplicationId) {
                foreach ($I in $ApplicationId) {
                    $request = $service.Applications.Get($I)
                    $request.Execute()
                }
            }
            else {
                $request = $service.Applications.List()
                $request.CustomerId = $Script:PSGSuite.CustomerID
                if ($Limit -gt 0 -and $PageSize -gt $Limit) {
                    Write-Verbose ("Reducing PageSize from {0} to {1} to meet limit with first page" -f $PageSize,$Limit)
                    $PageSize = $Limit
                }
                $request.MaxResults = $PageSize
                Write-Verbose "Getting all Data Transfer Applications"
                $response = @()
                [int]$i = 1
                $overLimit = $false
                do {
                    $result = $request.Execute()
                    $response += $result.Applications
                    if ($result.NextPageToken) {
                        $request.PageToken = $result.NextPageToken
                    }
                    [int]$retrieved = ($i + $result.Applications.Count) - 1
                    Write-Verbose "Retrieved $retrieved Data Transfer Applications..."
                    if ($Limit -gt 0 -and $retrieved -eq $Limit) {
                        Write-Verbose "Limit reached: $Limit"
                        $overLimit = $true
                    }
                    elseif ($Limit -gt 0 -and ($retrieved + $PageSize) -gt $Limit) {
                        $newPS = $Limit - $retrieved
                        Write-Verbose ("Reducing PageSize from {0} to {1} to meet limit with next page" -f $PageSize,$newPS)
                        $request.MaxResults = $newPS
                    }
                    [int]$i = $i + $result.Applications.Count
                }
                until ($overLimit -or !$result.NextPageToken)
                return $response
            }
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
