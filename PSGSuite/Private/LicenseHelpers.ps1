function Get-LicenseSkus {
    ConvertFrom-Json '{"1010010001":{"aliases":["identity","cloudidentity","ci"],"displayName":"Cloud Identity","product":"101001"},"1010020020":{"aliases":["gae","gse","enterprise","gsuiteenterprise","gwep","enterpriseplus"],"displayName":"Google Workspace Enterprise Plus","product":"Google-Apps"},"1010020025":{"aliases":["gwbp","businessplus"],"displayName":"Google Workspace Business Plus","product":"Google-Apps"},"1010020026":{"aliases":["gwestandard","enterprisestandard"],"displayName":"Google Workspace Enterprise Standard","product":"Google-Apps"},"1010020027":{"aliases":["gwbstarter","businessstarter"],"displayName":"Google Workspace Business Starter","product":"Google-Apps"},"1010020028":{"aliases":["gwbstandard","businessstandard"],"displayName":"Google Workspace Business Standard","product":"Google-Apps"},"1010020029":{"aliases":["gwestarter","enterprisestarter"],"displayName":"Google Workspace Enterprise Starter","product":"Google-Apps"},"1010020030":{"aliases":["gwfstarter","frontlinestarter"],"displayName":"Google Workspace Frontline Starter","product":"Google-Apps"},"1010020031":{"aliases":["gwfstandard","frontlinestandard"],"displayName":"Google Workspace Frontline Standard","product":"Google-Apps"},"1010050001":{"aliases":["identitypremium","cloudidentitypremium","cip"],"displayName":"Cloud Identity Premium","product":"101005"},"1010060001":{"aliases":["gwe","essentials"],"displayName":"Google Workspace Essentials","product":"Google-Apps"},"1010060003":{"aliases":["gwee","enterpriseessentials"],"displayName":"Google Workspace Enterprise Essentials","product":"Google-Apps"},"1010060005":{"aliases":["gwep","essentialsplus"],"displayName":"Google Workspace Essentials Plus","product":"Google-Apps"},"1010310002":{"aliases":["gsefe","e4e","gsuiteenterpriseeducation","gwepl"],"displayName":"Google Workspace for Education Plus - Legacy","product":"101031"},"1010310003":{"aliases":["gsefes","e4es","gsuiteenterpriseeducationstudent","gweplstudent"],"displayName":"Google Workspace for Education Plus - Legacy (Student)","product":"101031"},"1010310005":{"aliases":["gwes","educationstandard"],"displayName":"Google Workspace for Education Standard","product":"101031"},"1010310006":{"aliases":["gwesstaff","educationstandardstaff"],"displayName":"Google Workspace for Education Standard (Staff)","product":"101031"},"1010310007":{"aliases":["gwesstudent","educationstandardstudent"],"displayName":"Google Workspace for Education Standard (Extra Student)","product":"101031"},"1010310008":{"aliases":["gwep","educationplus"],"displayName":"Google Workspace for Education Plus","product":"101031"},"1010310009":{"aliases":["gwepstaff","educationplusstaff"],"displayName":"Google Workspace for Education Plus (Staff)","product":"101031"},"1010310010":{"aliases":["gwepstudent","educationplusstudent"],"displayName":"Google Workspace for Education Plus (Extra Student)","product":"101031"},"1010330002":{"aliases":["gvpremier","voicepremier","googlevoicepremier"],"displayName":"Google Voice Premier","product":"101033"},"1010330003":{"aliases":["gvstarter","voicestarter","googlevoicestarter"],"displayName":"Google Voice Starter","product":"101033"},"1010330004":{"aliases":["gvstandard","voicestandard","googlevoicestandard"],"displayName":"Google Voice Standard","product":"101033"},"1010340001":{"aliases":["gseau","enterprisearchived","gsuiteenterprisearchived","gweparchived","enterpriseplusarchived"],"displayName":"Google Workspace Enterprise Plus - Archived User","product":"101034"},"1010340002":{"aliases":["gsbau","businessarchived","gsuitebusinessarchived","gsba"],"displayName":"G Suite Business - Archived User","product":"101034"},"1010340003":{"aliases":["gwbparchived","businessplusarchived"],"displayName":"Google Workspace Business Plus - Archived User","product":"101034"},"1010340004":{"aliases":["gwesarchived","enterprisestandardarchived"],"displayName":"Google Workspace Enterprise Standard - Archived User","product":"101034"},"1010340005":{"aliases":["gwbstarterarchived","businessstarterarchived"],"displayName":"Google Workspace Business Starter - Archived User","product":"101034"},"1010340006":{"aliases":["gwbstandardarchived","businessstandardarchived"],"displayName":"Google Workspace Business Standard - Archived User","product":"101034"},"1010370001":{"aliases":["gwetlu","educationteachlearnupgrade"],"displayName":"Google Workspace for Education: Teaching and Learning Upgrade","product":"101037"},"1010380001":{"aliases":["asc","appsheetcore"],"displayName":"AppSheet Core","product":"101038"},"1010380002":{"aliases":["ases","appsheetenterprisestandard"],"displayName":"AppSheet Enterprise Standard","product":"101038"},"1010380003":{"aliases":["ases2","appsheetenterprisestandard2"],"displayName":"AppSheet Enterprise Standard - 2","product":"101038"},"Google-Apps-Unlimited":{"aliases":["gau","gsb","unlimited","gsuitebusiness"],"displayName":"G Suite Business","product":"Google-Apps"},"Google-Apps-For-Business":{"aliases":["gafb","gafw","basic","gsuitebasic"],"displayName":"G Suite Basic","product":"Google-Apps"},"Google-Apps-Lite":{"aliases":["gal","gsl","lite","gsuitelite"],"displayName":"G Suite Lite","product":"Google-Apps"},"Google-Apps-For-Postini":{"aliases":["gams","postini","gsuitegams","gsuitepostini","gsuitemessagesecurity"],"displayName":"Google Apps Message Security","product":"Google-Apps"},"Google-Apps-For-Education":{"aliases":["gwef","educationfundamentals"],"displayName":"Google Workspace for Education Fundamentals","product":"Google-Apps"},"Google-Vault":{"aliases":["vault","googlevault","gv"],"displayName":"Google Vault","product":"Google-Vault"},"Google-Vault-Former-Employee":{"aliases":["vfe","googlevaultformeremployee","gvfe"],"displayName":"Google Vault Former Employee","product":"Google-Vault"}}'
}

function Get-LicenseProducts {
    ConvertFrom-Json '{"101001":"Cloud Identity","101005":"Cloud Identity Premium","101031":"Google Workspace for Education","101033":"Google Voice","101034":"Google Workspace Archived User","101037":"Google Workspace for Education","101038":"AppSheet","Google-Apps":"Google Workspace","Google-Vault":"Google Vault"}'
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
