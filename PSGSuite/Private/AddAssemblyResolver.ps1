$lib = (Resolve-Path (Join-Path $PSScriptRoot 'lib')).Path
$sdkPath = if ($PSVersionTable.PSVersion.Major -lt 6) {
    Write-Verbose "Importing the SDK's for net45"
    "$lib\net45"
}
else {
    Write-Verbose "Importing the SDK's for netstandard1.3"
    "$lib\netstandard1.3"
}
$dlls = Get-ChildItem $sdkPath -Filter "*.dll"

# Load the core dependencies in first
$null = [System.Reflection.Assembly]::LoadFrom(($dlls | Where-Object { $_.Name -eq 'Google.Apis.dll' }).FullName)
$null = [System.Reflection.Assembly]::LoadFrom(($dlls | Where-Object { $_.Name -eq 'Google.Apis.Auth.dll'}).FullName)

if ($null -eq ('Redirector' -as [type])) {
$source = @'
using System;
using System.Linq;
using System.Reflection;
using System.Text.RegularExpressions;

public class Redirector
{
    public readonly string[] ExcludeList;

    public Redirector(string[] ExcludeList = null)
    {
        this.ExcludeList  = ExcludeList;
        this.EventHandler = new ResolveEventHandler(AssemblyResolve);
    }

    public readonly ResolveEventHandler EventHandler;

    protected Assembly AssemblyResolve(object sender, ResolveEventArgs resolveEventArgs)
    {
        Console.WriteLine("Attempting to resolve: " + resolveEventArgs.Name); // remove this after its verified to work
        foreach (var assembly in AppDomain.CurrentDomain.GetAssemblies())
        {
            var pattern  = "PublicKeyToken=(.*)$";
            var info     = assembly.GetName();
            var included = ExcludeList == null || !ExcludeList.Contains(resolveEventArgs.Name.Split(',')[0], StringComparer.InvariantCultureIgnoreCase);

            if (included && resolveEventArgs.Name.StartsWith(info.Name, StringComparison.InvariantCultureIgnoreCase))
            {
                if (Regex.IsMatch(info.FullName, pattern))
                {
                    var Matches        = Regex.Matches(info.FullName, pattern);
                    var publicKeyToken = Matches[0].Groups[1];

                    if (resolveEventArgs.Name.EndsWith("PublicKeyToken=" + publicKeyToken, StringComparison.InvariantCultureIgnoreCase))
                    {
                        Console.WriteLine("Redirecting lib to: " + info.FullName); // remove this after its verified to work
                        return assembly;
                    }
                }
            }
        }

        return null;
    }
}
'@
    $type = Add-Type -TypeDefinition $source -PassThru
}
$redirectExcludes = @(
    "System.Management.Automation",
    "Microsoft.PowerShell.Commands.Utility",
    "Microsoft.PowerShell.Commands.Management",
    "Microsoft.PowerShell.Security",
    "Microsoft.WSMan.Management",
    "Microsoft.PowerShell.ConsoleHost",
    "Microsoft.Management.Infrastructure",
    "Microsoft.Powershell.PSReadline",
    "Microsoft.PowerShell.GraphicalHost"
    "System.Management.Automation.HostUtilities",
    "System.Management.Automation.resources",
    "Microsoft.PowerShell.Commands.Management.resources",
    "Microsoft.PowerShell.Commands.Utility.resources",
    "Microsoft.PowerShell.Security.resources",
    "Microsoft.WSMan.Management.resources",
    "Microsoft.PowerShell.ConsoleHost.resources",
    "Microsoft.Management.Infrastructure.resources",
    "Microsoft.Powershell.PSReadline.resources",
    "Microsoft.PowerShell.GraphicalHost.resources",
    "System.Management.Automation.HostUtilities.resources"
)
try {
    $redirector = [Redirector]::new($redirectExcludes)
    [System.AppDomain]::CurrentDomain.add_AssemblyResolve($redirector.EventHandler)
}
catch {
    Write-Warning "Unable to register assembly redirect(s). Please open an issue @ https://github.com/SCRT-HQ/PSGSuite/issues/new and include the following information:`n$($PSVersionTable | ConvertTo-Json -Depth 20)"
}
foreach ($item in ($dlls | Where-Object {$_.Name -notmatch '^Google\.Apis(\.Auth){0,1}\.dll$'})) {
    $sdk = $item.Name
    try {
        $null = [System.Reflection.Assembly]::LoadFrom($item.FullName)
    }
    catch [System.Reflection.ReflectionTypeLoadException] {
        Write-Error "$($sdk): Unable to load assembly!"
        Write-Host "Message: $($_.Exception.Message)"
        Write-Host "StackTrace: $($_.Exception.StackTrace)"
        Write-Host "LoaderExceptions: $($_.Exception.LoaderExceptions)"
    }
    catch {
        Write-Error "$($sdk): $($_.Exception.Message)"
    }
}
