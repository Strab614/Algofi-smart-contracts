#!/bin/bash

# Docker build script for Algofi Tracker
set -e

echo "🐳 Building Algofi Tracker Docker images..."

# Clean up any existing containers first
echo "🧹 Cleaning up existing containers..."
docker-compose down --remove-orphans 2>/dev/null || true
docker-compose -f docker-compose.dev.yml down --remove-orphans 2>/dev/null || true

# Build development image
echo "📦 Building development image..."
docker build --target development -t algofi-tracker:dev . --no-cache

# Build production image
echo "🚀 Building production image..."
docker build --target production -t algofi-tracker:latest . --no-cache

# Tag with version
VERSION=$(node -p "require('./package.json').version" 2>/dev/null || echo "1.0.0")
docker tag algofi-tracker:latest algofi-tracker:$VERSION

echo "✅ Build complete!"
echo "Images created:"
echo "  - algofi-tracker:dev (development)"
echo "  - algofi-tracker:latest (production)"
echo "  - algofi-tracker:$VERSION (versioned)"

# Test the build by checking if vite is available
echo "🔍 Testing build dependencies..."
docker run --rm algofi-tracker:dev npx vite --version || echo "⚠️ Vite not found in dev image"