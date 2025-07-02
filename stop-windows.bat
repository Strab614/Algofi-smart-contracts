@echo off
echo 🛑 Stopping Algofi Tracker...
echo ============================

REM Stop production containers
echo Stopping production containers...
docker-compose down

REM Stop development containers
echo Stopping development containers...
docker-compose -f docker-compose.dev.yml down

echo.
echo ✅ Algofi Tracker stopped successfully!
echo.
echo To start again, run: start-windows.bat
echo.
pause