# 🐳 Windows Docker Desktop Deployment Guide

Complete guide to run the Algofi Tracker application on Docker Desktop for Windows.

## 📋 Prerequisites for Windows

### 1. Install Docker Desktop for Windows
- **Download**: [Docker Desktop for Windows](https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe)
- **System Requirements**:
  - Windows 10 64-bit: Pro, Enterprise, or Education (Build 19041 or higher)
  - Windows 11 64-bit: Home or Pro version 21H2 or higher
  - WSL 2 feature enabled
  - Virtualization enabled in BIOS
  - At least 4GB RAM

### 2. Enable Required Windows Features
```powershell
# Run PowerShell as Administrator
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform
```

### 3. Install WSL 2 (if not already installed)
```powershell
# Run in PowerShell as Administrator
wsl --install
# Restart your computer after installation
```

### 4. Verify Docker Installation
```cmd
# Open Command Prompt or PowerShell
docker --version
docker-compose --version
docker info
```

## 🚀 Quick Start for Windows

### Option 1: PowerShell Script (Recommended)
```powershell
# Open PowerShell as Administrator
# Navigate to your project directory
cd C:\path\to\your\algofi-tracker

# Make sure execution policy allows scripts
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Run the deployment script
.\scripts\windows-docker-deploy.ps1
```

### Option 2: Command Prompt
```cmd
# Open Command Prompt as Administrator
cd C:\path\to\your\algofi-tracker

# Build the Docker image
docker build -t algofi-tracker:latest .

# Run with Docker Compose
docker-compose up -d

# Check status
docker-compose ps
```

### Option 3: Docker Desktop GUI
1. **Open Docker Desktop**
2. **Click "Images" → "Build"**
3. **Select your project folder**
4. **Set image name**: `algofi-tracker:latest`
5. **Click "Build"**
6. **Go to "Images" → Find your image → Click "Run"**
7. **Set ports**: `3000:3000` and `8000:8000`
8. **Click "Run"**

## 🌐 Access Your Application

Once running, open your web browser and navigate to:

- **🖥️ Frontend**: http://localhost:3000
- **🔌 Backend API**: http://localhost:8000
- **❤️ Health Check**: http://localhost:8000/api/health

## 🛠️ Windows-Specific Commands

### Using Command Prompt
```cmd
REM Build images
docker build -t algofi-tracker:latest .

REM Start production environment
docker-compose up -d

REM Start development environment
docker-compose -f docker-compose.dev.yml up -d

REM View logs
docker-compose logs -f

REM Stop services
docker-compose down

REM Check container status
docker-compose ps

REM Clean up
docker system prune -f
```

### Using PowerShell
```powershell
# Build images
docker build -t algofi-tracker:latest .

# Start production environment
docker-compose up -d

# Start development environment
docker-compose -f docker-compose.dev.yml up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down

# Check container status
docker-compose ps

# Clean up
docker system prune -f
```

## 📱 Docker Desktop GUI for Windows

### Building Images
1. **Open Docker Desktop**
2. **Navigate to "Images" tab**
3. **Click "Build an image"**
4. **Browse to your project folder**
5. **Enter image name**: `algofi-tracker`
6. **Enter tag**: `latest`
7. **Click "Build"**

### Running Containers
1. **Go to "Images" tab**
2. **Find `algofi-tracker:latest`**
3. **Click "Run" button**
4. **Configure settings**:
   - **Container name**: `algofi-tracker-app`
   - **Ports**: 
     - `3000:3000` (Frontend)
     - `8000:8000` (Backend)
   - **Environment**: `NODE_ENV=production`
5. **Click "Run"**

### Managing Containers
1. **Go to "Containers" tab**
2. **View running containers**
3. **Use controls to start/stop/restart**
4. **Click container name for details**
5. **View logs in "Logs" tab**

## 🔧 Windows Development Setup

