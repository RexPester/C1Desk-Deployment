:: INFO:
	:: C1Desk ID & Server Changer (Portable & Installed Compatible)

::===============================================================================================================
@echo off
mode con:cols=90 lines=45
title C1Desk ID ^& Server Changer v3.1

:: Language check via Get-UICulture (Display Language)
for /f "delims=" %%a in ('powershell -NoProfile -Command "(Get-UICulture).TwoLetterISOLanguageName"') do set OS_LANG=%%a
set LANG_TR=0
if /i "%OS_LANG%"=="tr" set LANG_TR=1

net file 1>nul 2>nul && goto :Main || powershell -ex unrestricted -Command "Start-Process -Verb RunAs -FilePath '%comspec%' -ArgumentList '/c ""%~fnx0""""'"
goto :eof
::===============================================================================================================
:Main
cls

set "C1DESK_EXE="
if exist "%~dp0C1Desk.exe" set "C1DESK_EXE=%~dp0C1Desk.exe"
if not defined C1DESK_EXE if exist "C:\Program Files\C1Desk\C1Desk.exe" set "C1DESK_EXE=C:\Program Files\C1Desk\C1Desk.exe"

if defined C1DESK_EXE (
  for /f "delims=" %%i in ('"%C1DESK_EXE%" --get-id ^| more') do set c1desk_id=%%i
  goto :Run
) else (
echo.
if %LANG_TR%==1 (
echo C1Desk.exe bulunamadç. LÅtfen bu betigi C1Desk.exe ile aynç klasîre koyun veya C1Desk'i kurun.
echo.
echo Äçkçü iáin herhangi bir tuüa basçn.
) else (
echo C1Desk.exe was not found in current folder or C:\Program Files\C1Desk.
echo Please place this batch script in the same folder as portable C1Desk.exe or install C1Desk.
echo.
echo Press any key to exit.
)
pause >nul
exit
)
:Run
pushd %temp% >nul 2>&1
echo.
echo ==========================================================================================
echo.
if %LANG_TR%==1 goto Menu_TR
goto Menu_EN

:Menu_TR
echo			  C1Desk ID ^& Server Changer
echo.
echo.
echo	 	  1 - C1Desk ID'sini bilgisayar adçyla deßistir : "%computername%"
echo.
echo	 	  2 - C1Desk ID'sini 9 haneli rastgele sayçlarla deßistir
echo.
echo	 	  3 - C1Desk ID'sini belirttißiniz deßere ayarlayçn.
echo.
echo.	-----------------------------------------------------------------
echo.
echo	 	  4 - Public Sunucuya Geá (Private Sunucu Bilgisini Temizle)
echo.
echo	 	  5 - Private Sunucuya Geá (Private Sunucu Bilgisini Uygula)
echo.
echo	 	  6 - Yeni Private Sunucu Tançmla 
echo.
echo	 	  7 - Private Sunucu Yedeklerini Sil 
echo.
echo	 	  8 - ÄIKIû
echo.
echo ==========================================================================================
echo.
choice /c 12345678 /cs /n /m "Seáiminiz [1-2-3-4-5-6-7-8] : "
goto Menu_Choice

:Menu_EN
echo			  C1Desk ID ^& Server Changer
echo.
echo.
echo	 	  1 - Set C1Desk ID with computer name : "%computername%"
echo.
echo	 	  2 - Set C1Desk ID with 9-digit random numbers
echo.
echo	 	  3 - Set C1Desk ID to the value you specify
echo.
echo.	-----------------------------------------------------------------
echo.
echo	 	  4 - Set Public Server (Clear Custom Server Info)
echo.
echo	 	  5 - Set Private Server (Apply Custom Server Info)
echo.
echo	 	  6 - Set New Private Server
echo.
echo	 	  7 - Delete Custom Server Backups
echo.
echo	 	  8 - Exit
echo.
echo ==========================================================================================
echo.
choice /c 12345678 /cs /n /m "Your Choice [1-2-3-4-5-6-7-8] : "
goto Menu_Choice

:Menu_Choice
echo.
if errorlevel 8 Exit
if errorlevel 7 goto :Delete_Backups
if errorlevel 6 goto :Server_Private_New
if errorlevel 5 goto :Server_Private
if errorlevel 4 goto :Server_Public
if errorlevel 3 goto :ID_UserDefined
if errorlevel 2 goto :ID_Random
if errorlevel 1 goto :ID_Host
echo.
::===============================================================================================================
:ID_Host
echo.
echo $svc = Get-Service -Name C1Desk -ErrorAction SilentlyContinue > C1Desk_ID_Host.ps1
echo if ($svc) { Stop-Service -Name C1Desk -Force -ErrorAction SilentlyContinue; Start-Sleep -Seconds 1 } >> C1Desk_ID_Host.ps1
echo Stop-Process -Name "C1Desk" -Force -ErrorAction SilentlyContinue >> C1Desk_ID_Host.ps1
echo Start-Sleep -Seconds 1 >> C1Desk_ID_Host.ps1
echo $hostname = hostname >> C1Desk_ID_Host.ps1
echo $newId = "id = '$hostname'" >> C1Desk_ID_Host.ps1
echo $paths = @("C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\C1Desk\config\C1Desk.toml", "$env:APPDATA\C1Desk\config\C1Desk.toml") >> C1Desk_ID_Host.ps1
echo Write-Host "Current ID: %c1desk_id%" >> C1Desk_ID_Host.ps1
echo Write-Host "New ID: $hostname" >> C1Desk_ID_Host.ps1
echo foreach ($path in $paths) { >> C1Desk_ID_Host.ps1
echo     if (Test-Path $path) { >> C1Desk_ID_Host.ps1
echo         $content = Get-Content -Path $path >> C1Desk_ID_Host.ps1
echo         if ($content) { >> C1Desk_ID_Host.ps1
echo             $id = $content[0] >> C1Desk_ID_Host.ps1
echo             $newContent = $content -replace [regex]::Escape($id), $newId >> C1Desk_ID_Host.ps1
echo             $newContent ^| Set-Content -Path $path >> C1Desk_ID_Host.ps1
echo         } >> C1Desk_ID_Host.ps1
echo     } >> C1Desk_ID_Host.ps1
echo } >> C1Desk_ID_Host.ps1
echo if ($svc) { Start-Service -Name C1Desk -ErrorAction SilentlyContinue } >> C1Desk_ID_Host.ps1
powershell.exe -ExecutionPolicy Bypass -File C1Desk_ID_Host.ps1
start "" "%C1DESK_EXE%" --tray
goto :done
::===============================================================================================================
:ID_Random
echo.
echo $svc = Get-Service -Name C1Desk -ErrorAction SilentlyContinue > C1Desk_ID_Random.ps1
echo if ($svc) { Stop-Service -Name C1Desk -Force -ErrorAction SilentlyContinue; Start-Sleep -Seconds 1 } >> C1Desk_ID_Random.ps1
echo Stop-Process -Name "C1Desk" -Force -ErrorAction SilentlyContinue >> C1Desk_ID_Random.ps1
echo Start-Sleep -Seconds 1 >> C1Desk_ID_Random.ps1
echo $randomId = -join ((48..57) ^| Get-Random -Count 9 ^| ForEach-Object {[char]$_}) >> C1Desk_ID_Random.ps1
echo $newId = "id = '$randomId'" >> C1Desk_ID_Random.ps1
echo $paths = @("C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\C1Desk\config\C1Desk.toml", "$env:APPDATA\C1Desk\config\C1Desk.toml") >> C1Desk_ID_Random.ps1
echo Write-Host "Current ID: %c1desk_id%" >> C1Desk_ID_Random.ps1
echo Write-Host "New ID: $randomId" >> C1Desk_ID_Random.ps1
echo foreach ($path in $paths) { >> C1Desk_ID_Random.ps1
echo     if (Test-Path $path) { >> C1Desk_ID_Random.ps1
echo         $content = Get-Content -Path $path >> C1Desk_ID_Random.ps1
echo         if ($content) { >> C1Desk_ID_Random.ps1
echo             $id = $content[0] >> C1Desk_ID_Random.ps1
echo             $newContent = $content -replace [regex]::Escape($id), $newId >> C1Desk_ID_Random.ps1
echo             $newContent ^| Set-Content -Path $path >> C1Desk_ID_Random.ps1
echo         } >> C1Desk_ID_Random.ps1
echo     } >> C1Desk_ID_Random.ps1
echo } >> C1Desk_ID_Random.ps1
echo if ($svc) { Start-Service -Name C1Desk -ErrorAction SilentlyContinue } >> C1Desk_ID_Random.ps1
powershell.exe -ExecutionPolicy Bypass -File C1Desk_ID_Random.ps1
start "" "%C1DESK_EXE%" --tray
goto :done
::===============================================================================================================
:ID_UserDefined
echo.
  ver | findstr /c:"Version 10." >nul
  if errorlevel 1 (
      if %LANG_TR%==1 (
          echo Hata: Bu seáenek sadece Windows 10 ve Åzeri sÅrÅmlerde desteklenmektedir!
      ) else (
          echo Error: This option is only supported on Windows 10 and later!
      )
      timeout /t 5 >nul
      goto :Main
  )
echo $svc = Get-Service -Name C1Desk -ErrorAction SilentlyContinue > C1Desk_ID_UserDefined.ps1
echo if ($svc) { Stop-Service -Name C1Desk -Force -ErrorAction SilentlyContinue; Start-Sleep -Seconds 1 } >> C1Desk_ID_UserDefined.ps1
echo Stop-Process -Name "C1Desk" -Force -ErrorAction SilentlyContinue >> C1Desk_ID_UserDefined.ps1
echo Start-Sleep -Seconds 1 >> C1Desk_ID_UserDefined.ps1
  if %LANG_TR%==1 (
  echo YENI C1DESK ID DEGERI EN AZ 6 KARAKTER OLMALIDIR
  timeout /t 2 >nul 2>&1
  echo.
  goto Ask_ID_TR
  ) else (
  echo THE NEW C1DESK ID VALUE MUST BE AT LEAST 6 CHARACTERS
  timeout /t 2 >nul 2>&1
  echo.
  goto Ask_ID_EN
  )

:Ask_ID_TR
set "C1DESK_NEW_ID="
set /p C1DESK_NEW_ID="C1Desk ID Girin (En az 6 karakter): "
if not defined C1DESK_NEW_ID (
    echo Hata: ID bos olamaz!
    echo.
    goto Ask_ID_TR
)
if "%C1DESK_NEW_ID:~5,1%"=="" (
    echo Hata: ID en az 6 karakter olmalidir!
    echo.
    goto Ask_ID_TR
)
goto ID_UserDefined_Continue

:Ask_ID_EN
set "C1DESK_NEW_ID="
set /p C1DESK_NEW_ID="Enter C1Desk ID (At least 6 characters): "
if not defined C1DESK_NEW_ID (
    echo Error: ID cannot be empty!
    echo.
    goto Ask_ID_EN
)
if "%C1DESK_NEW_ID:~5,1%"=="" (
    echo Error: ID must be at least 6 characters!
    echo.
    goto Ask_ID_EN
)
goto ID_UserDefined_Continue

:ID_UserDefined_Continue
echo Write-Host "Current ID: %c1desk_id%" >> C1Desk_ID_UserDefined.ps1
echo $newId = "id = '%C1DESK_NEW_ID%'" >> C1Desk_ID_UserDefined.ps1
echo Write-Host "New ID: %C1DESK_NEW_ID%" >> C1Desk_ID_UserDefined.ps1
echo $paths = @("C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\C1Desk\config\C1Desk.toml", "$env:APPDATA\C1Desk\config\C1Desk.toml") >> C1Desk_ID_UserDefined.ps1
echo foreach ($path in $paths) { >> C1Desk_ID_UserDefined.ps1
echo     if (Test-Path $path) { >> C1Desk_ID_UserDefined.ps1
echo         $content = Get-Content -Path $path >> C1Desk_ID_UserDefined.ps1
echo         if ($content) { >> C1Desk_ID_UserDefined.ps1
echo             $id = $content[0] >> C1Desk_ID_UserDefined.ps1
echo             $newContent = $content -replace [regex]::Escape($id), $newId >> C1Desk_ID_UserDefined.ps1
echo             $newContent ^| Set-Content -Path $path >> C1Desk_ID_UserDefined.ps1
echo         } >> C1Desk_ID_UserDefined.ps1
echo     } >> C1Desk_ID_UserDefined.ps1
echo } >> C1Desk_ID_UserDefined.ps1
echo if ($svc) { Start-Service -Name C1Desk -ErrorAction SilentlyContinue } >> C1Desk_ID_UserDefined.ps1
powershell.exe -ExecutionPolicy Bypass -File C1Desk_ID_UserDefined.ps1
start "" "%C1DESK_EXE%" --tray
goto :done
::===============================================================================================================
:Server_Public
echo.
echo $isPublic = $true > check_public.ps1
echo $paths = @("C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\C1Desk\config\C1Desk2.toml", "$env:APPDATA\C1Desk\config\C1Desk2.toml") >> check_public.ps1
echo foreach ($path in $paths) { if (Test-Path $path) { $content = Get-Content $path; if (($content -match "^custom-rendezvous-server") -or ($content -match "^api-server") -or ($content -match "^custom-rs-server")) { $isPublic = $false } } } >> check_public.ps1
echo if ($isPublic) { exit 1 } else { exit 0 } >> check_public.ps1
powershell.exe -ExecutionPolicy Bypass -File check_public.ps1
if errorlevel 1 (
    del check_public.ps1 >nul 2>&1
    if %LANG_TR%==1 (
        echo Zaten Public Sunucu kullançyorsunuz. òülem yapçlmadç.
    ) else (
        echo You are already using the Public Server. No action taken.
    )
    goto :done
)
del check_public.ps1 >nul 2>&1

echo $svc = Get-Service -Name C1Desk -ErrorAction SilentlyContinue > C1Desk_Server_Public.ps1
echo if ($svc) { Stop-Service -Name C1Desk -Force -ErrorAction SilentlyContinue; Start-Sleep -Seconds 1 } >> C1Desk_Server_Public.ps1
echo Stop-Process -Name "C1Desk" -Force -ErrorAction SilentlyContinue >> C1Desk_Server_Public.ps1
echo Start-Sleep -Seconds 1 >> C1Desk_Server_Public.ps1
echo $paths = @("C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\C1Desk\config\C1Desk2.toml", "$env:APPDATA\C1Desk\config\C1Desk2.toml") >> C1Desk_Server_Public.ps1
echo foreach ($path in $paths) { >> C1Desk_Server_Public.ps1
echo     if (Test-Path $path) { >> C1Desk_Server_Public.ps1
echo         $content = Get-Content $path >> C1Desk_Server_Public.ps1
echo         $hasCustom = ($content -match "^custom-rendezvous-server" -or $content -match "^api-server" -or $content -match "^custom-rs-server") >> C1Desk_Server_Public.ps1
echo         if ($hasCustom) { Copy-Item -Path $path -Destination "$path.backup" -Force; if (-not (Test-Path "$path.backup")) { exit 3 } } >> C1Desk_Server_Public.ps1
echo         $newContent = $content -replace "^custom-rendezvous-server.*", "" >> C1Desk_Server_Public.ps1
echo         $newContent = $newContent -replace "^custom-rs-server.*", "" >> C1Desk_Server_Public.ps1
echo         $newContent = $newContent -replace "^api-server.*", "" >> C1Desk_Server_Public.ps1
echo         $newContent = $newContent -replace "^custom-api-server.*", "" >> C1Desk_Server_Public.ps1
echo         $newContent = $newContent -replace "^key.*", "" >> C1Desk_Server_Public.ps1
echo         $newContent = $newContent ^| Where-Object { $_.Trim() -ne "" } >> C1Desk_Server_Public.ps1
echo         $newContent ^| Set-Content $path >> C1Desk_Server_Public.ps1
echo     } >> C1Desk_Server_Public.ps1
echo } >> C1Desk_Server_Public.ps1
echo if ($svc) { Start-Service -Name C1Desk -ErrorAction SilentlyContinue } >> C1Desk_Server_Public.ps1
powershell.exe -ExecutionPolicy Bypass -File C1Desk_Server_Public.ps1
if errorlevel 3 (
    if %LANG_TR%==1 (
        echo Yedekleme sçrasçnda bir hata olustu. òzinleri kontrol edin. òüleme devam edilemedi.
    ) else (
        echo An error occurred during backup. Check permissions. Process aborted.
    )
    goto :done
)
start "" "%C1DESK_EXE%" --tray
echo.
if %LANG_TR%==1 (
echo Mevcut private sunucu ayarlarç yedeklendi ve Public sunucuya geáildi.
) else (
echo Current custom server settings backed up and switched to Public server.
)
goto :done
::===============================================================================================================
:Server_Private
echo.
echo $isPrivate = $false > check_private.ps1
echo $hasBackup = $false >> check_private.ps1
echo $paths = @("C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\C1Desk\config\C1Desk2.toml", "$env:APPDATA\C1Desk\config\C1Desk2.toml") >> check_private.ps1
echo foreach ($path in $paths) { if (Test-Path $path) { $content = Get-Content $path; if (($content -match "^custom-rendezvous-server") -or ($content -match "^api-server") -or ($content -match "^custom-rs-server")) { $isPrivate = $true } } ; if (Test-Path "$path.backup") { $hasBackup = $true } } >> check_private.ps1
echo if ($isPrivate) { exit 1 } elseif (-not $hasBackup) { exit 2 } else { exit 0 } >> check_private.ps1
powershell.exe -ExecutionPolicy Bypass -File check_private.ps1
if errorlevel 2 (
    del check_private.ps1 >nul 2>&1
    if %LANG_TR%==1 (
        echo Sistemde kayçtlç bir Private Sunucu yedeßi bulunamadç.
        echo LÅtfen înce C1Desk Åzerinden Private Sunucu bilgilerinizi girip baßlançn.
    ) else (
        echo No Private Server backup found in the system.
        echo Please configure your Private Server in C1Desk first.
    )
    goto :done
)
if errorlevel 1 (
    del check_private.ps1 >nul 2>&1
    if %LANG_TR%==1 (
        echo Zaten Private Sunucu kullançyorsunuz. òülem yapçlmadç.
    ) else (
        echo You are already using the Private Server. No action taken.
    )
    goto :done
)
del check_private.ps1 >nul 2>&1

echo $svc = Get-Service -Name C1Desk -ErrorAction SilentlyContinue > C1Desk_Server_Private.ps1
echo if ($svc) { Stop-Service -Name C1Desk -Force -ErrorAction SilentlyContinue; Start-Sleep -Seconds 1 } >> C1Desk_Server_Private.ps1
echo Stop-Process -Name "C1Desk" -Force -ErrorAction SilentlyContinue >> C1Desk_Server_Private.ps1
echo Start-Sleep -Seconds 1 >> C1Desk_Server_Private.ps1
echo $paths = @("C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\C1Desk\config\C1Desk2.toml", "$env:APPDATA\C1Desk\config\C1Desk2.toml") >> C1Desk_Server_Private.ps1
echo foreach ($path in $paths) { >> C1Desk_Server_Private.ps1
echo     $backupPath = "$path.backup" >> C1Desk_Server_Private.ps1
echo     if (Test-Path $backupPath) { Copy-Item -Path $backupPath -Destination $path -Force } >> C1Desk_Server_Private.ps1
echo } >> C1Desk_Server_Private.ps1
echo if ($svc) { Start-Service -Name C1Desk -ErrorAction SilentlyContinue } >> C1Desk_Server_Private.ps1
powershell.exe -ExecutionPolicy Bypass -File C1Desk_Server_Private.ps1
start "" "%C1DESK_EXE%" --tray
echo.
if %LANG_TR%==1 (
echo Yedeklenen Private Sunucu ayarlarç geri yÅklendi.
) else (
echo Backed up Custom Server settings restored.
)
goto :done
::===============================================================================================================
:Server_Private_New
echo.
echo $isPrivate = $false > check_private_new.ps1
echo $paths = @("C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\C1Desk\config\C1Desk2.toml", "$env:APPDATA\C1Desk\config\C1Desk2.toml") >> check_private_new.ps1
echo foreach ($path in $paths) { if (Test-Path $path) { $content = Get-Content $path; if (($content -match "^custom-rendezvous-server") -or ($content -match "^api-server") -or ($content -match "^custom-rs-server")) { $isPrivate = $true } } } >> check_private_new.ps1
echo if ($isPrivate) { exit 1 } else { exit 0 } >> check_private_new.ps1
powershell.exe -ExecutionPolicy Bypass -File check_private_new.ps1
if errorlevel 1 (
    del check_private_new.ps1 >nul 2>&1
    if %LANG_TR%==1 (
        echo Private Sunucu zaten yapçlandçrçlmçü durumda. LÅtfen înce genel sunucuya geámek ve mevcut ayarlarç yedeklemek iáin 4. seáeneßi kullançn.
    ) else (
        echo A Private Server is already configured. Please use option 4 to switch to Public server first and backup existing settings.
    )
    goto :done
)
del check_private_new.ps1 >nul 2>&1

if %LANG_TR%==1 goto Server_Private_New_TR
goto Server_Private_New_EN

:Server_Private_New_TR
echo LÅtfen yeni Private Sunucu (Rendezvous Server) IP veya Host adresini girin.
set /p RS_HOST="Sunucu Adresi (Orn: 192.168.1.100 veya hb.sunucum.com): "
echo.
echo LÅtfen Key (ûifre) bilgisini girin. Eßer key yoksa bos bçrakçp ENTER'a basin.
set /p RS_KEY="Key (Opsiyonel): "
goto Server_Private_New_Proceed

:Server_Private_New_EN
echo Please enter the new Private Server (Rendezvous Server) IP or Host address.
set /p RS_HOST="Server Address (e.g. 192.168.1.100 or hb.example.com): "
echo.
echo Please enter the Key. If no key is required, leave blank and press ENTER.
set /p RS_KEY="Key (Optional): "
goto Server_Private_New_Proceed

:Server_Private_New_Proceed
echo.
echo $svc = Get-Service -Name C1Desk -ErrorAction SilentlyContinue > C1Desk_Server_Private_New.ps1
echo if ($svc) { Stop-Service -Name C1Desk -Force -ErrorAction SilentlyContinue; Start-Sleep -Seconds 1 } >> C1Desk_Server_Private_New.ps1
echo Stop-Process -Name "C1Desk" -Force -ErrorAction SilentlyContinue >> C1Desk_Server_Private_New.ps1
echo Start-Sleep -Seconds 1 >> C1Desk_Server_Private_New.ps1
echo $paths = @("C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\C1Desk\config\C1Desk2.toml", "$env:APPDATA\C1Desk\config\C1Desk2.toml") >> C1Desk_Server_Private_New.ps1
echo foreach ($path in $paths) { >> C1Desk_Server_Private_New.ps1
echo     $dir = Split-Path $path >> C1Desk_Server_Private_New.ps1
echo     if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force } >> C1Desk_Server_Private_New.ps1
echo     if (-not (Test-Path $path)) { "" ^| Set-Content $path } >> C1Desk_Server_Private_New.ps1
echo     $newContent = Get-Content $path >> C1Desk_Server_Private_New.ps1
echo     $newContent = $newContent ^| Where-Object { $_.Trim() -ne "" } >> C1Desk_Server_Private_New.ps1
echo     $newContent += "custom-rendezvous-server = '%RS_HOST%'" >> C1Desk_Server_Private_New.ps1
echo     $newContent += "key = '%RS_KEY%'" >> C1Desk_Server_Private_New.ps1
echo     $newContent ^| Set-Content $path >> C1Desk_Server_Private_New.ps1
echo } >> C1Desk_Server_Private_New.ps1
echo if ($svc) { Start-Service -Name C1Desk -ErrorAction SilentlyContinue } >> C1Desk_Server_Private_New.ps1
powershell.exe -ExecutionPolicy Bypass -File C1Desk_Server_Private_New.ps1
start "" "%C1DESK_EXE%" --tray
echo.
if %LANG_TR%==1 (
echo Yeni Private Sunucu baüarçyla tançmlandç ve C1Desk yeniden baülatçldç.
) else (
echo New Private Server successfully configured and C1Desk restarted.
)
goto :done
::===============================================================================================================
:Delete_Backups
echo.
del /f /q "%APPDATA%\C1Desk\config\C1Desk2.toml.backup" >nul 2>&1
del /f /q "C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\C1Desk\config\C1Desk2.toml.backup" >nul 2>&1
if %LANG_TR%==1 (
echo Private Sunucu yedekleri baüarçyla silindi!
) else (
echo Custom Server backups deleted successfully!
)
goto :done
::===============================================================================================================
:done
del C1Desk_ID_Host.ps1 >nul 2>&1
del C1Desk_ID_Random.ps1 >nul 2>&1
del C1Desk_ID_UserDefined.ps1 >nul 2>&1
del C1Desk_Server_Public.ps1 >nul 2>&1
del C1Desk_Server_Private.ps1 >nul 2>&1
del C1Desk_Server_Private_New.ps1 >nul 2>&1
echo.
if %LANG_TR%==1 (
echo	 òûLEM TAMAMLANDI
echo.
choice /C:MX /N /M "ANA MENö icin M, ÄIKIû icin X tuüuna basçn: "
) else (
echo	 PROCESS COMPLETED
echo.
choice /C:MX /N /M "Press M for MAIN MENU -- X for EXIT: "
)
if errorlevel 2 Exit
if errorlevel 1 goto :Main
::===============================================================================================================
