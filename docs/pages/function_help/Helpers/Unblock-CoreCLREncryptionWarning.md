# Unblock-CoreCLREncryptionWarning

## SYNOPSIS
Unblocks CoreCLR encryption warning to ensure it appears if applicable (specific to PSGSuite)

## SYNTAX

```
Unblock-CoreCLREncryptionWarning
```

## DESCRIPTION
Unblocks CoreCLR encryption warning to ensure it appears if applicable (specific to PSGSuite) by removing the following file if it exists: ~\.scrthq\BlockCoreCLREncryptionWarning.txt

## EXAMPLES

### EXAMPLE 1
```
Unblock-CoreCLREncryptionWarning
```

Removes the breadcrumb file to let PSGSuite know that you want to receive the CoreCLR encryption warning if applicable

## PARAMETERS

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
