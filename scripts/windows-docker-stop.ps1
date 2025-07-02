# Windows PowerShell Script to Stop Algofi Tracker
# Run this script to stop all Docker containers

Write-Host "🛑 Stopping Algofi Tracker..." -ForegroundColor Yellow

# Check if Docker is running
try {
    docker info | Out-Null
    Write-Host "✅ Docker is running" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker is not running" -ForegroundColor Red
    exit 1
}

# Stop production containers
Write-Host "🏭 Stopping production containers..." -ForegroundColor Cyan
docker-compose down

# Stop development containers
Write-Host "🔧 Stopping development containers..." -ForegroundColor Cyan
docker-compose -f docker-compose.dev.yml down

# Show final status
Write-Host ""
Write-Host "📊 Final container status:" -ForegroundColor Cyan
docker-compose ps

Write-Host ""
Write-Host "✅ Algofi Tracker stopped successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "To start again, run:" -ForegroundColor Cyan
Write-Host "  .\windows-docker-deploy.ps1" -ForegroundColor White