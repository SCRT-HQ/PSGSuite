# Block-CoreCLREncryptionWarning

## SYNOPSIS
Blocks CoreCLR encryption warning from reappearing (specific to PSGSuite)

## SYNTAX

```
Block-CoreCLREncryptionWarning
```

## DESCRIPTION
Blocks CoreCLR encryption warning from reappearing (specific to PSGSuite) by creating a blank txt file in the path: ~\.scrthq

## EXAMPLES

### EXAMPLE 1
```
Block-CoreCLREncryptionWarning
```

Creates the breadcrumb file to let PSGSuite know that you've acknowledged the CoreCLR encryption warning and it does not need to be displayed every time the module is imported

## PARAMETERS

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
