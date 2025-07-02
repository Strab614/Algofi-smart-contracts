@echo off
echo 🐳 Starting Algofi Tracker on Windows...
echo =====================================

REM Check if Docker is running
docker info >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker is not running!
    echo Please start Docker Desktop and try again.
    pause
    exit /b 1
)

echo ✅ Docker is running

REM Start the application
echo 🚀 Starting Algofi Tracker...
docker-compose up -d

REM Check if containers started successfully
if errorlevel 1 (
    echo ❌ Failed to start containers
    echo Check logs with: docker-compose logs
    pause
    exit /b 1
)

echo ✅ Containers started successfully!
echo.
echo 🌐 Application URLs:
echo    Frontend:     http://localhost:3000
echo    Backend API:  http://localhost:8000
echo    Health Check: http://localhost:8000/api/health
echo.
echo 📊 Container Status:
docker-compose ps
echo.
echo 🎉 Algofi Tracker is now running!
echo.
echo Press any key to open the application in your browser...
pause >nul

REM Open browser
start http://localhost:3000