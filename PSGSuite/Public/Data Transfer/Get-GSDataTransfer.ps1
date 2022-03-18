function Get-GSDataTransfer {
    <#
    .SYNOPSIS
    Gets the list of Data Transfers

    .DESCRIPTION
    Gets the list of Data Transfers

    .PARAMETER DataTransferId
    The Id of the Data Transfer you would like to return info for specifically. Exclude to return the full list

    .PARAMETER Status
    Status of the transfer.

    .PARAMETER NewOwnerUserId
    Destination user's profile ID.

    .PARAMETER OldOwnerUserId
    Source user's profile ID.

    .PARAMETER CustomerId
    Immutable ID of the G Suite account.

    .PARAMETER PageSize
    PageSize of the result set.

    Defaults to 500 (although it's typically a much smaller number for most Customers)

    .PARAMETER Limit
    The maximum amount of results you want returned. Exclude or set to 0 to return all results

    .EXAMPLE
    Get-GSDataTransfer

    Gets the list of current Data Transfers
    #>
    [OutputType('Google.Apis.Admin.DataTransfer.datatransfer_v1.Data.ApplicationDataTransfer')]
    [cmdletbinding(DefaultParameterSetName = 'List')]
    Param (
        [parameter(Mandatory,Position = 0,ParameterSetName = 'Get')]
        [String[]]
        $DataTransferId,
        [parameter(ParameterSetName = 'List')]
        [String]
        $Status,
        [parameter(ParameterSetName = 'List')]
        [String]
        $NewOwnerUserId,
        [parameter(ParameterSetName = 'List')]
        [String]
        $OldOwnerUserId,
        [parameter(ParameterSetName = 'List')]
        [String]
        $CustomerId = $Script:PSGSuite.CustomerID,
        [parameter(ParameterSetName = 'List')]
        [ValidateRange(1,500)]
        [Int]
        $PageSize = 500,
        [parameter(ParameterSetName = 'List')]
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
            if ($PSCmdlet.ParameterSetName -eq 'Get') {
                foreach ($I in $DataTransferId) {
                    $request = $service.Transfers.Get($I)
                    $request.Execute()
                }
            }
            else {
                $request = $service.Transfers.List()
                $request.CustomerId = $CustomerId
                if ($Limit -gt 0 -and $PageSize -gt $Limit) {
                    Write-Verbose ("Reducing PageSize from {0} to {1} to meet limit with first page" -f $PageSize,$Limit)
                    $PageSize = $Limit
                }
                $request.MaxResults = $PageSize
                foreach ($prop in @('NewOwnerUserId','OldOwnerUserId','Status')) {
                    if ($PSBoundParameters.ContainsKey($prop)) {
                        $request.$prop = $PSBoundParameters[$prop]
                    }
                }
                Write-Verbose "Getting Data Transfer list"
                $response = @()
                [int]$i = 1
                $overLimit = $false
                do {
                    $result = $request.Execute()
                    $response += $result.DataTransfers
                    if ($result.NextPageToken) {
                        $request.PageToken = $result.NextPageToken
                    }
                    [int]$retrieved = ($i + $result.DataTransfers.Count) - 1
                    Write-Verbose "Retrieved $retrieved Data Transfers..."
                    if ($Limit -gt 0 -and $retrieved -eq $Limit) {
                        Write-Verbose "Limit reached: $Limit"
                        $overLimit = $true
                    }
                    elseif ($Limit -gt 0 -and ($retrieved + $PageSize) -gt $Limit) {
                        $newPS = $Limit - $retrieved
                        Write-Verbose ("Reducing PageSize from {0} to {1} to meet limit with next page" -f $PageSize,$newPS)
                        $request.MaxResults = $newPS
                    }
                    [int]$i = $i + $result.DataTransfers.Count
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
