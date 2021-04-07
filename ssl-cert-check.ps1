[Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }
$url = "https://www.brechtbaekelandt.net"
Write-Output "[INFO] Checking certificate for URL $($url)."
$req = [Net.HttpWebRequest]::Create($url)
$req.Timeout = 60000

try {
    $resp = $req.GetResponse()
    $expirationDateTimeString = $req.ServicePoint.Certificate.GetExpirationDateString()
    $resp.close();
    $cultureDateTimeFormat = (Get-Culture).DateTimeFormat.ShortDatePattern + " " + (Get-Culture).DateTimeFormat.LongTimePattern
    $expirationDateTime = [DateTime]::ParseExact($expirationDateTimeString,$cultureDateTimeFormat,[System.Globalization.DateTimeFormatInfo]::InvariantInfo,[System.Globalization.DateTimeStyles]::None)
    Write-Output "[INFO] Certificate will expire on $($expirationDateTimeString.ToString())."
    [int]$expirationInDays = ($expirationDateTime - $(Get-Date)).Days

    if($expirationInDays -lt 11)
    {
       Write-Output "[WARNING] Certificate for $($url) will expire in $($expirationInDays) days!"

       exit(1)
    }
    else {
       Write-Output "[INFO] All good!"
    }
}
catch {
    Write-Output "[ERROR] Exception while checking URL $($url)`: $($_)"
}
