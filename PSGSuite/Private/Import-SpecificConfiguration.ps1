function Import-SpecificConfiguration {
    <#
    .Synopsis
    Import the full, layered configuration for the module.
    Allows for specification of scoped module to load, in case different scopes have different encryption levels
    .Description
    Imports the DefaultPath Configuration file, and then imports the Machine, Roaming (enterprise), and local config files, if they exist.
    Each configuration file is layered on top of the one before (so only needs to set values which are different)
    .Example
    $Configuration = Import-Configuration

    This example shows how to use Import-Configuration in your module to load the cached data

    .Example
    $Configuration = Get-Module Configuration | Import-Configuration

    This example shows how to use Import-Configuration in your module to load data cached for another module
    #>
    [CmdletBinding(DefaultParameterSetName = '__CallStack')]
    param(
        # A callstack. You should not ever pass this.
        # It is used to calculate the defaults for all the other parameters.
        [Parameter(ParameterSetName = "__CallStack")]
        [System.Management.Automation.CallStackFrame[]]$CallStack = $(Get-PSCallStack),

        # The Module you're importing configuration for
        [Parameter(ParameterSetName = "__ModuleInfo", ValueFromPipeline = $true)]
        [System.Management.Automation.PSModuleInfo]$Module = $(
            $mi = ($CallStack)[0].InvocationInfo.MyCommand.Module
            if ($mi -and $mi.ExportedCommands.Count -eq 0) {
                if ($mi2 = Get-Module $mi.ModuleBase -ListAvailable | Where-Object Name -eq $mi.Name | Where-Object ExportedCommands | Select-Object -First 1) {
                    return $mi2
                }
            }
            return $mi
        ),

        # An optional module qualifier (by default, this is blank)
        [Parameter(ParameterSetName = "ManualOverride", Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias("Author")]
        [String]$CompanyName = $(
            if ($Module) {
                $Name = $Module.CompanyName -replace "[$([Regex]::Escape(-join[IO.Path]::GetInvalidFileNameChars()))]","_"
                if ($Name -eq "Unknown" -or -not $Name) {
                    $Name = $Module.Author
                    if ($Name -eq "Unknown" -or -not $Name) {
                        $Name = "AnonymousModules"
                    }
                }
                $Name
            }
            else {
                "AnonymousScripts"
            }
        ),

        # The name of the module or script
        # Will be used in the returned storage path
        [Parameter(ParameterSetName = "ManualOverride", Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [String]$Name = $(if ($Module) {
                $Module.Name
            }),

        # The full path (including file name) of a default Configuration.psd1 file
        # By default, this is expected to be in the same folder as your module manifest, or adjacent to your script file
        [Parameter(ParameterSetName = "ManualOverride", ValueFromPipelineByPropertyName = $true)]
        [Alias("ModuleBase")]
        [String]$DefaultPath = $(if ($Module) {
                Join-Path $Module.ModuleBase Configuration.psd1
            }),

        [Parameter(ParameterSetName = "Path",Mandatory = $true)]
        [ValidateScript( {Test-Path $_})]
        [string]$Path,

        [Parameter(Mandatory = $false)]
        [ValidateSet("User", "Machine", "Enterprise", $null)]
        [string]$Scope = $Script:ConfigScope,

        # The version for saved settings -- if set, will be used in the returned path
        # NOTE: this is *never* calculated, if you use version numbers, you must manage them on your own
        [Version]$Version,

        # If set (and PowerShell version 4 or later) preserve the file order of configuration
        # This results in the output being an OrderedDictionary instead of Hashtable
        [Switch]$Ordered
    )
    begin {
        Write-Verbose "Module Name $Name"
    }
    process {
        if (!$Name) {
            throw "Could not determine the configuration name. When you are not calling Import-Configuration from a module, you must specify the -Author and -Name parameter"
        }

        if (Test-Path $DefaultPath -Type Container) {
            $DefaultPath = Join-Path $DefaultPath Configuration.psd1
        }
        $Configuration = if (Test-Path $DefaultPath) {
            Import-Metadata $DefaultPath -ErrorAction Ignore -Ordered:$Ordered
            Write-Verbose "Default config found: $DefaultPath"
        }
        else {
            @{}
        }

        $Parameters = @{
            CompanyName = $CompanyName
            Name        = $Name
        }
        if ($Version) {
            $Parameters.Version = $Version
        }
        if ($Path) {
            Write-Verbose "Importing configuration from specific path: $Path"
            Import-Metadata "$(Resolve-Path $Path)" -ErrorAction Ignore -Ordered:$Ordered
        }
        else {
            if (!$Scope -or $Scope -eq "Machine") {
                $MachinePath = Get-ConfigurationPath @Parameters -Scope Machine
                $MachinePath = Join-Path $MachinePath Configuration.psd1
                $Machine = if (Test-Path $MachinePath) {
                    Import-Metadata $MachinePath -ErrorAction Ignore -Ordered:$Ordered
                    Write-Verbose "Machine config found: $MachinePath"
                }
                else {
                    @{}
                }
            }

            if (!$Scope -or $Scope -eq "Enterprise") {
                $EnterprisePath = Get-ConfigurationPath @Parameters -Scope Enterprise
                $EnterprisePath = Join-Path $EnterprisePath Configuration.psd1
                $Enterprise = if (Test-Path $EnterprisePath) {
                    Import-Metadata $EnterprisePath -ErrorAction Ignore -Ordered:$Ordered
                    Write-Verbose "Enterprise config found: $EnterprisePath"
                }
                else {
                    @{}
                }
            }

            if (!$Scope -or $Scope -eq "User") {
                $LocalUserPath = Get-ConfigurationPath @Parameters -Scope User
                $LocalUserPath = Join-Path $LocalUserPath Configuration.psd1
                $LocalUser = if (Test-Path $LocalUserPath) {
                    Import-Metadata $LocalUserPath -ErrorAction Ignore -Ordered:$Ordered
                    Write-Verbose "LocalUser config found: $LocalUserPath"
                }
                else {
                    @{}
                }
            }
            switch ($Scope) {
                Machine {
                    Write-Verbose "Importing configuration at scope: $Scope"
                    $Configuration | Update-Object $Machine
                }
                Enterprise {
                    Write-Verbose "Importing configuration at scope: $Scope"
                    $Configuration | Update-Object $Enterprise
                }
                User {
                    Write-Verbose "Importing configuration at scope: $Scope"
                    $Configuration | Update-Object $LocalUser
                }
                Default {
                    Write-Verbose "Importing layered configuration"
                    $Configuration |
                        Update-Object $Machine |
                        Update-Object $Enterprise |
                        Update-Object $LocalUser
                }
            }
        }
    }
}
