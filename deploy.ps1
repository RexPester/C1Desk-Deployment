#Requires -RunAsAdministrator

$ErrorActionPreference = "SilentlyContinue"

# 1. Stop Existing Services & Processes
$ServiceNames = @("C1Desk", "C1_RustDesk", "RustDesk")
foreach ($svc in $ServiceNames) {
    Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
}

$ProcessNames = @("C1Desk", "C1_RustDesk", "rustdesk")
foreach ($proc in $ProcessNames) {
    Stop-Process -Name $proc -Force -ErrorAction SilentlyContinue
}

# 2. Uninstall Previous Executables
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

# Ensure all remaining process handles created by uninstallers are closed
foreach ($proc in $ProcessNames) {
    Stop-Process -Name $proc -Force -ErrorAction SilentlyContinue
}

# 3. Clear Stale Configurations & Data
$ConfigPaths = @(
    "$env:APPDATA\RustDesk",
    "$env:APPDATA\C1Tech-Support",
    "$env:APPDATA\C1Desk",
    "C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\RustDesk",
    "C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\C1Tech-Support",
    "C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\C1Desk"
)

foreach ($path in $ConfigPaths) {
    if (Test-Path $path) {
        Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# 4. Download Latest Installer Over TLS 1.2
$DownloadUrl = "https://github.com/RexPester/C1Desk-Deployment/releases/latest/download/C1Desk.exe"
$InstallerPath = "$env:TEMP\C1Desk.exe"

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri $DownloadUrl -OutFile $InstallerPath -UseBasicParsing

# 5. Perform Silent Installation & Launch GUI
if (Test-Path $InstallerPath) {
    # --install installs the app and service
    # --create-shortcut ensures Desktop and Start Menu shortcuts are created
    $installProcess = Start-Process -FilePath $InstallerPath -ArgumentList "--install", "--create-shortcut" -PassThru -NoNewWindow
    
    # Wait up to 30 seconds for the installer file operations to complete
    $installProcess | Wait-Process -Timeout 30 -ErrorAction SilentlyContinue
    
    Start-Sleep -Seconds 3
    Remove-Item -Path $InstallerPath -Force -ErrorAction SilentlyContinue
}

# 6. Launch C1Desk Graphical Interface & Tray
$InstalledExe = "${env:ProgramFiles}\C1Desk\C1Desk.exe"
if (-not (Test-Path $InstalledExe)) {
    $InstalledExe = "${env:ProgramFiles(x86)}\C1Desk\C1Desk.exe"
}

if (Test-Path $InstalledExe) {
    # Launch main application window into current user session
    Start-Process -FilePath $InstalledExe
}
