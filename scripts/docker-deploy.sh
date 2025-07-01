#!/bin/bash

# Docker deployment script
set -e

echo "🚀 Deploying Algofi Tracker to Docker Desktop..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker Desktop."
    exit 1
fi

# Build images
echo "📦 Building Docker images..."
./scripts/docker-build.sh

# Create network if it doesn't exist
echo "🌐 Creating Docker network..."
docker network create algofi-network 2>/dev/null || true

# Start production environment
echo "🏭 Starting production deployment..."
docker-compose up -d

# Wait for services to be ready
echo "⏳ Waiting for services to start..."
sleep 10

# Health check
echo "🔍 Performing health check..."
if curl -f http://localhost:8000/api/health > /dev/null 2>&1; then
    echo "✅ Deployment successful!"
    echo ""
    echo "🌐 Application URLs:"
    echo "  Frontend: http://localhost:3000"
    echo "  Backend API: http://localhost:8000"
    echo "  Health Check: http://localhost:8000/api/health"
    echo ""
    echo "📊 Container Status:"
    docker-compose ps
else
    echo "❌ Health check failed. Checking logs..."
    docker-compose logs
    exit 1
fi