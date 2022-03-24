function Get-LicenseSkus {
    ConvertFrom-Json '{"Google-Drive-storage-1TB": {"product": "Google-Drive-storage", "displayName": "Google Drive Storage 1TB", "aliases": ["drive1tb", "1tb", "googledrivestorage1tb"]}, "Google-Apps-For-Government": {"product": "Google-Apps", "displayName": "G Suite Government", "aliases": ["gafg", "gsuitegovernment", "gsuitegov"]}, "Google-Vault": {"product": "Google-Vault", "displayName": "Google Vault", "aliases": ["vault", "googlevault"]}, "Google-Drive-storage-8TB": {"product": "Google-Drive-storage", "displayName": "Google Drive Storage 8TB", "aliases": ["drive8tb", "8tb", "googledrivestorage8tb"]}, "Google-Drive-storage-400GB": {"product": "Google-Drive-storage", "displayName": "Google Drive Storage 400GB", "aliases": ["drive400gb", "400gb", "googledrivestorage400gb"]}, "Google-Drive-storage-16TB": {"product": "Google-Drive-storage", "displayName": "Google Drive Storage 16TB", "aliases": ["drive16tb", "16tb", "googledrivestorage16tb"]}, "1010340002": {"product": "101034", "displayName": "G Suite Business Archived", "aliases": ["gsbau", "businessarchived", "gsuitebusinessarchived"]}, "1010340001": {"product": "101034", "displayName": "G Suite Enterprise Archived", "aliases": ["gseau", "enterprisearchived", "gsuiteenterprisearchived"]}, "Google-Drive-storage-50GB": {"product": "Google-Drive-storage", "displayName": "Google Drive Storage 50GB", "aliases": ["drive50gb","50gb", "googledrivestorage50gb"]}, "Google-Apps": {"product": "Google-Apps", "displayName": "G Suite Free/Standard", "aliases": ["standard", "free"]}, "Google-Drive-storage-4TB": {"product": "Google-Drive-storage", "displayName": "Google Drive Storage 4TB", "aliases": ["drive4tb", "4tb", "googledrivestorage4tb"]}, "Google-Drive-storage-2TB": {"product": "Google-Drive-storage", "displayName": "Google Drive Storage 2TB", "aliases": ["drive2tb", "2tb", "googledrivestorage2tb"]}, "Google-Apps-For-Postini": {"product": "Google-Apps", "displayName": "G Suite Message Security", "aliases": ["gams", "postini", "gsuitegams", "gsuitepostini", "gsuitemessagesecurity"]}, "Google-Apps-Unlimited": {"product": "Google-Apps", "displayName": "G Suite Business", "aliases": ["gau", "gsb", "unlimited", "gsuitebusiness"]}, "Google-Drive-storage-200GB": {"product": "Google-Drive-storage", "displayName": "Google Drive Storage 200GB", "aliases": ["drive200gb", "200gb", "googledrivestorage200gb"]}, "1010010001": {"product": "101001", "displayName": "Cloud Identity", "aliases": ["identity", "cloudidentity"]}, "Google-Coordinate": {"product": "Google-Coordinate", "displayName": "Google Coordinate", "aliases": ["coordinate", "googlecoordinate"]}, "1010330002": {"product": "101033", "displayName": "Google Voice Premier", "aliases": ["gvpremier", "voicepremier", "googlevoicepremier"]}, "1010330003": {"product": "101033", "displayName": "Google Voice Starter", "aliases": ["gvstarter", "voicestarter", "googlevoicestarter"]}, "1010330004": {"product": "101033", "displayName": "Google Voice Standard", "aliases": ["gvstandard", "voicestandard", "googlevoicestandard"]}, "Google-Vault-Former-Employee": {"product": "Google-Vault", "displayName": "Google Vault Former Employee", "aliases": ["vfe", "googlevaultformeremployee"]}, "Google-Apps-For-Business": {"product": "Google-Apps", "displayName": "G Suite Basic", "aliases": ["gafb", "gafw", "basic", "gsuitebasic"]}, "1010060001": {"product": "Google-Apps", "displayName": "Drive Enterprise", "aliases": ["d4e", "driveenterprise", "drive4enterprise"]}, "1010020020": {"product": "Google-Apps", "displayName": "G Suite Enterprise", "aliases": ["gae", "gse", "enterprise", "gsuiteenterprise"]}, "Google-Apps-Lite": {"product": "Google-Apps", "displayName": "G Suite Lite", "aliases": ["gal", "gsl", "lite", "gsuitelite"]}, "1010050001": {"product": "101005", "displayName": "Cloud Identity Premium", "aliases": ["identitypremium", "cloudidentitypremium"]}, "1010310002": {"product": "101031", "displayName": "G Suite Enterprise for Education", "aliases": ["gsefe", "e4e", "gsuiteenterpriseeducation"]}, "1010310003": {"product": "101031", "displayName": "G Suite Enterprise for Education Student", "aliases": ["gsefes", "e4es", "gsuiteenterpriseeducationstudent"]}, "Google-Chrome-Device-Management": {"product": "Google-Chrome-Device-Management", "displayName": "Google Chrome Device Management", "aliases": ["chrome", "cdm", "googlechromedevicemanagement"]}, "Google-Drive-storage-20GB": {"product": "Google-Drive-storage", "displayName": "Google Drive Storage 20GB", "aliases": ["drive20gb", "20gb", "googledrivestorage20gb"]}}'
}

