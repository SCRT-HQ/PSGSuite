#
# Module manifest for module 'PSGSuite'
#
# Generated by: Nate Ferrell
#
# Generated on: 2017-12-31
#

@{

    # Script module or binary module file associated with this manifest.
    RootModule            = 'PSGSuite.psm1'

    # Version number of this module.
    ModuleVersion         = '3.0.1'

    # ID used to uniquely identify this module
    GUID                  = '9d751152-e83e-40bb-a6db-4c329092aaec'

    # Author of this module
    Author                = 'Nate Ferrell'

    # Company or vendor of this module
    CompanyName           = 'SCRT HQ'

    # Copyright statement for this module
    Copyright             = '(c) SCRT HQ 2016-2024. All rights reserved.'

    # Description of the functionality provided by this module
    Description           = "PSGSuite is a Powershell module wrapping Google's .NET SDKs in handy functions, enabling users perform tasks as large as G Suite SuperAdmins automating the administration of their multi-domain G Suite accounts down to free, Google account users sending Gmail messages or uploading content to Drive from home."

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion     = '7.4'

    # Name of the Windows PowerShell host required by this module
    # PowerShellHostName = ''

    # Minimum version of the Windows PowerShell host required by this module
    # PowerShellHostVersion = ''

    # Minimum version of Microsoft .NET Framework required by this module
    # DotNetFrameworkVersion = ''

    # Minimum version of the common language runtime (CLR) required by this module
    # CLRVersion = ''

    # Processor architecture (None, X86, Amd64) required by this module
    ProcessorArchitecture = 'None'

    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules       = @(@{ModuleName = "Configuration"; ModuleVersion = "1.3.1" })

    # Assemblies that must be loaded prior to importing this module
    RequiredAssemblies    = @()

    # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    ScriptsToProcess      = @()

    # Type files (.ps1xml) to be loaded when importing this module
    TypesToProcess        = @()

    # Format files (.ps1xml) to be loaded when importing this module
    FormatsToProcess      = @()

    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    # NestedModules = @()

    # Functions to export from this module
    FunctionsToExport     = '*'

    # Cmdlets to export from this module
    CmdletsToExport       = @()

    # Variables to export from this module
    VariablesToExport     = @()

    # Aliases to export from this module
    AliasesToExport       = '*'

    # DSC resources to export from this module
    # DscResourcesToExport = @()

    # List of all modules packaged with this module
    # ModuleList = @()

    # List of all files packaged with this module
    FileList              = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData           = @{

        PSData = @{

            # Denotes this as a prerelease
            Prerelease = 'beta'

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags       = 'GSuite', 'Google', 'Apps', 'API', 'Drive', 'Gmail', 'Admin', 'Automation', 'PSEdition_Core', 'Windows', 'Linux', 'Mac'

            # A URL to the license for this module.
            LicenseUri = 'https://github.com/SCRT-HQ/PSGSuite/blob/main/LICENSE'

            # A URL to the main website for this project.
            ProjectUri = 'https://github.com/SCRT-HQ/PSGSuite'

            # A URL to an icon representing this module.
            IconUri    = 'http://centerlyne.com/wp-content/uploads/2016/10/Google_-G-_Logo.svg_.png'

            # ReleaseNotes of this module
            # ReleaseNotes = ''

            # External dependent modules of this module
            # ExternalModuleDependencies = ''

        } # End of PSData hashtable

    } # End of PrivateData hashtable

    # HelpInfo URI of this module
    # HelpInfoURI           = 'https://github.com/SCRT-HQ/PSGSuite/wiki'

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''

}
