function Get-MimeType { 
    Param
    (
        [parameter(Mandatory=$true, ValueFromPipeline=$true,Position = 0)]
        [System.IO.FileInfo]
        $File
    ) 
    $mimeHash = @{
        xls = 'application/vnd.ms-excel'
        xlsx = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
        xml = 'text/xml'
        ods = 'application/vnd.oasis.opendocument.spreadsheet'
        csv = 'text/plain'
        tmpl = 'text/plain'
        pdf  = 'application/pdf'
        php = 'application/x-httpd-php'
        jpg = 'image/jpeg'
        png = 'image/png'
        gif = 'image/gif'
        bmp = 'image/bmp'
        txt = 'text/plain'
        md = 'text/plain'
        log = 'text/plain'
        doc = 'application/msword'
        js = 'text/js'
        swf = 'application/x-shockwave-flash'
        mp3 = 'audio/mpeg'
        zip = 'application/zip'
        rar = 'application/rar'
        tar = 'application/tar'
        arj = 'application/arj'
        cab = 'application/cab'
        html = 'text/html'
        htm = 'text/html'
    }
    if ($File.PSIsContainer) {
        'application/vnd.google-apps.folder'
    }
    elseif ($mime = $mimeHash[$file.Extension]) {
        $mime
    }
    else {
        'application/octet-stream'
    }
}