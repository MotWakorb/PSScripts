<#

#>

$ipaddresses = "192.168.1.241", "192.168.1.242"
$username = "Administrator"
$password = "XLVP@ck3rs"
$bootorder = "Boot000D"

foreach ($ip in $ipaddresses) {
    $connection = Connect-HPEiLO -IP $ip -Username $username -Password $password -DisableCertificateAuthentication
    $result = Get-HPEiLOPersistentBootOrder -Connection $connection
    Write-Host "Here is the current boot order for $ip :"
    $result.BootOrder
    Set-HPEiLOPersistentBootOrder -Connection $connection -BootOrder $bootorder
    Write-Host "Here is the new boot order:"
    $newresult = Get-HPEiLOPersistentBootOrder -Connection $connection
    $newresult.BootOrder
    Disconnect-HPEiLO -Connection $connection
}