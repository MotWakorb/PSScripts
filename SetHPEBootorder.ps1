<#
The intent of this script is to make it so that you can input a large number of ILO IP addresses and change the boot order by selecting in a menu with zero downtime.
#>
param(
[Parameter(Mandatory=$True)]
    [string[]]$IPAddress,
[Parameter(Mandatory=$False)]
    [switch]$DebugMode
)

if (Get-Module -ListAvailable -Name HPEiLOCmdlets) {
    write-host "HPE iLO Tools Found, Continuing." -ForegroundColor Cyan
} else {
    Write-Host "HPE iLO Tools not found.  Installing. If you are asked to install NuGet, choose Yes." -ForegroundColor Cyan
    Install-Module -Name "HPEiLOCmdlets" -Scope CurrentUser -Force -Confirm:$false
}

$credentials = Get-Credential -Message "Login for HPE ILO Connection"

foreach ($ip in $IPAddress) {
    $connection = Connect-HPEiLO -IP $ip -Username $credentials.UserName -Password $credentials.GetNetworkCredential().Password -DisableCertificateAuthentication
    $result = Get-HPEiLOPersistentBootOrder -Connection $connection
    Write-Host "Here is the current boot order for $ip :"
    $existingbootorder = $result.BootOrder
    $existingbootorder
    Write-Host
    Write-Host "Please select the boot device you want to set as the primary boot:"
    $i = 1
    $obj = 0
    foreach ($boot in $existingbootorder)
    {
        Write-Host "$($i)." $existingbootorder[$obj]
        $i++
        $obj++
    }
    $bootordernum = Read-Host -Prompt "Enter the number you want to boot from"
    $bootordernum = $bootordernum - 1
    if ($DebugMode -eq $true) 
    {
        Write-Host "Debug mode on, your boot object is:" $existingbootorder[$bootordernum]
    } else {
        Set-HPEiLOPersistentBootOrder -Connection $connection -BootOrder $$existingbootorder[$bootordernum]
        Write-Host "Here is the new boot order:"
        $newresult = Get-HPEiLOPersistentBootOrder -Connection $connection
        $WriteBootOrder = $newresult.BootOrder
        $WriteBootOrder
        }
    Disconnect-HPEiLO -Connection $connection
}