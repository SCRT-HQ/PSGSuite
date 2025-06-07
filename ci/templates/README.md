# Generation Templates

This directory contains the templates used to programmatically generate module content during the build process. Each template is an independent `.ps1` file that outputs the generated content to the PowerShell pipeline as either a string or a hashtable of strings.

## Template Directories

By default the template directory tree mirrors the module source directory tree. When executed, all output will be written to the corresponding directory found in the module source directory.

For example, the template `<Repository_Root>\Templates\Public\Authentication\Foo.ps1` will have it's output written to the directory `<Repository_Root>\PSGSuite\Public\Authentication\`.

## Template Priority

It may be beneficial to prioritise the order of execution for each template. It is possible to assign a priority value to each template between `1` execute first and `9` execute last. To assign a value, prefix the template name with `<priority>-`.

If a priority value is not assigned to a template, it will be assigned priority `5` by default.

For example, for the following templates:

- `2-foo.ps1` is assigned priority `2`
- `bar.ps1` is assigned priority `5`

## Template Output

**String Output**

When a template returns a string value it's output filename will be the template file name excluding any priority prefix.

For example, the file `<Repository_Root>\Templates\Public\Authentication\2-Foo.ps1` will have it's output written to the file `<Repository_Root>\PSGSuite\Public\Authentication\Foo.ps1`.

**Hashtable Output**

When a template returns a hashtable, the value for each entry will be converted to a string and the key becomes the output file name including the file extension.

For example, the file `<Repository_Root>\Templates\Public\Authentication\Foo.ps1` produces the following hashtable.

```
@{
  'Get-Foo.ps1' = 'Write-Host "Got Foo!"'
  'Remove-Foo.ps1' = 'Write-Host "Removed Foo!"'
}
```

Two output files would be produced.

- `<Repository_Root>\PSGSuite\Public\Authentication\Get-Foo.ps1`
- `<Repository_Root>\PSGSuite\Public\Authentication\Remove-Foo.ps1`

So far the output files have been relative to the location of the template file. It is also possible to provide an absolute file path, relative to the source directory, as the entries key. When this is done, the output file path will be the specified absolute path.

For example, the file `<Repository_Root>\Templates\Public\Authentication\Foo.ps1` produces the following hashtable.

```
@{
  '\Private\Authentication\Get-Foo.ps1' = 'Write-Host "Got Foo!"'
  '\Show-Foo.ps1' = 'Write-Host "Show Foo!"'
  'Remove-Foo.ps1' = 'Write-Host "Removed Foo!"'
}
```

Three output files would be produced.

- `<Repository_Root>\PSGSuite\Private\Authentication\Get-Foo.ps1`
- `<Repository_Root>\PSGSuite\Show-Foo.ps1`
- `<Repository_Root>\PSGSuite\Public\Authentication\Remove-Foo.ps1`


**Unsupported Output**

When a template returns an unsupported type, it will be converted and processed as a string.


## Template Execution

Template execution is triggered by the `generate` task of the PSGSuite build pipeline.

The following parameters are passed to the template:

- `-ModuleSource` - This is the file path to the repository root.

All generated output files will each have a comment added at the top of the file indicating it was programmatically generated.
