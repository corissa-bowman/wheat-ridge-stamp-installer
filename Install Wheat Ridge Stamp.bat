@echo off
REM ============================================================
REM  Wheat Ridge Building Approval Stamp - Installer (Windows)
REM ============================================================
REM  Double-click this file to install the stamp.
REM  It must live in the same folder as
REM  "Wheat Ridge Building Approval Stamp.pdf".
REM ============================================================

setlocal EnableDelayedExpansion

set "STAMP_FILE=Wheat Ridge Building Approval Stamp.pdf"
set "SCRIPT_DIR=%~dp0"
set "SOURCE_PATH=%SCRIPT_DIR%%STAMP_FILE%"
set "STAMPS_DIR=%APPDATA%\Adobe\Acrobat\DC\Stamps"

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
timeout /t 1 /nobreak >nul
echo   Done.
echo.

REM 3. Create Stamps folder if needed
echo Step 2 of 3: Preparing Stamps folder...
if not exist "%STAMPS_DIR%" (
    mkdir "%STAMPS_DIR%"
    if errorlevel 1 (
        echo ERROR: Could not create the Stamps folder at:
        echo   %STAMPS_DIR%
        echo.
        pause
        exit /b 1
    )
    echo   Created: %STAMPS_DIR%
) else (
    echo   Found:   %STAMPS_DIR%
)
echo.

REM 4. Copy the stamp file
echo Step 3 of 3: Installing the stamp...
set "DEST_PATH=%STAMPS_DIR%\%STAMP_FILE%"

if exist "%DEST_PATH%" (
    echo   A stamp with this name is already installed.
    echo   Replacing it with the latest version...
)

copy /Y "%SOURCE_PATH%" "%DEST_PATH%" >nul
if errorlevel 1 (
    echo ERROR: Could not copy the stamp file.
    echo.
    pause
    exit /b 1
)
echo   Installed: %DEST_PATH%
echo.

echo ============================================================
echo   Success! The stamp is installed.
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
exit /b 0
