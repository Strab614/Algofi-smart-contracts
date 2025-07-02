#!/bin/bash

# Docker Desktop Setup Script for Algofi Tracker
# This script automates the entire setup process for Docker Desktop

set -e

echo "🐳 Algofi Tracker - Docker Desktop Setup"
echo "========================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Docker is installed and running
check_docker() {
    print_status "Checking Docker installation..."
    
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed!"
        echo "Please install Docker Desktop from: https://www.docker.com/products/docker-desktop"
        exit 1
    fi
    
    if ! docker info &> /dev/null; then
        print_error "Docker is not running!"
        echo "Please start Docker Desktop and try again."
        exit 1
    fi
    
    print_success "Docker is installed and running"
    docker --version
}

# Check if Docker Compose is available
check_docker_compose() {
    print_status "Checking Docker Compose..."
    
    if ! command -v docker-compose &> /dev/null; then
        print_error "Docker Compose is not available!"
        echo "Please ensure Docker Desktop is properly installed."
        exit 1
    fi
    
    print_success "Docker Compose is available"
    docker-compose --version
}

# Check if required ports are available
check_ports() {
    print_status "Checking port availability..."
    
    if lsof -Pi :3000 -sTCP:LISTEN -t >/dev/null 2>&1; then
        print_warning "Port 3000 is already in use"
        echo "Please stop the service using port 3000 or modify docker-compose.yml"
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
    
    if lsof -Pi :8000 -sTCP:LISTEN -t >/dev/null 2>&1; then
        print_warning "Port 8000 is already in use"
        echo "Please stop the service using port 8000 or modify docker-compose.yml"
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
    
    print_success "Ports are available"
}

# Make scripts executable
setup_scripts() {
    print_status "Setting up scripts..."
    
    chmod +x scripts/*.sh 2>/dev/null || true
    
    print_success "Scripts are now executable"
}

# Build Docker images
build_images() {
    print_status "Building Docker images..."
    
    echo "This may take a few minutes on first run..."
    
    # Build development image
    print_status "Building development image..."
    docker build --target development -t algofi-tracker:dev . || {
        print_error "Failed to build development image"
        exit 1
    }
    
    # Build production image
    print_status "Building production image..."
    docker build --target production -t algofi-tracker:latest . || {
        print_error "Failed to build production image"
        exit 1
    }
    
    print_success "Docker images built successfully"
}

# Create Docker network
create_network() {
    print_status "Creating Docker network..."
    
    docker network create algofi-network 2>/dev/null || {
        print_warning "Network 'algofi-network' already exists"
    }
    
    print_success "Docker network ready"
}

# Start the application
start_application() {
    print_status "Starting Algofi Tracker application..."
    
    # Ask user for deployment mode
    echo ""
    echo "Choose deployment mode:"
    echo "1) Development (with hot reload)"
    echo "2) Production (optimized)"
    read -p "Enter choice (1 or 2): " -n 1 -r
    echo ""
    
    case $REPLY in
        1)
            print_status "Starting in development mode..."
            docker-compose -f docker-compose.dev.yml up -d
            FRONTEND_URL="http://localhost:3000"
            BACKEND_URL="http://localhost:8000"
            ;;
        2)
            print_status "Starting in production mode..."
            docker-compose up -d
            FRONTEND_URL="http://localhost:3000"
            BACKEND_URL="http://localhost:8000"
            ;;
        *)
            print_error "Invalid choice"
            exit 1
            ;;
    esac
    
    print_success "Application started successfully"
}

# Wait for services to be ready
wait_for_services() {
    print_status "Waiting for services to start..."
    
    # Wait up to 60 seconds for the backend to be ready
    for i in {1..60}; do
        if curl -f http://localhost:8000/api/health >/dev/null 2>&1; then
            print_success "Backend is ready!"
            break
        fi
        
        if [ $i -eq 60 ]; then
            print_error "Backend failed to start within 60 seconds"
            echo "Check logs with: docker-compose logs"
            exit 1
        fi
        
        echo -n "."
        sleep 1
    done
    echo ""
}

# Perform health checks
health_check() {
    print_status "Performing health checks..."
    
    # Check backend health
    if curl -f http://localhost:8000/api/health >/dev/null 2>&1; then
        print_success "✅ Backend health check passed"
    else
        print_error "❌ Backend health check failed"
        return 1
    fi
    
    # Check if frontend is accessible
    if curl -f http://localhost:3000 >/dev/null 2>&1; then
        print_success "✅ Frontend is accessible"
    else
        print_warning "⚠️ Frontend may still be starting up"
    fi
    
    # Show container status
    print_status "Container status:"
    docker-compose ps
}

# Display success information
show_success_info() {
    echo ""
    echo "🎉 Algofi Tracker is now running on Docker Desktop!"
    echo "=================================================="
    echo ""
    echo "📱 Access your application:"
    echo "   🖥️  Frontend:     http://localhost:3000"
    echo "   🔌 Backend API:   http://localhost:8000"
    echo "   ❤️  Health Check: http://localhost:8000/api/health"
    echo ""
    echo "🛠️ Useful commands:"
    echo "   📋 View logs:     docker-compose logs -f"
    echo "   📊 Check status:  docker-compose ps"
    echo "   🔄 Restart:       docker-compose restart"
    echo "   🛑 Stop:          docker-compose down"
    echo ""
    echo "🔧 Management scripts:"
    echo "   ./scripts/docker-logs.sh     - View application logs"
    echo "   ./scripts/docker-run.sh      - Start/stop services"
    echo "   ./scripts/docker-cleanup.sh  - Clean up resources"
    echo ""
    print_success "Setup completed successfully! 🚀"
}

# Cleanup function for errors
cleanup_on_error() {
    print_error "Setup failed. Cleaning up..."
    docker-compose down 2>/dev/null || true
    docker-compose -f docker-compose.dev.yml down 2>/dev/null || true
}

# Main execution
main() {
    # Set trap for cleanup on error
    trap cleanup_on_error ERR
    
    echo "Starting automated setup for Docker Desktop..."
    echo ""
    
    # Run all checks and setup steps
    check_docker
    check_docker_compose
    check_ports
    setup_scripts
    build_images
    create_network
    start_application
    wait_for_services
    health_check
    show_success_info
    
    echo ""
    echo "🎯 Next steps:"
    echo "1. Open http://localhost:3000 in your browser"
    echo "2. Explore the Algofi Tracker interface"
    echo "3. Check the API at http://localhost:8000/api"
    echo ""
    echo "Need help? Check DOCKER_DESKTOP_GUIDE.md for detailed instructions."
}

# Run main function
main "$@"