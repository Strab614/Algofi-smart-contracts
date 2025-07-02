# Windows PowerShell Deployment Script for Algofi Tracker
# Run this script in PowerShell as Administrator

param(
    [string]$Mode = "production",
    [switch]$Help
)

# Colors for output
$ErrorColor = "Red"
$SuccessColor = "Green"
$InfoColor = "Cyan"
$WarningColor = "Yellow"

function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

function Show-Help {
    Write-ColorOutput "🐳 Algofi Tracker - Windows Docker Deployment Script" $InfoColor
    Write-ColorOutput "=============================================" $InfoColor
    Write-ColorOutput ""
    Write-ColorOutput "Usage:" $InfoColor
    Write-ColorOutput "  .\windows-docker-deploy.ps1 [OPTIONS]" $InfoColor
    Write-ColorOutput ""
    Write-ColorOutput "Options:" $InfoColor
    Write-ColorOutput "  -Mode <mode>    Deployment mode: 'production' or 'development' (default: production)" $InfoColor
    Write-ColorOutput "  -Help           Show this help message" $InfoColor
    Write-ColorOutput ""
    Write-ColorOutput "Examples:" $InfoColor
    Write-ColorOutput "  .\windows-docker-deploy.ps1                    # Deploy in production mode" $InfoColor
    Write-ColorOutput "  .\windows-docker-deploy.ps1 -Mode development  # Deploy in development mode" $InfoColor
    Write-ColorOutput ""
    exit 0
}

if ($Help) {
    Show-Help
}

Write-ColorOutput "🐳 Algofi Tracker - Windows Docker Deployment" $InfoColor
Write-ColorOutput "=============================================" $InfoColor
Write-ColorOutput ""

# Check if running as Administrator
$currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
$isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-ColorOutput "⚠️ Warning: Not running as Administrator. Some operations may fail." $WarningColor
    Write-ColorOutput "Consider running PowerShell as Administrator for best results." $WarningColor
    Write-ColorOutput ""
}

# Function to check if a command exists
function Test-Command {
    param([string]$Command)
    try {
        Get-Command $Command -ErrorAction Stop | Out-Null
        return $true
    } catch {
        return $false
    }
}

# Function to check if a port is in use
function Test-Port {
    param([int]$Port)
    try {
        $connection = Test-NetConnection -ComputerName localhost -Port $Port -WarningAction SilentlyContinue
        return $connection.TcpTestSucceeded
    } catch {
        # Fallback method
        $netstat = netstat -an | Select-String ":$Port "
        return $netstat.Count -gt 0
    }
}

# Check Docker installation
Write-ColorOutput "🔍 Checking Docker installation..." $InfoColor
if (-not (Test-Command "docker")) {
    Write-ColorOutput "❌ Docker is not installed or not in PATH!" $ErrorColor
    Write-ColorOutput "Please install Docker Desktop from: https://www.docker.com/products/docker-desktop" $ErrorColor
    exit 1
}

# Check if Docker is running
Write-ColorOutput "🔍 Checking if Docker is running..." $InfoColor
try {
    docker info | Out-Null
    Write-ColorOutput "✅ Docker is running" $SuccessColor
} catch {
    Write-ColorOutput "❌ Docker is not running!" $ErrorColor
    Write-ColorOutput "Please start Docker Desktop and try again." $ErrorColor
    exit 1
}

# Check Docker Compose
Write-ColorOutput "🔍 Checking Docker Compose..." $InfoColor
if (-not (Test-Command "docker-compose")) {
    Write-ColorOutput "❌ Docker Compose is not available!" $ErrorColor
    Write-ColorOutput "Please ensure Docker Desktop is properly installed." $ErrorColor
    exit 1
}

Write-ColorOutput "✅ Docker Compose is available" $SuccessColor

# Display versions
$dockerVersion = docker --version
$composeVersion = docker-compose --version
Write-ColorOutput "📋 $dockerVersion" $InfoColor
Write-ColorOutput "📋 $composeVersion" $InfoColor
Write-ColorOutput ""

# Check port availability
Write-ColorOutput "🔍 Checking port availability..." $InfoColor

