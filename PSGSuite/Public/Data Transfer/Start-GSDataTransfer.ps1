function Start-GSDataTransfer {
    <#
    .SYNOPSIS
    Starts a Data Transfer from one user to another

    .DESCRIPTION
    Starts a Data Transfer from one user to another

    .PARAMETER OldOwnerUserId
    The email or unique Id of the owner you are transferring data *FROM*

    .PARAMETER NewOwnerUserId
    The email or unique Id of the owner you are transferring data *TO*

    .PARAMETER ApplicationId
    The application Id that you would like to transfer data for

    .PARAMETER PrivacyLevel
    The privacy level for the data you'd like to transfer

    *Valid for Drive & Docs data transfers only.*

    Available values are:
    * "SHARED": all shared content owned by the user
    * "PRIVATE": all private (unshared) content owned by the user

    .PARAMETER ReleaseResources
    If true, releases Calendar resources booked by the OldOwner to the NewOwner.

    *Valid for Calendar data transfers only.*

    .EXAMPLE
    Start-GSDataTransfer -OldOwnerUserId joe -NewOwnerUserId mark -ApplicationId 55656082996 -PrivacyLevel SHARED,PRIVATE

    Transfers all of Joe's data to Mark
    #>
    [OutputType('Google.Apis.Admin.DataTransfer.datatransfer_v1.Data.DataTransfer')]
    [cmdletbinding()]
    Param (
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
        [parameter(Mandatory=$false)]
        [ValidateSet("SHARED","PRIVATE")]
        [string[]]
        $PrivacyLevel,
        [parameter(Mandatory=$false)]
        [switch]
        $ReleaseResources
    )
    Process {
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
            elseif ($ReleaseResources) {
                $AppDataTransfers.ApplicationTransferParams = [Google.Apis.Admin.DataTransfer.datatransfer_v1.Data.ApplicationTransferParam[]](New-Object 'Google.Apis.Admin.DataTransfer.datatransfer_v1.Data.ApplicationTransferParam' -Property @{
                    Key = 'RELEASE_RESOURCES'
                    Value = [String[]]'TRUE'
                })
            }
            $body.ApplicationDataTransfers = [Google.Apis.Admin.DataTransfer.datatransfer_v1.Data.ApplicationDataTransfer[]]$AppDataTransfers
            $request = $service.Transfers.Insert($body)
            Write-Verbose "Starting Data Transfer from User Id '$OldOwnerUserId' to User Id '$NewOwnerUserId'"
            $request.Execute()
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
