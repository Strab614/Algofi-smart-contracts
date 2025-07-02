# Windows PowerShell Script to Clean Up Docker Resources

param(
    [switch]$Force,
    [switch]$Help
)

function Show-Help {
    Write-Host "🧹 Algofi Tracker - Windows Docker Cleanup" -ForegroundColor Cyan
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Usage:" -ForegroundColor Cyan
    Write-Host "  .\windows-docker-cleanup.ps1 [OPTIONS]" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Options:" -ForegroundColor Cyan
    Write-Host "  -Force    Skip confirmation prompts" -ForegroundColor Cyan
    Write-Host "  -Help     Show this help message" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "This script will:" -ForegroundColor Yellow
    Write-Host "  • Stop and remove Algofi Tracker containers" -ForegroundColor White
    Write-Host "  • Remove Algofi Tracker images" -ForegroundColor White
    Write-Host "  • Clean up unused Docker volumes" -ForegroundColor White
    Write-Host "  • Clean up unused Docker networks" -ForegroundColor White
    Write-Host "  • Clean up Docker build cache" -ForegroundColor White
    Write-Host ""
    exit 0
}

if ($Help) {
    Show-Help
}

Write-Host "🧹 Algofi Tracker - Docker Cleanup" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

# Check if Docker is running
try {
    docker info | Out-Null
    Write-Host "✅ Docker is running" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker is not running!" -ForegroundColor Red
    Write-Host "Please start Docker Desktop and try again." -ForegroundColor Red
    exit 1
}

if (-not $Force) {
    Write-Host "⚠️ This will remove all Algofi Tracker containers, images, and unused Docker resources." -ForegroundColor Yellow
    $confirm = Read-Host "Are you sure you want to continue? (y/N)"
    if ($confirm -ne "y" -and $confirm -ne "Y") {
        Write-Host "Cleanup cancelled." -ForegroundColor Yellow
        exit 0
    }
    Write-Host ""
}

# Stop and remove containers
Write-Host "🛑 Stopping and removing containers..." -ForegroundColor Yellow
try {
    docker-compose down --remove-orphans 2>$null
    docker-compose -f docker-compose.dev.yml down --remove-orphans 2>$null
    Write-Host "✅ Containers stopped and removed" -ForegroundColor Green
} catch {
    Write-Host "⚠️ Some containers may not have been running" -ForegroundColor Yellow
}

# Remove images
Write-Host "🗑️ Removing Algofi Tracker images..." -ForegroundColor Yellow
try {
    docker rmi algofi-tracker:dev 2>$null
    docker rmi algofi-tracker:latest 2>$null
    Write-Host "✅ Images removed" -ForegroundColor Green
} catch {
    Write-Host "⚠️ Some images may not exist" -ForegroundColor Yellow
}

# Remove unused volumes
Write-Host "💾 Cleaning up unused volumes..." -ForegroundColor Yellow
try {
    docker volume prune -f | Out-Null
    Write-Host "✅ Unused volumes cleaned up" -ForegroundColor Green
} catch {
    Write-Host "⚠️ Volume cleanup may have failed" -ForegroundColor Yellow
}

# Remove unused networks
Write-Host "🌐 Cleaning up unused networks..." -ForegroundColor Yellow
try {
    docker network prune -f | Out-Null
    Write-Host "✅ Unused networks cleaned up" -ForegroundColor Green
} catch {
    Write-Host "⚠️ Network cleanup may have failed" -ForegroundColor Yellow
}

# Remove build cache
Write-Host "🗂️ Cleaning up build cache..." -ForegroundColor Yellow
try {
    docker builder prune -f | Out-Null
    Write-Host "✅ Build cache cleaned up" -ForegroundColor Green
} catch {
    Write-Host "⚠️ Build cache cleanup may have failed" -ForegroundColor Yellow
}

# Show disk usage after cleanup
Write-Host ""
Write-Host "📊 Docker disk usage after cleanup:" -ForegroundColor Cyan
docker system df

Write-Host ""
Write-Host "✅ Cleanup completed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "To redeploy Algofi Tracker, run:" -ForegroundColor Cyan
Write-Host "  .\windows-docker-deploy.ps1" -ForegroundColor White