### Development Mode
```cmd
REM Start development environment with hot reload
docker-compose -f docker-compose.dev.yml up

REM Or in detached mode
docker-compose -f docker-compose.dev.yml up -d
```

### File Watching (Windows-specific)
Add to your `docker-compose.dev.yml`:
```yaml
environment:
  - CHOKIDAR_USEPOLLING=true
  - WATCHPACK_POLLING=true
```

## 🔍 Monitoring on Windows

### View Logs
```cmd
REM View all logs
docker-compose logs

REM Follow logs in real-time
docker-compose logs -f

REM View specific service logs
docker-compose logs algofi-tracker

REM View last 50 lines
docker-compose logs --tail=50
```

### Check Resource Usage
```cmd
REM View container stats
docker stats

REM View container processes
docker-compose top

REM Check disk usage
docker system df
```

### Health Checks
```cmd
REM Check application health
curl http://localhost:8000/api/health

REM Or using PowerShell
Invoke-WebRequest -Uri http://localhost:8000/api/health

REM Check container health
docker-compose ps
```

## 🚨 Windows-Specific Troubleshooting

### Common Windows Issues

#### 1. WSL 2 Not Enabled
```powershell
# Enable WSL 2
wsl --set-default-version 2
wsl --install -d Ubuntu

# Restart Docker Desktop
```

#### 2. Virtualization Not Enabled
1. **Restart computer**
2. **Enter BIOS/UEFI settings**
3. **Enable Intel VT-x or AMD-V**
4. **Save and restart**

#### 3. Port Already in Use
```cmd
REM Check what's using port 3000
netstat -ano | findstr :3000

REM Kill process by PID
taskkill /PID <PID> /F

REM Check port 8000
netstat -ano | findstr :8000
```

#### 4. Docker Desktop Won't Start
```cmd
REM Restart Docker Desktop service
net stop com.docker.service
net start com.docker.service

REM Or restart from Services.msc
```

#### 5. File Sharing Issues
1. **Open Docker Desktop Settings**
2. **Go to "Resources" → "File Sharing"**
3. **Add your project directory**
4. **Apply & Restart**

#### 6. Memory Issues
1. **Open Docker Desktop Settings**
2. **Go to "Resources" → "Advanced"**
3. **Increase memory to at least 4GB**
4. **Apply & Restart**

### Windows Firewall
```cmd
REM Allow Docker through Windows Firewall
netsh advfirewall firewall add rule name="Docker Desktop" dir=in action=allow protocol=TCP localport=3000
netsh advfirewall firewall add rule name="Docker Desktop API" dir=in action=allow protocol=TCP localport=8000
```

## 📁 Windows File Paths

### Project Structure
```
C:\Users\YourName\algofi-tracker\
├── docker-compose.yml
├── docker-compose.dev.yml
├── Dockerfile
├── package.json
├── src\
├── server\
└── scripts\
```

### Volume Mounting (Windows)
```yaml
# In docker-compose.dev.yml
volumes:
  - .:/app:cached                    # Current directory
  - /app/node_modules               # Exclude node_modules
  - C:\logs:/app/logs               # Windows path
```

## 🔄 Windows Batch Scripts

### Create `start.bat`
```batch
@echo off
echo Starting Algofi Tracker...
docker-compose up -d
echo Application started!
echo Frontend: http://localhost:3000
echo Backend: http://localhost:8000
pause
```

### Create `stop.bat`
```batch
@echo off
echo Stopping Algofi Tracker...
docker-compose down
echo Application stopped!
pause
```

### Create `logs.bat`
```batch
@echo off
echo Showing application logs...
docker-compose logs -f
```

## 🔧 PowerShell Scripts

