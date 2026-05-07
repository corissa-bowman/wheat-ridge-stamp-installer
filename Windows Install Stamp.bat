@echo off
REM ============================================================
REM  Wheat Ridge Building Approval Stamp - Installer (Windows)
REM ============================================================
REM  Double-click this file to install the stamp.
REM  It must live in the same folder as
REM  "Wheat Ridge Building Approval Stamp.pdf".
REM ============================================================

setlocal EnableExtensions

set "STAMP_FILE=Wheat Ridge Building Approval Stamp.pdf"
set "SCRIPT_DIR=%~dp0"
set "SOURCE_PATH=%SCRIPT_DIR%%STAMP_FILE%"
set "ACROBAT_PARENT=%APPDATA%\Adobe\Acrobat"

echo ============================================================
echo   Wheat Ridge Building Approval Stamp - Installer
echo ============================================================
echo.
echo   Source:        %SOURCE_PATH%
echo   Acrobat data:  %ACROBAT_PARENT%
echo.

REM --- 1. Verify stamp PDF is alongside the installer ---
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

REM --- 2. Quit Acrobat / Reader so it picks up the new stamp on next launch ---
echo Step 1 of 3: Closing Adobe Acrobat / Reader (if running)...
taskkill /IM Acrobat.exe /F  >nul 2>&1
taskkill /IM AcroRd32.exe /F >nul 2>&1
taskkill /IM AcroCEF.exe /F  >nul 2>&1
taskkill /IM Reader.exe /F   >nul 2>&1
ping -n 2 127.0.0.1 >nul 2>&1
echo   Done.
echo.

REM --- 3. Try every known Acrobat version folder + any others detected ---
echo Step 2 of 3: Installing stamp into every Acrobat version folder...
echo.

set /a INSTALLED_COUNT=0
set /a FAILED_COUNT=0

REM Always attempt these three known versions (creates folder if missing).
call :do_install "DC"
call :do_install "2020"
call :do_install "2017"
call :do_install "11.0"

REM Also catch any other version folders that exist (e.g., future versions).
if exist "%ACROBAT_PARENT%\" (
    pushd "%ACROBAT_PARENT%" >nul 2>&1
    if not errorlevel 1 (
        for /f "delims=" %%V in ('dir /b /ad 2^>nul') do (
            if /i not "%%V"=="DC"   if /i not "%%V"=="2020" if /i not "%%V"=="2017" if /i not "%%V"=="11.0" call :do_install "%%V"
        )
        popd >nul 2>&1
    )
)

echo ============================================================
if %FAILED_COUNT% EQU 0 (
    echo   Success! Installed into %INSTALLED_COUNT% Stamps folder^(s^).
) else (
    echo   Done. Installed: %INSTALLED_COUNT%  ^|  Failed: %FAILED_COUNT%
)
echo ============================================================
echo.
echo Step 3 of 3: Next steps for the user
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

if %FAILED_COUNT% GTR 0 ( exit /b 1 )
exit /b 0


REM ============================================================
REM  Subroutine: do_install  <version-folder-name>
REM  Creates %ACROBAT_PARENT%\<version>\Stamps if missing,
REM  copies the stamp PDF into it, and prints what it did.
REM ============================================================
:do_install
set "VER=%~1"
set "STAMPS_DIR=%ACROBAT_PARENT%\%VER%\Stamps"
set "DEST_PATH=%STAMPS_DIR%\%STAMP_FILE%"

echo   [%VER%]
echo     Target: %DEST_PATH%

if not exist "%STAMPS_DIR%\" (
    mkdir "%STAMPS_DIR%" 2>nul
    if not exist "%STAMPS_DIR%\" (
        echo     ERROR: Could not create folder.
        set /a FAILED_COUNT+=1
        echo.
        goto :eof
    )
    echo     Created folder.
)

if exist "%DEST_PATH%" echo     Replacing existing stamp...

copy /Y "%SOURCE_PATH%" "%DEST_PATH%" >nul
if not exist "%DEST_PATH%" (
    echo     ERROR: Copy did not produce destination file.
    set /a FAILED_COUNT+=1
    echo.
    goto :eof
)

echo     OK.
set /a INSTALLED_COUNT+=1
echo.
goto :eof
