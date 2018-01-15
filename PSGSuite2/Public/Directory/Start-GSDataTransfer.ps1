function Start-GSDataTransfer {
    [cmdletbinding()]
    Param
    (
      [parameter(Mandatory=$true,Position=0)]
      [string]
      $OldOwnerUserId,
      [parameter(Mandatory=$true,Position=1)]
      [string]
      $NewOwnerUserId,
      [parameter(Mandatory=$true,Position=2,ValueFromPipelineByPropertyName=$true)]
      [alias("id")]
      [string]
      $ApplicationId,
      [parameter(Mandatory=$true)]
      [ValidateSet("SHARED","PRIVATE")]
      [string[]]
      $PrivacyLevel
    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.datatransfer'
            ServiceType = 'Google.Apis.Admin.DataTransfer.datatransfer_v1.DataTransferService'
        }
        $service = New-GoogleService @serviceParams
        $OldOwnerUserId = try {
            [bigint]$OldOwnerUserId
        }
        catch {
            Write-Verbose "Resolving Old Owner's UserId from '$OldOwnerUserId'"
            [bigint](Get-GSUser -User $OldOwnerUserId -Projection Basic -Verbose:$false | Select-Object -ExpandProperty id)
        }
        $NewOwnerUserId = try {
            [bigint]$NewOwnerUserId
        }
        catch {
            Write-Verbose "Resolving New Owner's UserId from '$NewOwnerUserId'"
            [bigint](Get-GSUser -User $NewOwnerUserId -Projection Basic -Verbose:$false | Select-Object -ExpandProperty id)
        }
    }
    Process {
        try {
            $body = New-Object 'Google.Apis.Admin.DataTransfer.datatransfer_v1.Data.DataTransfer' -Property @{
                OldOwnerUserId = $OldOwnerUserId
                NewOwnerUserId = $NewOwnerUserId
            }
            $AppDataTransfers = New-Object 'Google.Apis.Admin.DataTransfer.datatransfer_v1.Data.ApplicationDataTransfer' -Property @{
                ApplicationId = $ApplicationId
            }
            if ($PrivacyLevel) {
                $AppDataTransfers.ApplicationTransferParams = [Google.Apis.Admin.DataTransfer.datatransfer_v1.Data.ApplicationTransferParam[]](New-Object 'Google.Apis.Admin.DataTransfer.datatransfer_v1.Data.ApplicationTransferParam' -Property @{
                    Key = 'PRIVACY_LEVEL'
                    Value = [String[]]$PrivacyLevel
                })
            }
            $body.ApplicationDataTransfers = [Google.Apis.Admin.DataTransfer.datatransfer_v1.Data.ApplicationDataTransfer[]]$AppDataTransfers
            $request = $service.Transfers.Insert($body)
            Write-Verbose "Starting Data Transfer from User Id '$OldOwnerUserId' to User Id '$NewOwnerUserId'"
            $request.Execute()
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}