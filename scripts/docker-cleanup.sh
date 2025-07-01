#!/bin/bash

# Docker cleanup script
set -e

echo "🧹 Cleaning up Docker resources..."

# Stop and remove containers
echo "🛑 Stopping containers..."
docker-compose down --remove-orphans
docker-compose -f docker-compose.dev.yml down --remove-orphans

# Remove images
echo "🗑️ Removing images..."
docker rmi algofi-tracker:dev algofi-tracker:latest 2>/dev/null || true

# Remove unused volumes
echo "💾 Cleaning up volumes..."
docker volume prune -f

# Remove unused networks
echo "🌐 Cleaning up networks..."
docker network prune -f

# Remove build cache
echo "🗂️ Cleaning up build cache..."
docker builder prune -f

echo "✅ Cleanup complete!"