@echo off
title Legend of LuWa - Install + Lag Fix

rem ============================================================
rem  Self-elevate to administrator (needed to write the fix
rem  into Program Files). If we are not admin, relaunch elevated.
rem ============================================================
net session >nul 2>&1
if %errorlevel%==0 goto elevated
echo Requesting administrator access...
powershell -NoProfile -Command "Start-Process -Verb RunAs -FilePath '%~f0'"
exit /b

:elevated
cd /d "%~dp0"
cls
echo ===========================================================
echo    Legend of LuWa  -  Install + Lag Fix  ^(all in one^)
echo ===========================================================
echo.
echo  STEP 1 of 2 - Installing the game.
echo  The setup wizard will open. Just complete it normally;
echo  the default install location is recommended.
echo.
echo  Press any key to start the installer...
pause >nul

start /wait "" "%~dp0setup.exe"

echo.
echo  STEP 2 of 2 - Applying the lag fix...
echo.

set /a attempt=0
:detect
set "GAMEDIR="
if exist "%ProgramFiles%\LegendOfLuwa\Luwa.exe" set "GAMEDIR=%ProgramFiles%\LegendOfLuwa"
if exist "%ProgramFiles(x86)%\LegendOfLuwa\Luwa.exe" set "GAMEDIR=%ProgramFiles(x86)%\LegendOfLuwa"
if exist "%ProgramW6432%\LegendOfLuwa\Luwa.exe" set "GAMEDIR=%ProgramW6432%\LegendOfLuwa"
if exist "%SystemDrive%\LegendOfLuwa\Luwa.exe" set "GAMEDIR=%SystemDrive%\LegendOfLuwa"
if exist "%SystemDrive%\Games\LegendOfLuwa\Luwa.exe" set "GAMEDIR=%SystemDrive%\Games\LegendOfLuwa"
if defined GAMEDIR goto applyfix
set /a attempt+=1
if %attempt% geq 2 goto askpath
echo  The game was not detected yet. If the setup wizard is still
echo  open, finish it now, then press any key to continue...
pause >nul
goto detect

:askpath
echo.
echo  Could not auto-detect the install folder.
echo  Please paste the full path to the folder that contains
echo  Luwa.exe, then press Enter:
set /p "GAMEDIR=Path: "

:applyfix
if not exist "%GAMEDIR%\Luwa.exe" goto notfound

copy /y "%~dp0_fix\ddraw.dll" "%GAMEDIR%\" >nul
copy /y "%~dp0_fix\ddraw.ini" "%GAMEDIR%\" >nul
copy /y "%~dp0_fix\cnc-ddraw config.exe" "%GAMEDIR%\" >nul
xcopy /e /i /y "%~dp0_fix\Shaders" "%GAMEDIR%\Shaders" >nul

echo  Making sure there is a desktop shortcut...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0_fix\make_shortcut.ps1" "%GAMEDIR%"

echo.
echo ===========================================================
echo    All done!  Game installed and lag fix applied.
echo    Folder: %GAMEDIR%
echo    Launch "Legend of LuWa" - the animation will be smooth.
echo ===========================================================
echo.
pause
exit /b 0

:notfound
echo.
echo  [!] Luwa.exe was not found, so the fix was NOT applied.
echo      To apply it by hand: open the "_fix" folder and copy
echo      everything inside it into the game folder, next to Luwa.exe.
echo.
pause
exit /b 1
