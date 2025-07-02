# 🖥️ Docker Desktop GUI Instructions

Step-by-step guide to run Algofi Tracker using Docker Desktop's graphical interface.

## 📋 Prerequisites

1. **Docker Desktop installed and running**
2. **Project files downloaded to your computer**
3. **Ports 3000 and 8000 available**

## 🚀 Method 1: Using Docker Desktop Dashboard

### Step 1: Build the Image

1. **Open Docker Desktop**
2. **Navigate to the "Images" tab**
3. **Click "Build an image" or the "+" button**
4. **Select "Build from Dockerfile"**
5. **Browse and select your project folder**
6. **Set image name**: `algofi-tracker:latest`
7. **Click "Build"**

### Step 2: Run the Container

1. **Go to "Images" tab**
2. **Find `algofi-tracker:latest`**
3. **Click the "Run" button (▶️)**
4. **Configure container settings**:
   - **Container name**: `algofi-tracker-app`
   - **Ports**: 
     - Host port `3000` → Container port `3000`
     - Host port `8000` → Container port `8000`
   - **Environment variables** (optional):
     - `NODE_ENV=production`
     - `PORT=8000`
5. **Click "Run"**

### Step 3: Verify Running Container

1. **Go to "Containers" tab**
2. **Check that `algofi-tracker-app` is running**
3. **Click on the container name to view details**
4. **Check logs for any errors**

## 🔧 Method 2: Using Docker Compose in GUI

### Step 1: Import Compose File

1. **Open Docker Desktop**
2. **Go to "Compose" or "Stacks" tab**
3. **Click "Create Stack" or "Import"**
4. **Select your `docker-compose.yml` file**
5. **Name your stack**: `algofi-tracker`

### Step 2: Deploy Stack

1. **Review the compose configuration**
2. **Click "Deploy" or "Start"**
3. **Wait for all services to start**

### Step 3: Monitor Services

1. **View running services in the stack**
2. **Check individual container logs**
3. **Monitor resource usage**

## 📱 Method 3: Using Docker Desktop Extensions

### Step 1: Install Useful Extensions

1. **Go to "Extensions" tab in Docker Desktop**
2. **Install recommended extensions**:
   - **Logs Explorer** - Better log viewing
   - **Resource Usage** - Monitor container resources
   - **Disk Usage** - Manage Docker storage

### Step 2: Use Extensions

1. **Use Logs Explorer to view application logs**
2. **Monitor resource usage during operation**
3. **Clean up unused images and containers**

## 🔍 Monitoring Your Application

### View Container Logs

1. **Go to "Containers" tab**
2. **Click on `algofi-tracker-app`**
3. **Click "Logs" tab**
4. **Enable "Follow logs" for real-time updates**

### Check Resource Usage

1. **Go to "Containers" tab**
2. **View CPU and Memory usage columns**
3. **Click on container for detailed stats**

### Access Container Terminal

1. **Go to "Containers" tab**
2. **Click on `algofi-tracker-app`**
3. **Click "Terminal" or "Exec" tab**
4. **Run commands inside the container**

## 🌐 Accessing Your Application

Once the container is running:

1. **Open your web browser**
2. **Navigate to**: http://localhost:3000
3. **API available at**: http://localhost:8000
4. **Health check**: http://localhost:8000/api/health

## 🛠️ Managing Your Container

### Start/Stop Container

1. **Go to "Containers" tab**
2. **Use the play/pause buttons** to start/stop
3. **Use the stop button** to gracefully stop

### Restart Container

1. **Go to "Containers" tab**
2. **Click the restart button** (🔄)
3. **Wait for container to restart**

### Update Container

1. **Stop the running container**
2. **Rebuild the image** (Method 1, Step 1)
3. **Run new container** with updated image

## 🔧 Troubleshooting in GUI

### Container Won't Start

1. **Check "Logs" tab for error messages**
2. **Verify port configuration**
3. **Check if ports are already in use**
4. **Review environment variables**

### Application Not Accessible

1. **Verify container is running** (green status)
2. **Check port mappings** in container details
3. **Test health endpoint**: http://localhost:8000/api/health
4. **Review application logs**

### High Resource Usage

1. **Check "Stats" in container details**
2. **Review logs for errors or warnings**
3. **Consider resource limits**:
   - Go to container settings
   - Set memory and CPU limits

## 📊 Docker Desktop Settings

### Optimize for Performance

1. **Go to Docker Desktop Settings**
2. **Resources tab**:
   - **Memory**: Allocate at least 4GB
   - **CPU**: Allocate at least 2 cores
   - **Disk**: Ensure sufficient space
3. **Apply & Restart**

### Configure Network

1. **Go to Settings → Network**
2. **Verify network settings**
3. **Check firewall settings if needed**

## 🔄 Development Workflow

### For Development Mode

1. **Use `docker-compose.dev.yml`**
2. **Enable volume mounting** for live code updates
3. **Use development image** with hot reload

### For Production Mode

1. **Use `docker-compose.yml`**
2. **Use production image** (optimized)
3. **Enable health checks**

## 🆘 Getting Help

### Docker Desktop Help

1. **Click "Help" in Docker Desktop**
2. **Access documentation and tutorials**
3. **Check troubleshooting guides**

### Application-Specific Help

1. **Check container logs** for error messages
2. **Verify health endpoint** is responding
3. **Review Docker Compose configuration**

### Common Solutions

1. **Restart Docker Desktop** if containers won't start
2. **Clear Docker cache**: Settings → Troubleshoot → Clean/Purge data
3. **Check available disk space**
4. **Verify network connectivity**

## ✅ Success Checklist

- [ ] Docker Desktop is running
- [ ] Container shows "Running" status
- [ ] Frontend accessible at http://localhost:3000
- [ ] Backend API responds at http://localhost:8000
- [ ] Health check passes at http://localhost:8000/api/health
- [ ] No error messages in container logs

## 🎉 You're Done!

Your Algofi Tracker application is now running successfully on Docker Desktop! 

**Next Steps:**
1. Explore the application interface
2. Test the API endpoints
3. Monitor performance in Docker Desktop
4. Set up automated backups if needed

**Need more help?** Check the main `DOCKER_DESKTOP_GUIDE.md` for detailed command-line instructions and advanced configuration options.