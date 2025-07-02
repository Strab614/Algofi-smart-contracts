# Windows PowerShell Script to View Algofi Tracker Logs

param(
    [string]$Service = "all",
    [int]$Lines = 100,
    [switch]$Follow,
    [switch]$Help
)

function Show-Help {
    Write-Host "🐳 Algofi Tracker - Windows Docker Logs Viewer" -ForegroundColor Cyan
    Write-Host "=============================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Usage:" -ForegroundColor Cyan
    Write-Host "  .\windows-docker-logs.ps1 [OPTIONS]" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Options:" -ForegroundColor Cyan
    Write-Host "  -Service <name>  Service to view logs for: 'app', 'all', 'dev' (default: all)" -ForegroundColor Cyan
    Write-Host "  -Lines <number>  Number of lines to show (default: 100)" -ForegroundColor Cyan
    Write-Host "  -Follow          Follow logs in real-time" -ForegroundColor Cyan
    Write-Host "  -Help            Show this help message" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Examples:" -ForegroundColor Cyan
    Write-Host "  .\windows-docker-logs.ps1                    # Show last 100 lines of all logs" -ForegroundColor White
    Write-Host "  .\windows-docker-logs.ps1 -Service app       # Show app logs only" -ForegroundColor White
    Write-Host "  .\windows-docker-logs.ps1 -Follow            # Follow all logs in real-time" -ForegroundColor White
    Write-Host "  .\windows-docker-logs.ps1 -Lines 50 -Follow  # Follow last 50 lines" -ForegroundColor White
    Write-Host ""
    exit 0
}

if ($Help) {
    Show-Help
}

Write-Host "📋 Algofi Tracker - Docker Logs" -ForegroundColor Cyan
Write-Host "===============================" -ForegroundColor Cyan
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

# Build command based on parameters
$logCommand = "docker-compose logs --tail=$Lines"

if ($Follow) {
    $logCommand += " -f"
}

switch ($Service.ToLower()) {
    "app" {
        Write-Host "📱 Showing application logs (last $Lines lines)..." -ForegroundColor Yellow
        if ($Follow) {
            Write-Host "Press Ctrl+C to stop following logs" -ForegroundColor Yellow
        }
        Write-Host ""
        Invoke-Expression "$logCommand algofi-tracker"
    }
    "dev" {
        Write-Host "🔧 Showing development logs (last $Lines lines)..." -ForegroundColor Yellow
        if ($Follow) {
            Write-Host "Press Ctrl+C to stop following logs" -ForegroundColor Yellow
        }
        Write-Host ""
        Invoke-Expression "docker-compose -f docker-compose.dev.yml logs --tail=$Lines $(if ($Follow) { '-f' })"
    }
    "all" {
        Write-Host "📋 Showing all logs (last $Lines lines)..." -ForegroundColor Yellow
        if ($Follow) {
            Write-Host "Press Ctrl+C to stop following logs" -ForegroundColor Yellow
        }
        Write-Host ""
        Invoke-Expression $logCommand
    }
    default {
        Write-Host "❌ Unknown service: $Service" -ForegroundColor Red
        Write-Host "Available services: app, dev, all" -ForegroundColor Yellow
        exit 1
    }
}