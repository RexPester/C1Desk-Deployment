# 1. Direct Release Link
$DownloadUrl = "https://github.com/RexPester/C1Desk-Deployment/releases/download/v1.4.9/C1_RustDesk.exe"
$InstallerPath = "$env:TEMP\C1_RustDesk.exe"
# 2. Download Installer Over HTTPS
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri $DownloadUrl -OutFile $InstallerPath -UseBasicParsing
# 3. Stop Existing Services & Processes
Stop-Service -Name "RustDesk" -ErrorAction SilentlyContinue
Get-Process -Name "rustdesk" -ErrorAction SilentlyContinue | Stop-Process -Force
Stop-Service -Name "C1_RustDesk" -ErrorAction SilentlyContinue
Get-Process -Name "C1_RustDesk" -ErrorAction SilentlyContinue | Stop-Process -Force
Stop-Service -Name "C1Desk" -ErrorAction SilentlyContinue
Get-Process -Name "C1Desk" -ErrorAction SilentlyContinue | Stop-Process -Force
# 4. Clear Stale Configurations to Enforce Hostname ID & Locks
Remove-Item -Path "$env:APPDATA\RustDesk\config" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\RustDesk\config" -Recurse -Force -ErrorAction SilentlyContinue

# 5. Run Silent Installation & Cleanup
Start-Process -FilePath $InstallerPath -ArgumentList "--silent-install" -Wait -NoNewWindow
Remove-Item -Path $InstallerPath -Force -ErrorAction SilentlyContinue

# 6. Ensure Service Is Started
Start-Service -Name "C1Desk" -ErrorAction SilentlyContinue