if (Test-Port -Port 3000) {
    Write-ColorOutput "⚠️ Port 3000 is already in use!" $WarningColor
    $continue = Read-Host "Continue anyway? (y/N)"
    if ($continue -ne "y" -and $continue -ne "Y") {
        Write-ColorOutput "Deployment cancelled." $WarningColor
        exit 1
    }
} else {
    Write-ColorOutput "✅ Port 3000 is available" $SuccessColor
}

if (Test-Port -Port 8000) {
    Write-ColorOutput "⚠️ Port 8000 is already in use!" $WarningColor
    $continue = Read-Host "Continue anyway? (y/N)"
    if ($continue -ne "y" -and $continue -ne "Y") {
        Write-ColorOutput "Deployment cancelled." $WarningColor
        exit 1
    }
} else {
    Write-ColorOutput "✅ Port 8000 is available" $SuccessColor
}

# Check if project files exist
Write-ColorOutput "🔍 Checking project files..." $InfoColor
$requiredFiles = @("Dockerfile", "package.json", "docker-compose.yml")
$missingFiles = @()

foreach ($file in $requiredFiles) {
    if (-not (Test-Path $file)) {
        $missingFiles += $file
    }
}

if ($missingFiles.Count -gt 0) {
    Write-ColorOutput "❌ Missing required files:" $ErrorColor
    foreach ($file in $missingFiles) {
        Write-ColorOutput "   - $file" $ErrorColor
    }
    Write-ColorOutput "Please ensure you're in the correct project directory." $ErrorColor
    exit 1
}

Write-ColorOutput "✅ All required files found" $SuccessColor
Write-ColorOutput ""

# Clean up any existing containers
Write-ColorOutput "🧹 Cleaning up existing containers..." $InfoColor
try {
    docker-compose down --remove-orphans 2>$null | Out-Null
    docker-compose -f docker-compose.dev.yml down --remove-orphans 2>$null | Out-Null
    Write-ColorOutput "✅ Cleanup completed" $SuccessColor
} catch {
    Write-ColorOutput "ℹ️ No existing containers to clean up" $InfoColor
}

# Create Docker network
Write-ColorOutput "🌐 Creating Docker network..." $InfoColor
try {
    docker network create algofi-network 2>$null | Out-Null
    Write-ColorOutput "✅ Docker network created" $SuccessColor
} catch {
    Write-ColorOutput "ℹ️ Docker network already exists" $InfoColor
}

# Build Docker images
Write-ColorOutput "📦 Building Docker images..." $InfoColor
Write-ColorOutput "This may take a few minutes on first run..." $WarningColor

try {
    if ($Mode -eq "development") {
        Write-ColorOutput "🔧 Building development image..." $InfoColor
        docker-compose -f docker-compose.dev.yml build --no-cache
        if ($LASTEXITCODE -ne 0) {
            throw "Development build failed"
        }
    } else {
        Write-ColorOutput "🏭 Building production image..." $InfoColor
        docker-compose build --no-cache
        if ($LASTEXITCODE -ne 0) {
            throw "Production build failed"
        }
    }
    Write-ColorOutput "✅ Docker images built successfully" $SuccessColor
} catch {
    Write-ColorOutput "❌ Failed to build Docker images: $_" $ErrorColor
    Write-ColorOutput "Try running: docker system prune -f" $WarningColor
    exit 1
}

# Start the application
Write-ColorOutput ""
Write-ColorOutput "🚀 Starting Algofi Tracker in $Mode mode..." $InfoColor

try {
    if ($Mode -eq "development") {
        Write-ColorOutput "🔧 Starting development environment..." $InfoColor
        docker-compose -f docker-compose.dev.yml up -d
    } else {
        Write-ColorOutput "🏭 Starting production environment..." $InfoColor
        docker-compose up -d
    }
    
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to start containers"
    }
    
    Write-ColorOutput "✅ Containers started successfully" $SuccessColor
} catch {
    Write-ColorOutput "❌ Failed to start application: $_" $ErrorColor
    Write-ColorOutput "Check logs with: docker-compose logs" $ErrorColor
    exit 1
}

# Wait for services to be ready
Write-ColorOutput ""
Write-ColorOutput "⏳ Waiting for services to start..." $InfoColor

