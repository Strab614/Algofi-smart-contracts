#!/bin/bash

# Docker run script for Algofi Tracker
set -e

MODE=${1:-production}

echo "🚀 Starting Algofi Tracker in $MODE mode..."

case $MODE in
  "dev"|"development")
    echo "🔧 Starting development environment..."
    docker-compose -f docker-compose.dev.yml up --build
    ;;
  "prod"|"production")
    echo "🏭 Starting production environment..."
    docker-compose up --build -d
    echo "✅ Production environment started!"
    echo "🌐 Frontend: http://localhost:3000"
    echo "🔌 Backend API: http://localhost:8000"
    echo "📊 Health check: http://localhost:8000/api/health"
    ;;
  "stop")
    echo "🛑 Stopping all services..."
    docker-compose down
    docker-compose -f docker-compose.dev.yml down
    ;;
  *)
    echo "Usage: $0 [dev|prod|stop]"
    echo "  dev  - Start development environment"
    echo "  prod - Start production environment"
    echo "  stop - Stop all services"
    exit 1
    ;;
esac