@echo off
echo 📋 Algofi Tracker Logs
echo ======================

REM Check if Docker is running
docker info >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker is not running!
    echo Please start Docker Desktop and try again.
    pause
    exit /b 1
)

echo Choose log view:
echo 1. All logs (real-time)
echo 2. Application logs only
echo 3. Last 50 lines
echo 4. Exit
echo.
set /p choice="Enter choice (1-4): "

if "%choice%"=="1" (
    echo Showing all logs in real-time (Press Ctrl+C to stop)...
    docker-compose logs -f
) else if "%choice%"=="2" (
    echo Showing application logs only...
    docker-compose logs algofi-tracker
) else if "%choice%"=="3" (
    echo Showing last 50 lines...
    docker-compose logs --tail=50
) else if "%choice%"=="4" (
    exit /b 0
) else (
    echo Invalid choice
    pause
    exit /b 1
)

pause