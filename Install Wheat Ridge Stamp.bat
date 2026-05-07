@echo off
REM ============================================================
REM  Wheat Ridge Building Approval Stamp - Installer (Windows)
REM ============================================================
REM  Double-click this file to install the stamp.
REM  It must live in the same folder as
REM  "Wheat Ridge Building Approval Stamp.pdf".
REM
REM  Installs into every Adobe Acrobat / Reader version detected
REM  on this PC (DC, 2020, 2017, 11.0, etc.). If no version has
REM  been launched yet, falls back to the DC stamps folder.
REM ============================================================

setlocal EnableDelayedExpansion

set "STAMP_FILE=Wheat Ridge Building Approval Stamp.pdf"
set "SCRIPT_DIR=%~dp0"
set "SOURCE_PATH=%SCRIPT_DIR%%STAMP_FILE%"
set "ACROBAT_PARENT=%APPDATA%\Adobe\Acrobat"

cls
echo ============================================================
echo   Wheat Ridge Building Approval Stamp - Installer
echo ============================================================
echo.

REM 1. Verify stamp PDF is alongside the installer
if not exist "%SOURCE_PATH%" (
    echo ERROR: Could not find the stamp file.
    echo.
    echo   Looking for: %STAMP_FILE%
    echo   In folder:   %SCRIPT_DIR%
    echo.
    echo Make sure this installer is in the same folder as the stamp PDF,
    echo then try again.
    echo.
    pause
    exit /b 1
)

REM 2. Quit Acrobat / Reader so it picks up the new stamp on next launch
echo Step 1 of 3: Closing Adobe Acrobat / Reader (if running)...
taskkill /IM Acrobat.exe /F >nul 2>&1
taskkill /IM AcroRd32.exe /F >nul 2>&1
taskkill /IM AcroCEF.exe /F >nul 2>&1
taskkill /IM Reader.exe /F >nul 2>&1
timeout /t 1 /nobreak >nul
echo   Done.
echo.

REM 3. Detect installed Acrobat versions (each subdir of %APPDATA%\Adobe\Acrobat is a version)
echo Step 2 of 3: Detecting installed Acrobat versions...

set "VERSIONS="
set "VERSION_COUNT=0"

if exist "%ACROBAT_PARENT%\" (
    for /d %%V in ("%ACROBAT_PARENT%\*") do (
        set "VERSIONS=!VERSIONS! "%%~nxV""
        set /a VERSION_COUNT+=1
    )
)

if %VERSION_COUNT% EQU 0 (
    echo   No existing Acrobat user folders found.
    echo   Falling back to default ^(Acrobat DC^).
    set "VERSIONS="DC""
    set "VERSION_COUNT=1"
) else (
    echo   Found %VERSION_COUNT% version^(s^):!VERSIONS!
)
echo.

REM 4. Copy stamp into each version's Stamps folder
echo Step 3 of 3: Installing the stamp...
echo.

set "INSTALLED_COUNT=0"
set "FAILED_COUNT=0"

for %%V in (%VERSIONS%) do (
    set "VER=%%~V"
    set "STAMPS_DIR=%ACROBAT_PARENT%\!VER!\Stamps"
    set "DEST_PATH=!STAMPS_DIR!\%STAMP_FILE%"

    echo   [!VER!]

    if not exist "!STAMPS_DIR!\" (
        mkdir "!STAMPS_DIR!" >nul 2>&1
        if errorlevel 1 (
            echo     ERROR: Could not create !STAMPS_DIR!
            set /a FAILED_COUNT+=1
            echo.
        ) else (
            echo     Created Stamps folder.
        )
    )

    if exist "!STAMPS_DIR!\" (
        if exist "!DEST_PATH!" (
            echo     Replacing existing stamp with the latest version...
        )
        copy /Y "%SOURCE_PATH%" "!DEST_PATH!" >nul 2>&1
        if errorlevel 1 (
            echo     ERROR: Could not copy stamp to !DEST_PATH!
            set /a FAILED_COUNT+=1
        ) else (
            echo     Installed: !DEST_PATH!
            set /a INSTALLED_COUNT+=1
        )
        echo.
    )
)

echo ============================================================
if %FAILED_COUNT% EQU 0 (
    echo   Success! Installed into %INSTALLED_COUNT% Acrobat version^(s^).
) else (
    echo   Done. Installed: %INSTALLED_COUNT%  ^|  Failed: %FAILED_COUNT%
)
echo ============================================================
echo.
echo Next steps:
echo.
echo   1. Open Adobe Acrobat or Reader.
echo   2. Go to Edit ^> Preferences ^> Identity (Ctrl+K)
echo      and set your Name. The stamp uses this to fill in
echo      the signature line automatically.
echo   3. Open any PDF and use the Stamp tool to apply
echo      "Wheat Ridge Building Approval Stamp".
echo.
echo If the stamp doesn't appear in the menu, fully quit Acrobat
echo and reopen it - stamps are only loaded on startup.
echo.
pause

if %FAILED_COUNT% GTR 0 (
    exit /b 1
)
exit /b 0