function Get-LicenseProducts {
    ConvertFrom-Json '{"Google-Vault": "Google Vault", "Google-Drive-storage": "Google Drive Storage", "Google-Coordinate": "Google Coordinate", "101034": "G Suite Archived", "101033": "Google Voice", "Google-Apps": "G Suite", "101031": "G Suite Enterprise for Education", "101006": "Drive Enterprise", "Google-Chrome-Device-Management": "Google Chrome Device Management", "101005": "Cloud Identity Premium", "101001": "Cloud Identity Free"}'
}

function Get-LicenseProductHash {
    Param (
        [Parameter(Position = 0)]
        [String]
        $Key
    )
    $_result = @{'Cloud-Identity' = '101001'}
    $_full = Get-LicenseProducts
    $_products = $_full.PSObject.Properties.Name | Sort-Object -Unique
    foreach ($_id in $_products) {
        $_friendlyname = $_full.$_id -replace '\W+','-'
        $_result[$_id] = $_id
        $_result[$_friendlyname] = $_id
    }
    if ($Key) {
        $_result[$Key]
    }
    else {
        $_result
    }
}

function Get-LicenseSkuHash {
    Param (
        [Parameter(Position = 0)]
        [String]
        $Key
    )
    $_result = @{}
    $_full = Get-LicenseSkus
    $_licenses = $_full.PSObject.Properties.Name | Sort-Object -Unique
    foreach ($_sku in $_licenses) {
        $_displayName = $_full.$_sku.displayName -replace '\W+','-'
        $_result[$_displayName] = $_sku
        foreach ($_alias in $_full.$_sku.aliases) {
            $_result[$_alias] = $_sku
        }
    }
    if ($Key) {
        $_result[$Key]
    }
    else {
        $_result
    }
}

function Get-LicenseSkuToProductHash {
    Param (
        [Parameter(Position = 0)]
        [String]
        $Key
    )
    $_result = @{}
    $_full = Get-LicenseSkus
    $_licenses = $_full.PSObject.Properties.Name | Sort-Object -Unique
    foreach ($_sku in $_licenses) {
        $_displayName = $_full.$_sku.displayName -replace '\W+','-'
        $_result[$_sku] = $_full.$_sku.product
        $_result[$_displayName] = $_full.$_sku.product
        foreach ($_alias in $_full.$_sku.aliases) {
            $_result[$_alias] = $_full.$_sku.product
        }
    }
    if ($Key) {
        $_result[$Key]
    }
    else {
        $_result
    }
}

function Get-LicenseSkuFromDisplayName  {
    Param (
        [Parameter(Position = 0)]
        [String]
        $Key
    )
    $_result = @{}
    $_full = Get-LicenseSkus
    $_licenses = $_full.PSObject.Properties.Name | Sort-Object -Unique
    foreach ($_sku in $_licenses) {
        $_displayName = $_full.$_sku.displayName -replace '\W+','-'
        $_result[$_displayName] = $_sku
    }
    if ($Key) {
        $_result[$Key]
    }
    else {
        $_result
    }
}

function Get-LicenseProductFromDisplayName {
    Param (
        [Parameter(Position = 0)]
        [String]
        $Key
    )
    $_result = @{'Cloud-Identity' = '101001'}
    $_full = Get-LicenseProducts
    $_products = $_full.PSObject.Properties.Name | Sort-Object -Unique
    foreach ($_id in $_products) {
        $_friendlyname = $_full.$_id -replace '\W+','-'
        $_result[$_friendlyname] = $_id
    }
    if ($Key) {
        $_result[$Key]
    }
    else {
        $_result
    }
}
