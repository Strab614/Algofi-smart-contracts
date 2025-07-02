# 🐳 Docker Desktop Deployment Guide

Complete guide to run the Algofi Tracker application on Docker Desktop.

## 📋 Prerequisites

### 1. Install Docker Desktop
- **Windows**: Download from [Docker Desktop for Windows](https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe)
- **macOS**: Download from [Docker Desktop for Mac](https://desktop.docker.com/mac/main/amd64/Docker.dmg)
- **Linux**: Follow [Docker Desktop for Linux](https://docs.docker.com/desktop/install/linux-install/) instructions

### 2. System Requirements
- **RAM**: Minimum 4GB, Recommended 8GB
- **Storage**: At least 2GB free space
- **Ports**: 3000 and 8000 must be available

### 3. Verify Docker Installation
```bash
# Check Docker version
docker --version

# Check Docker Compose version
docker-compose --version

# Verify Docker is running
docker info
```

## 🚀 Quick Start (Recommended)

### Option 1: One-Command Deployment
```bash
# Make scripts executable (Linux/macOS)
chmod +x scripts/*.sh

# Deploy everything automatically
./scripts/docker-deploy.sh
```

### Option 2: Manual Step-by-Step

#### Step 1: Build the Docker Image
```bash
# Build production image
docker build -t algofi-tracker:latest .

# Or build development image
docker build --target development -t algofi-tracker:dev .
```

#### Step 2: Run with Docker Compose
```bash
# Start production environment
docker-compose up -d

# Or start development environment
docker-compose -f docker-compose.dev.yml up -d
```

#### Step 3: Verify Deployment
```bash
# Check container status
docker-compose ps

# Check application health
curl http://localhost:8000/api/health
```

## 🌐 Access Your Application

Once deployed, access the application at:

- **🖥️ Frontend (React App)**: http://localhost:3000
- **🔌 Backend API**: http://localhost:8000
- **❤️ Health Check**: http://localhost:8000/api/health
- **📊 API Documentation**: http://localhost:8000/api

## 🛠️ Development Mode

### Start Development Environment
```bash
# Using script
./scripts/docker-run.sh dev

# Or using Docker Compose directly
docker-compose -f docker-compose.dev.yml up
```

### Development Features
- ✅ Hot reload for code changes
- ✅ Source code mounted as volumes
- ✅ Development dependencies included
- ✅ Debug-friendly logging

## 🏭 Production Mode

### Start Production Environment
```bash
# Using script
./scripts/docker-run.sh prod

# Or using Docker Compose directly
docker-compose up -d
```

### Production Features
- ✅ Optimized build with multi-stage Dockerfile
- ✅ Security hardening (non-root user, read-only filesystem)
- ✅ Health checks and monitoring
- ✅ Nginx reverse proxy (optional)
- ✅ Resource limits and optimization

## 📱 Docker Desktop GUI Instructions

### 1. Using Docker Desktop Dashboard

1. **Open Docker Desktop**
2. **Go to Images tab**
3. **Click "Build" or import the image**
4. **Navigate to Containers tab**
5. **Click "Run" on the algofi-tracker image**
6. **Configure ports**: 
   - Host Port 3000 → Container Port 3000
   - Host Port 8000 → Container Port 8000
7. **Click "Run"**

### 2. Using Docker Desktop Compose

1. **Open Docker Desktop**
2. **Go to "Compose" or "Stacks" tab**
3. **Click "Create Stack"**
4. **Upload `docker-compose.yml`**
5. **Click "Deploy"**

## 🔧 Available Commands

### Build Commands
```bash
# Build all images
./scripts/docker-build.sh

# Build specific target
docker build --target production -t algofi-tracker:prod .
docker build --target development -t algofi-tracker:dev .
```

### Run Commands
```bash
# Development mode with hot reload
./scripts/docker-run.sh dev

# Production mode
./scripts/docker-run.sh prod

# Stop all services
./scripts/docker-run.sh stop
```

### Monitoring Commands
```bash
# View logs
./scripts/docker-logs.sh app        # Application logs
./scripts/docker-logs.sh all        # All service logs
./scripts/docker-logs.sh dev        # Development logs

# Check status
docker-compose ps                    # Container status
docker stats                        # Resource usage
```

### Maintenance Commands
```bash
# Restart services
docker-compose restart

# Update and rebuild
docker-compose up --build -d

# Clean up resources
./scripts/docker-cleanup.sh
```

## 🔍 Monitoring & Debugging

### Health Checks
```bash
# Application health
curl http://localhost:8000/api/health

# Container health
docker-compose ps

# Detailed container info
docker inspect algofi-tracker-app
```

### View Logs
```bash
# Real-time logs
docker-compose logs -f

# Specific service logs
docker-compose logs algofi-tracker

# Last 100 lines
docker-compose logs --tail=100 algofi-tracker
```

### Debug Container
```bash
# Enter running container
docker-compose exec algofi-tracker sh

# Run commands inside container
docker-compose exec algofi-tracker npm --version
```

## ⚙️ Configuration

### Environment Variables
Create `.env` file in project root:
```bash
# Application
NODE_ENV=production
PORT=8000
FRONTEND_PORT=3000

# Algorand
ALGORAND_NETWORK=testnet
ALGORAND_API_URL=https://testnet-api.algonode.cloud

# Security
CORS_ORIGIN=http://localhost:3000
RATE_LIMIT_MAX_REQUESTS=100
```

### Custom Configuration
```bash
# Edit docker-compose.yml for custom settings
# Edit Dockerfile for build customization
# Edit nginx.conf for reverse proxy settings
```

## 🚨 Troubleshooting

### Common Issues & Solutions

#### 1. Port Already in Use
```bash
# Check what's using the port
lsof -i :3000
lsof -i :8000

# Kill process using port
kill -9 $(lsof -t -i:3000)

# Or use different ports in docker-compose.yml
```

#### 2. Docker Not Running
```bash
# Start Docker Desktop application
# Or restart Docker service (Linux)
sudo systemctl restart docker
```

#### 3. Build Failures
```bash
# Clean Docker cache
docker system prune -f

# Rebuild without cache
docker-compose build --no-cache

# Check Docker disk space
docker system df
```

#### 4. Container Won't Start
```bash
# Check logs for errors
docker-compose logs algofi-tracker

# Check container status
docker-compose ps

# Restart container
docker-compose restart algofi-tracker
```

#### 5. Memory Issues
```bash
# Check Docker memory usage
docker stats

# Increase Docker Desktop memory limit:
# Docker Desktop → Settings → Resources → Memory
```

### Debug Steps
1. **Check Docker Desktop is running**
2. **Verify ports are available**
3. **Check logs**: `docker-compose logs`
4. **Verify health**: `curl http://localhost:8000/api/health`
5. **Restart services**: `docker-compose restart`
6. **Clean rebuild**: `./scripts/docker-cleanup.sh && ./scripts/docker-deploy.sh`

## 🔒 Security Features

### Container Security
- ✅ Non-root user execution
- ✅ Read-only filesystem
- ✅ No new privileges
- ✅ Security headers
- ✅ Rate limiting

### Network Security
- ✅ Isolated Docker network
- ✅ CORS configuration
- ✅ API rate limiting
- ✅ Health check endpoints

## 📊 Performance Optimization

### Resource Limits
```yaml
# In docker-compose.yml
services:
  algofi-tracker:
    deploy:
      resources:
        limits:
          memory: 512M
          cpus: '0.5'
```

### Scaling
```bash
# Scale backend services
docker-compose up --scale algofi-tracker=3

# Load balancing with Nginx
# Configure upstream in nginx.conf
```

## 🔄 Updates & Maintenance

### Update Application
```bash
# Pull latest changes
git pull origin main

# Rebuild and restart
docker-compose up --build -d

# Or use script
./scripts/docker-deploy.sh
```

### Backup Data
```bash
# Backup volumes
docker run --rm -v algofi_logs:/data -v $(pwd):/backup alpine tar czf /backup/backup.tar.gz /data

# Backup configuration
cp docker-compose.yml docker-compose.backup.yml
```

## 🆘 Getting Help

### Check Application Status
```bash
# Quick health check
curl -f http://localhost:8000/api/health && echo "✅ Healthy" || echo "❌ Unhealthy"

# Detailed status
docker-compose ps
docker stats --no-stream
```

### Common Commands Reference
```bash
# Start everything
docker-compose up -d

# Stop everything
docker-compose down

# View logs
docker-compose logs -f

# Restart service
docker-compose restart algofi-tracker

# Rebuild and start
docker-compose up --build -d

# Clean everything
docker-compose down && docker system prune -f
```

### Support Resources
- **Docker Documentation**: https://docs.docker.com/
- **Docker Desktop Troubleshooting**: https://docs.docker.com/desktop/troubleshoot/
- **Project Issues**: Check application logs and container status

---

## 🎉 Success!

If everything is working correctly, you should see:

1. **✅ Containers running**: `docker-compose ps` shows "Up" status
2. **✅ Health check passing**: `curl http://localhost:8000/api/health` returns success
3. **✅ Frontend accessible**: http://localhost:3000 loads the React application
4. **✅ Backend accessible**: http://localhost:8000/api returns API responses

**Enjoy your Algofi Tracker application running on Docker Desktop! 🚀**