### Create `Deploy.ps1`
```powershell
# Deploy.ps1
Write-Host "🐳 Deploying Algofi Tracker..." -ForegroundColor Blue

# Check if Docker is running
try {
    docker info | Out-Null
    Write-Host "✅ Docker is running" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker is not running. Please start Docker Desktop." -ForegroundColor Red
    exit 1
}

# Build and start
Write-Host "📦 Building and starting containers..." -ForegroundColor Yellow
docker-compose up --build -d

# Wait for services
Write-Host "⏳ Waiting for services to start..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

# Health check
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8000/api/health" -UseBasicParsing
    if ($response.StatusCode -eq 200) {
        Write-Host "✅ Application is healthy!" -ForegroundColor Green
        Write-Host "🌐 Frontend: http://localhost:3000" -ForegroundColor Cyan
        Write-Host "🔌 Backend: http://localhost:8000" -ForegroundColor Cyan
    }
} catch {
    Write-Host "⚠️ Health check failed. Check logs with: docker-compose logs" -ForegroundColor Yellow
}

Write-Host "🎉 Deployment complete!" -ForegroundColor Green
```

## 🔒 Windows Security Considerations

### Windows Defender
1. **Add Docker Desktop to exclusions**
2. **Add project folder to exclusions**
3. **Allow Docker through firewall**

### User Account Control (UAC)
- **Run Docker Desktop as Administrator** (first time)
- **Add user to docker-users group**

### Antivirus Software
- **Exclude Docker directories** from real-time scanning
- **Exclude project folder** from scanning

## 📊 Performance Optimization for Windows

### Docker Desktop Settings
1. **Resources → Advanced**:
   - **Memory**: 4-8GB
   - **CPUs**: 2-4 cores
   - **Swap**: 1GB
   - **Disk image size**: 60GB+

2. **Resources → File Sharing**:
   - **Add project directories**
   - **Use WSL 2 backend**

3. **General**:
   - **Use WSL 2 based engine** ✅
   - **Send usage statistics** (optional)

### Windows-Specific Optimizations
```yaml
# In docker-compose.yml
services:
  algofi-tracker:
    # Use bind mounts for better performance on Windows
    volumes:
      - type: bind
        source: .
        target: /app
        consistency: cached
```

## 🆘 Getting Help on Windows

### Check System Information
```cmd
REM System info
systeminfo | findstr /B /C:"OS Name" /C:"OS Version"

REM Docker info
docker version
docker info

REM WSL info
wsl --list --verbose
```

### Common Commands Reference
```cmd
REM Start everything
docker-compose up -d

REM Stop everything
docker-compose down

REM View logs
docker-compose logs -f

REM Restart services
docker-compose restart

REM Check status
docker-compose ps

REM Clean up
docker system prune -f

REM Update images
docker-compose pull
docker-compose up --build -d
```

### Windows Event Logs
1. **Open Event Viewer**
2. **Navigate to**: Windows Logs → Application
3. **Filter by**: Docker Desktop events

## 🎯 Quick Troubleshooting Checklist

- [ ] **Docker Desktop is running**
- [ ] **WSL 2 is enabled and updated**
- [ ] **Virtualization is enabled in BIOS**
- [ ] **Windows features are enabled**
- [ ] **Ports 3000 and 8000 are available**
- [ ] **Project files are in accessible location**
- [ ] **Docker has file sharing permissions**
- [ ] **Windows Firewall allows Docker**
- [ ] **Sufficient memory allocated to Docker**

## 🎉 Success on Windows!

If everything is working correctly:

1. **✅ Docker Desktop shows containers running**
2. **✅ http://localhost:3000 loads the React app**
3. **✅ http://localhost:8000/api/health returns success**
4. **✅ No errors in Docker Desktop logs**

**Congratulations! Your Algofi Tracker is now running on Windows with Docker Desktop! 🚀**

## 📚 Additional Resources

- **Docker Desktop for Windows**: https://docs.docker.com/desktop/windows/
- **WSL 2 Documentation**: https://docs.microsoft.com/en-us/windows/wsl/
- **Windows Container Documentation**: https://docs.microsoft.com/en-us/virtualization/windowscontainers/
- **Docker Compose on Windows**: https://docs.docker.com/compose/install/