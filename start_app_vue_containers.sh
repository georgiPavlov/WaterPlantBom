#!/bin/bash

# 🐳 Start WaterPlantApp and WaterVue Containers (Without Operator)
# This script starts only the backend and frontend components in containers

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_header() {
    echo -e "${PURPLE}========================================${NC}"
    echo -e "${PURPLE}🌱 WaterPlantApp + WaterVue (Containers)${NC}"
    echo -e "${PURPLE}========================================${NC}"
}

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

print_url() {
    echo -e "${CYAN}🌐 $1${NC}"
}

# Function to check if podman is installed
check_podman() {
    if ! command -v podman &> /dev/null; then
        print_error "Podman is not installed. Please install podman first."
        exit 1
    fi
    
    if ! command -v podman-compose &> /dev/null; then
        print_error "podman-compose is not installed. Please install podman-compose first."
        exit 1
    fi
    
    print_success "Podman and podman-compose are available"
}

# Function to create shared network
create_network() {
    print_status "Creating shared network..."
    if ! podman network exists waterplant-network; then
        podman network create waterplant-network
        print_success "Created waterplant-network"
    else
        print_warning "waterplant-network already exists"
    fi
}

# Function to stop existing containers
stop_existing_containers() {
    print_status "Stopping existing containers..."
    
    # Stop only WaterPlantApp and WaterVue containers
    podman stop waterplantapp 2>/dev/null || true
    podman stop watervue 2>/dev/null || true
    
    # Remove containers if they exist
    podman rm waterplantapp 2>/dev/null || true
    podman rm watervue 2>/dev/null || true
    
    print_success "Stopped existing WaterPlantApp and WaterVue containers"
}

# Function to start WaterPlantApp
start_waterplantapp() {
    print_status "Starting WaterPlantApp container..."
    cd WaterPlantApp
    
    # Build and start WaterPlantApp
    podman-compose up -d --build
    
    # Wait for WaterPlantApp to be ready
    print_status "Waiting for WaterPlantApp to be ready..."
    for i in {1..30}; do
        if curl -s http://localhost:8001/admin/ > /dev/null 2>&1; then
            print_success "WaterPlantApp is ready!"
            break
        fi
        if [ $i -eq 30 ]; then
            print_error "WaterPlantApp failed to start within 30 seconds"
            exit 1
        fi
        sleep 1
    done
    
    cd ..
}

# Function to start WaterVue
start_watervue() {
    print_status "Starting WaterVue container..."
    cd WaterVue
    
    # Build and start WaterVue
    podman-compose up -d --build
    
    # Wait for WaterVue to be ready
    print_status "Waiting for WaterVue to be ready..."
    for i in {1..30}; do
        if curl -s http://localhost:3000/ > /dev/null 2>&1; then
            print_success "WaterVue is ready!"
            break
        fi
        if [ $i -eq 30 ]; then
            print_error "WaterVue failed to start within 30 seconds"
            exit 1
        fi
        sleep 1
    done
    
    cd ..
}

# Function to create production user
create_production_user() {
    print_status "Creating production user..."
    cd WaterPlantApp
    
    # Create production user
    python3 create_production_user.py
    
    cd ..
    print_success "Production user created"
}

# Function to show system status
show_status() {
    print_status "System Status:"
    echo ""
    echo "🌐 WaterVue Frontend:     http://localhost:3000"
    echo "🔧 WaterPlantApp API:     http://localhost:8001"
    echo "📊 Admin Panel:          http://localhost:8001/admin/"
    echo ""
    echo "👤 Login Credentials:"
    echo "   Username: testuser"
    echo "   Password: testpass123"
    echo ""
    echo "📊 Container Status:"
    podman ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep -E "(waterplantapp|watervue|NAMES)"
}

# Main execution
main() {
    print_header
    
    # Check prerequisites
    check_podman
    
    # Create shared network
    create_network
    
    # Stop existing containers
    stop_existing_containers
    
    # Start services in order
    start_waterplantapp
    start_watervue
    
    # Create production user
    create_production_user
    
    # Show final status
    echo ""
    show_status
    
    print_success "WaterPlantApp and WaterVue containers started successfully! 🎉"
    print_status "You can now access the system at http://localhost:3000"
    print_warning "Note: WaterPlantOperator is not running. Hardware control features will not be available."
}

# Run main function
main "$@"
