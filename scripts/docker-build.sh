#!/bin/bash

# Docker build script for Algofi Tracker
set -e

echo "🐳 Building Algofi Tracker Docker images..."

# Build development image
echo "📦 Building development image..."
docker build --target development -t algofi-tracker:dev .

# Build production image
echo "🚀 Building production image..."
docker build --target production -t algofi-tracker:latest .

# Tag with version
VERSION=$(node -p "require('./package.json').version")
docker tag algofi-tracker:latest algofi-tracker:$VERSION

echo "✅ Build complete!"
echo "Images created:"
echo "  - algofi-tracker:dev (development)"
echo "  - algofi-tracker:latest (production)"
echo "  - algofi-tracker:$VERSION (versioned)"