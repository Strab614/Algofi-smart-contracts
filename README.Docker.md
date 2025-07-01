# Docker Deployment Guide

This guide covers deploying the Algofi Tracker application using Docker and Docker Desktop.

## Prerequisites

- Docker Desktop installed and running
- At least 4GB RAM available for containers
- Ports 3000 and 8000 available on your system

## Quick Start

### 1. Build and Deploy

```bash
# Make scripts executable
chmod +x scripts/*.sh

# Deploy to Docker Desktop
./scripts/docker-deploy.sh
```

### 2. Access the Application

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8000
- **Health Check**: http://localhost:8000/api/health

## Development Setup

### Start Development Environment

```bash
# Start development with hot reload
./scripts/docker-run.sh dev
```

### Development Features

- Hot reload for both frontend and backend
- Source code mounted as volumes
- Development dependencies included
- Debug-friendly configuration

## Production Deployment

### Start Production Environment

```bash
# Start production environment
./scripts/docker-run.sh prod
```

### Production Features

- Optimized multi-stage build
- Security hardening
- Non-root user execution
- Health checks
- Nginx reverse proxy (optional)

## Available Commands

### Build Commands

```bash
# Build all images
./scripts/docker-build.sh

# Build specific target
docker build --target development -t algofi-tracker:dev .
docker build --target production -t algofi-tracker:latest .
```

### Run Commands

```bash
# Development mode
./scripts/docker-run.sh dev

# Production mode
./scripts/docker-run.sh prod

# Stop all services
./scripts/docker-run.sh stop
```

### Monitoring Commands

```bash
# View application logs
./scripts/docker-logs.sh app

# View all logs
./scripts/docker-logs.sh all

# View container status
docker-compose ps
```

### Maintenance Commands

```bash
# Clean up Docker resources
./scripts/docker-cleanup.sh

# Restart services
docker-compose restart

# Update and rebuild
docker-compose up --build -d
```

## Docker Compose Profiles

### Development Profile

```bash
# Start development services only
docker-compose --profile dev up
```

### Production Profile

```bash
# Start production services with Nginx
docker-compose --profile production up
```

## Environment Configuration

### Environment Files

- `.env.docker` - Docker-specific environment variables
- `docker-compose.yml` - Production configuration
- `docker-compose.dev.yml` - Development configuration

### Key Environment Variables

```bash
NODE_ENV=production          # Environment mode
PORT=8000                   # Backend port
FRONTEND_PORT=3000          # Frontend port
ALGORAND_NETWORK=testnet    # Algorand network
LOG_LEVEL=info              # Logging level
```

## Security Features

### Container Security

- Non-root user execution
- Read-only filesystem
- No new privileges
- Security headers via Nginx
- Rate limiting

### Network Security

- Isolated Docker network
- CORS configuration
- API rate limiting
- Health check endpoints

## Monitoring and Logging

### Health Checks

```bash
# Check application health
curl http://localhost:8000/api/health

# Check container health
docker-compose ps
```

### Log Management

```bash
# Real-time logs
docker-compose logs -f

# Specific service logs
docker-compose logs algofi-tracker

# Log rotation (automatic)
# Logs are rotated automatically by Docker
```

## Troubleshooting

### Common Issues

1. **Port conflicts**
   ```bash
   # Check port usage
   lsof -i :3000
   lsof -i :8000
   ```

2. **Memory issues**
   ```bash
   # Check Docker memory usage
   docker stats
   ```

3. **Build failures**
   ```bash
   # Clean build cache
   docker builder prune -f
   
   # Rebuild without cache
   docker-compose build --no-cache
   ```

### Debug Commands

```bash
# Enter running container
docker-compose exec algofi-tracker sh

# Check container logs
docker-compose logs algofi-tracker

# Inspect container
docker inspect algofi-tracker-app
```

## Performance Optimization

### Resource Limits

The containers are configured with appropriate resource limits:

- Memory: 512MB per container
- CPU: 0.5 cores per container
- Disk: Optimized layer caching

### Scaling

```bash
# Scale backend services
docker-compose up --scale algofi-tracker=3

# Load balancing via Nginx
# Configure upstream servers in nginx.conf
```

## Backup and Recovery

### Data Backup

```bash
# Backup volumes
docker run --rm -v algofi_logs:/data -v $(pwd):/backup alpine tar czf /backup/logs-backup.tar.gz /data

# Backup configuration
cp docker-compose.yml docker-compose.yml.backup
```

### Recovery

```bash
# Restore from backup
docker run --rm -v algofi_logs:/data -v $(pwd):/backup alpine tar xzf /backup/logs-backup.tar.gz -C /
```

## Advanced Configuration

### Custom Nginx Configuration

Edit `nginx.conf` to customize:
- SSL/TLS settings
- Rate limiting rules
- Security headers
- Caching policies

### Multi-stage Builds

The Dockerfile uses multi-stage builds for:
- Development environment
- Build optimization
- Production deployment
- Security hardening

## Support

For issues and questions:
1. Check the logs: `./scripts/docker-logs.sh all`
2. Verify health: `curl http://localhost:8000/api/health`
3. Review container status: `docker-compose ps`
4. Clean and rebuild: `./scripts/docker-cleanup.sh && ./scripts/docker-deploy.sh`