function Stop-GSDataTransfer {
    <#
    .SYNOPSIS
    Stops a Data Transfer in progress

    .DESCRIPTION
    Stops a Data Transfer in progress

    .PARAMETER DataTransferId
    The Id of the Data Transfer to stop

    .EXAMPLE
    Stop-GSDataTransfer -DataTransferId abc123xyz456

    Stops the Data Transfer with Id 'abc123xyz456'
    #>
    [cmdletbinding()]
    Param (
        [parameter(Mandatory=$true,Position=0)]
        [string]
        $DataTransferId
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
            $dataTransfer = $service.Transfers.Get($DataTransferId).Execute()
            if ($dataTransfer) {
                $updateRequest = New-Object Google.Apis.Admin.DataTransfer.datatransfer_v1.Data.DataTransfer -Property @{
                    Status = "CANCELLED"
                }
                $service.Transfers.Update($dataTransfer.Id, $updateRequest).Execute()
                Write-Verbose "Stopped Data Transfer with Id '$DataTransferId'"
            }
            else {
                Write-Error "Data Transfer with Id '$DataTransferId' not found"
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