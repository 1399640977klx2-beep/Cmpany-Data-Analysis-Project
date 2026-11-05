@echo off
setlocal
cd /d "%~dp0MetrologyWorkspace"
if not exist ".venv\Scripts\python.exe" (
    echo Project virtual environment was not found.
    pause
    exit /b 1
)
".venv\Scripts\python.exe" main.py
set "APP_EXIT_CODE=%ERRORLEVEL%"
if not "%APP_EXIT_CODE%"=="0" (
    echo.
    echo Metrology Workspace exited with code %APP_EXIT_CODE%.
    pause
)
exit /b %APP_EXIT_CODE%
