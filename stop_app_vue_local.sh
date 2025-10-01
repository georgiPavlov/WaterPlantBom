#!/bin/bash

# 🛑 Stop WaterPlantApp and WaterVue Local Services
# This script stops only the backend and frontend local processes

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

# Function to stop processes by PID file
stop_by_pid_file() {
    local pid_file=$1
    local service_name=$2
    
    if [ -f "$pid_file" ]; then
        local pid=$(cat "$pid_file")
        if ps -p "$pid" > /dev/null 2>&1; then
            kill "$pid" 2>/dev/null || true
            sleep 2
            if ps -p "$pid" > /dev/null 2>&1; then
                kill -9 "$pid" 2>/dev/null || true
            fi
            print_success "Stopped $service_name (PID: $pid)"
        else
            print_warning "$service_name process (PID: $pid) was not running"
        fi
        rm -f "$pid_file"
    else
        print_warning "No PID file found for $service_name"
    fi
}

# Function to stop processes by name
stop_by_process_name() {
    local process_pattern=$1
    local service_name=$2
    
    local pids=$(pgrep -f "$process_pattern" 2>/dev/null || true)
    if [ -n "$pids" ]; then
        echo "$pids" | xargs kill 2>/dev/null || true
        sleep 2
        # Force kill if still running
        local remaining_pids=$(pgrep -f "$process_pattern" 2>/dev/null || true)
        if [ -n "$remaining_pids" ]; then
            echo "$remaining_pids" | xargs kill -9 2>/dev/null || true
        fi
        print_success "Stopped $service_name processes"
    else
        print_warning "No $service_name processes found"
    fi
}

# Main execution
main() {
    echo "🛑 Stopping WaterPlantApp and WaterVue Local Services"
    echo "===================================================="
    
    # Stop WaterPlantApp
    print_status "Stopping WaterPlantApp..."
    stop_by_pid_file "logs/waterplantapp.pid" "WaterPlantApp"
    stop_by_process_name "manage.py runserver" "WaterPlantApp"
    
    # Stop WaterVue
    print_status "Stopping WaterVue..."
    stop_by_pid_file "logs/watervue.pid" "WaterVue"
    stop_by_process_name "vite" "WaterVue"
    
    # Clean up any remaining processes
    print_status "Cleaning up any remaining processes..."
    pkill -f "manage.py runserver" 2>/dev/null || true
    pkill -f "vite" 2>/dev/null || true
    
    # Show remaining processes
    echo ""
    print_status "Checking for remaining processes..."
    local remaining_waterplantapp=$(pgrep -f "manage.py runserver" 2>/dev/null || true)
    local remaining_watervue=$(pgrep -f "vite" 2>/dev/null || true)
    
    if [ -n "$remaining_waterplantapp" ] || [ -n "$remaining_watervue" ]; then
        print_warning "Some processes may still be running:"
        if [ -n "$remaining_waterplantapp" ]; then
            echo "  WaterPlantApp PIDs: $remaining_waterplantapp"
        fi
        if [ -n "$remaining_watervue" ]; then
            echo "  WaterVue PIDs: $remaining_watervue"
        fi
        echo "  You may need to kill them manually: kill -9 <PID>"
    else
        print_success "All WaterPlantApp and WaterVue processes stopped"
    fi
    
    # Show port status
    echo ""
    print_status "Port status:"
    if lsof -Pi :8001 -sTCP:LISTEN -t >/dev/null 2>&1; then
        print_warning "Port 8001 (WaterPlantApp) is still in use"
    else
        print_success "Port 8001 (WaterPlantApp) is free"
    fi
    
    if lsof -Pi :3000 -sTCP:LISTEN -t >/dev/null 2>&1; then
        print_warning "Port 3000 (WaterVue) is still in use"
    else
        print_success "Port 3000 (WaterVue) is free"
    fi
    
    if lsof -Pi :3001 -sTCP:LISTEN -t >/dev/null 2>&1; then
        print_warning "Port 3001 (WaterVue alt) is still in use"
    else
        print_success "Port 3001 (WaterVue alt) is free"
    fi
    
    print_success "WaterPlantApp and WaterVue local services stopped successfully!"
}

# Run main function
main "$@"
