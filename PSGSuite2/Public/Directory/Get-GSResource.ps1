function Get-GSResource {
    [CmdletBinding()]
    Param
    (
        [parameter(Mandatory = $false,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [String[]]
        $Id,
        [parameter(Mandatory = $false)]
        [ValidateSet('Calendars','Buildings','Features')]
        [String]
        $Resource = 'Calendars',
        [parameter(Mandatory = $false)]
        [Alias('Query')]
        [String[]]
        $Filter,
        [parameter(Mandatory = $false)]
        [String[]]
        $OrderBy,
        [parameter(Mandatory = $false)]
        [ValidateScript( {[int]$_ -le 500 -and [int]$_ -ge 1})]
        [Alias("MaxResults")]
        [Int]
        $PageSize = "500"
    )
    Begin {
        if ($Id) {
            $serviceParams = @{
                Scope       = 'https://www.googleapis.com/auth/admin.directory.resource.calendar'
                ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
            }
            $service = New-GoogleService @serviceParams
        }
    }
    Process {
        try {
            if ($Id) {
                foreach ($I in $Id) {
                    Write-Verbose "Getting Resource $Resource Id '$I'"
                    $request = $service.Resources.$Resource.Get($(if($Script:PSGSuite.CustomerID){$Script:PSGSuite.CustomerID}else{'my_customer'}),$I)
                    $request.Execute() | Select-Object @{N = 'Resource';E = {$Resource}},*
                }
            }
            else {
                Get-GSResourceList @PSBoundParameters
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}