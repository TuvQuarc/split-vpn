$ScriptPath = (Split-Path $MyInvocation.MyCommand.Path -Parent) + "\"
$SitesFilename = $ScriptPath + "sites.txt"
$TempFilename = $ScriptPath + "temp.txt"
$NotifyScriptFileName = $ScriptPath + "notify.ps1"
$VPNConnectionName = "Place your VPN connection name here"

if ((Get-VpnConnection -Name $VPNConnectionName).ConnectionStatus -eq "Connected") {
    rasdial $VPNConnectionName /DISCONNECT
}

$IsSplitTunnelingEnabled = (Get-VpnConnection -Name $VPNConnectionName).SplitTunneling

if ( -not ($IsSplitTunnelingEnabled)) {
   Set-VpnConnection -Name $VPNConnectionName -SplitTunneling $True
}

$Routes = (Get-VpnConnection -Name $VPNConnectionName).routes
foreach($Route in $Routes) {
    Remove-VpnConnectionRoute -ConnectionName $VPNConnectionName -DestinationPrefix $Route.DestinationPrefix
}

foreach($Site in Get-Content $SitesFilename) {
    try {
        $Addresses = [System.Net.Dns]::GetHostAddresses($Site)
        foreach($Address in $Addresses) {
            Add-VpnConnectionRoute -ConnectionName $VPNConnectionName -DestinationPrefix "$($Address.IPAddressToString)/32"
        }
        $Site >> $TempFilename
    }
    catch {
        Write-Output ("Can't resolve " + $Site)
    }
}

$CurrentDate = Get-Date
$OldestZipDate = $CurrentDate.AddDays(-30)
$OldestZipFilename = $SitesFilename + "-" + $OldestZipDate.toString("yyyyMMdd") + ".zip"
try {
    Remove-Item -Path $OldestZipFilename -Force
}
catch {
    Write-Output "Can't delete " + $OldestZipFilename
}
$ZipName = $SitesFilename + "-" + $CurrentDate.toString("yyyyMMdd") + ".zip"
Compress-Archive -Path $SitesFilename -DestinationPath $ZipName -Update
try {
    Remove-Item -Path $SitesFilename -Force
    Rename-Item -Path $TempFilename -NewName $SitesFilename -Force
}
catch {
    Write-Output "Can't delete " + $SitesFilename + " or rename " + $TempFilename
}

if ((Get-VpnConnection -Name $VPNConnectionName).ConnectionStatus -eq "Disconnected") {
    rasdial $VPNConnectionName
}
