@echo off
setlocal enabledelayedexpansion

if "%~1"=="" (
  echo Usage: killport [port]
  exit /b 1
)

set PORT=%~1

echo 🔍 Checking port %PORT%...

for /f "tokens=5" %%a in ('netstat -ano ^| findstr :%PORT%') do (
  set PID=%%a
  echo ❌ Killing process with PID !PID! on port %PORT%...
  taskkill /PID !PID! /F >nul 2>&1
)

echo ✅ Done. Port %PORT% is now free.
endlocal
