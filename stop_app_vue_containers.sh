#!/bin/bash

# 🛑 Stop WaterPlantApp and WaterVue Containers (Without Operator)
# This script stops only the backend and frontend containers

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Function to stop containers
stop_containers() {
    print_status "Stopping WaterPlantApp and WaterVue containers..."
    
    # Stop containers if they exist
    if podman ps | grep -q waterplantapp; then
        podman stop waterplantapp
        print_success "Stopped WaterPlantApp container"
    else
        print_warning "WaterPlantApp container is not running"
    fi
    
    if podman ps | grep -q watervue; then
        podman stop watervue
        print_success "Stopped WaterVue container"
    else
        print_warning "WaterVue container is not running"
    fi
    
    # Remove containers if they exist
    if podman ps -a | grep -q waterplantapp; then
        podman rm waterplantapp
        print_success "Removed WaterPlantApp container"
    fi
    
    if podman ps -a | grep -q watervue; then
        podman rm watervue
        print_success "Removed WaterVue container"
    fi
}

# Function to show remaining containers
show_remaining_containers() {
    print_status "Remaining containers:"
    if podman ps | grep -q waterplant; then
        podman ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep waterplant
    else
        echo "No WaterPlant containers are running"
    fi
}

# Main execution
main() {
    echo "🛑 Stopping WaterPlantApp and WaterVue Containers"
    echo "================================================"
    
    stop_containers
    
    echo ""
    show_remaining_containers
    
    print_success "WaterPlantApp and WaterVue containers stopped successfully!"
}

# Run main function
main "$@"