$maxAttempts = 60
$attempt = 0
$backendReady = $false

while ($attempt -lt $maxAttempts -and -not $backendReady) {
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:8000/api/health" -UseBasicParsing -TimeoutSec 2 -ErrorAction Stop
        if ($response.StatusCode -eq 200) {
            $backendReady = $true
            Write-ColorOutput ""
            Write-ColorOutput "✅ Backend is ready!" $SuccessColor
        }
    } catch {
        Write-Host "." -NoNewline
        Start-Sleep -Seconds 1
        $attempt++
    }
}

if (-not $backendReady) {
    Write-ColorOutput ""
    Write-ColorOutput "⚠️ Backend health check timeout after 60 seconds" $WarningColor
    Write-ColorOutput "The application may still be starting. Check logs with: docker-compose logs" $WarningColor
} else {
    Write-ColorOutput ""
}

# Perform health checks
Write-ColorOutput "🔍 Performing health checks..." $InfoColor

# Check backend health
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8000/api/health" -UseBasicParsing -ErrorAction Stop
    if ($response.StatusCode -eq 200) {
        Write-ColorOutput "✅ Backend health check passed" $SuccessColor
    }
} catch {
    Write-ColorOutput "❌ Backend health check failed" $ErrorColor
}

# Check frontend accessibility
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000" -UseBasicParsing -TimeoutSec 5 -ErrorAction Stop
    Write-ColorOutput "✅ Frontend is accessible" $SuccessColor
} catch {
    Write-ColorOutput "⚠️ Frontend may still be starting up" $WarningColor
}

# Show container status
Write-ColorOutput ""
Write-ColorOutput "📊 Container status:" $InfoColor
docker-compose ps

# Display success information
Write-ColorOutput ""
Write-ColorOutput "🎉 Algofi Tracker is now running on Docker Desktop!" $SuccessColor
Write-ColorOutput "=================================================" $SuccessColor
Write-ColorOutput ""
Write-ColorOutput "📱 Access your application:" $InfoColor
Write-ColorOutput "   🖥️  Frontend:     http://localhost:3000" $InfoColor
Write-ColorOutput "   🔌 Backend API:   http://localhost:8000" $InfoColor
Write-ColorOutput "   ❤️  Health Check: http://localhost:8000/api/health" $InfoColor
Write-ColorOutput ""
Write-ColorOutput "🛠️ Useful Windows commands:" $InfoColor
Write-ColorOutput "   📋 View logs:     docker-compose logs -f" $InfoColor
Write-ColorOutput "   📊 Check status:  docker-compose ps" $InfoColor
Write-ColorOutput "   🔄 Restart:       docker-compose restart" $InfoColor
Write-ColorOutput "   🛑 Stop:          docker-compose down" $InfoColor
Write-ColorOutput ""
Write-ColorOutput "🔧 Windows-specific commands:" $InfoColor
Write-ColorOutput "   📊 Resource usage: docker stats" $InfoColor
Write-ColorOutput "   🧹 Clean up:       docker system prune -f" $InfoColor
Write-ColorOutput "   🔍 Port check:     netstat -ano | findstr :3000" $InfoColor
Write-ColorOutput ""

# Open browser automatically (optional)
$openBrowser = Read-Host "Open application in browser? (Y/n)"
if ($openBrowser -ne "n" -and $openBrowser -ne "N") {
    Write-ColorOutput "🌐 Opening application in default browser..." $InfoColor
    Start-Process "http://localhost:3000"
}

Write-ColorOutput ""
Write-ColorOutput "🎯 Next steps:" $InfoColor
Write-ColorOutput "1. Explore the Algofi Tracker interface" $InfoColor
Write-ColorOutput "2. Check the API at http://localhost:8000/api" $InfoColor
Write-ColorOutput "3. Monitor containers in Docker Desktop" $InfoColor
Write-ColorOutput ""
Write-ColorOutput "Need help? Check WINDOWS_DOCKER_GUIDE.md for detailed instructions." $InfoColor
Write-ColorOutput ""
Write-ColorOutput "✅ Deployment completed successfully! 🚀" $SuccessColor