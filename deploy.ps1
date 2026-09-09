# 1. Direct Release Link
$DownloadUrl = "https://github.com/RexPester/C1Desk-Deployment/releases/download/v1.4.9/C1_RustDesk.exe"
$InstallerPath = "$env:TEMP\C1_RustDesk.exe"

# 2. Download Installer Over HTTPS
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri $DownloadUrl -OutFile $InstallerPath -UseBasicParsing

# 3. Explicitly Uninstall Previous Builds
$OldExecutables = @(
    "${env:ProgramFiles}\RustDesk\rustdesk.exe",
    "${env:ProgramFiles}\C1Desk\C1Desk.exe",
    "${env:ProgramFiles}\C1Desk\rustdesk.exe",
    "${env:ProgramFiles}\C1_RustDesk\C1_RustDesk.exe",
    "${env:ProgramFiles(x86)}\RustDesk\rustdesk.exe",
    "${env:ProgramFiles(x86)}\C1Desk\C1Desk.exe"
)

foreach ($exe in $OldExecutables) {
    if (Test-Path $exe) {
        Start-Process -FilePath $exe -ArgumentList "--uninstall" -Wait -NoNewWindow -ErrorAction SilentlyContinue
    }
}

# 4. Stop Remaining Services & Processes
Stop-Service -Name "RustDesk", "C1_RustDesk", "C1Desk" -ErrorAction SilentlyContinue
taskkill /F /IM "rustdesk.exe" /T 2>$null
taskkill /F /IM "C1_RustDesk.exe" /T 2>$null
taskkill /F /IM "C1Desk.exe" /T 2>$null

# 5. Clear Stale Configurations
$ConfigPaths = @(
    "$env:APPDATA\RustDesk\config",
    "$env:APPDATA\C1Tech-Support\config",
    "$env:APPDATA\C1Desk\config",
    "C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\RustDesk\config",
    "C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\C1Tech-Support\config",
    "C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\C1Desk\config"
)

foreach ($path in $ConfigPaths) {
    Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
}

# 6. Run Silent Installation & Cleanup
Start-Process -FilePath $InstallerPath -ArgumentList "--silent-install" -Wait -NoNewWindow
Remove-Item -Path $InstallerPath -Force -ErrorAction SilentlyContinue

# 7. Ensure Service Is Started
Start-Service -Name "RustDesk", "C1_RustDesk", "C1Desk" -ErrorAction SilentlyContinue
