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
    
    .EXAMPLE
    Get-GSDataTransferApplication

    Gets the list of available Data Transfer Applications
    #>
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false,Position = 0)]
        [String[]]
        $ApplicationId,
        [parameter(Mandatory = $false)]
        [ValidateScript( {[int]$_ -le 500 -and [int]$_ -ge 1})]
        [Int]
        $PageSize = 500
    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.datatransfer'
            ServiceType = 'Google.Apis.Admin.DataTransfer.datatransfer_v1.DataTransferService'
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
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
                if ($PageSize) {
                    $request.MaxResults = $PageSize
                }
                Write-Verbose "Getting all Data Transfer Applications"
                $response = @()
                [int]$i = 1
                do {
                    $result = $request.Execute()
                    $response += $result.Applications
                    if ($result.NextPageToken) {
                        $request.PageToken = $result.NextPageToken
                    }
                    [int]$retrieved = ($i + $result.Applications.Count) - 1
                    Write-Verbose "Retrieved $retrieved Data Transfer Applications..."
                    [int]$i = $i + $result.Applications.Count
                }
                until (!$result.NextPageToken)
                return $response
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}