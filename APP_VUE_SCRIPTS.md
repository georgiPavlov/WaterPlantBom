# WaterPlantApp + WaterVue Startup Scripts

This document describes the scripts for starting only the WaterPlantApp (backend) and WaterVue (frontend) components without the WaterPlantOperator.

## Available Scripts

### Container Scripts

#### `start_app_vue_containers.sh`
Starts WaterPlantApp and WaterVue in containers using podman-compose.

**Features:**
- Creates shared network for container communication
- Builds and starts containers with proper dependencies
- Waits for services to be ready
- Creates production user for authentication
- Shows system status and access URLs

**Usage:**
```bash
./start_app_vue_containers.sh
```

**Access URLs:**
- Frontend: http://localhost:3000
- Backend API: http://localhost:8001
- Admin Panel: http://localhost:8001/admin/

#### `stop_app_vue_containers.sh`
Stops and removes WaterPlantApp and WaterVue containers.

**Usage:**
```bash
./stop_app_vue_containers.sh
```

### Local Scripts

#### `start_app_vue_local.sh`
Starts WaterPlantApp and WaterVue as local processes (not containerized).

**Features:**
- Sets up Django database if needed
- Creates production user
- Starts Django development server on port 8001
- Starts Vite development server on port 3000/3001
- Creates status check script
- Shows comprehensive system information

**Usage:**
```bash
./start_app_vue_local.sh
```

**Access URLs:**
- Frontend: http://localhost:3000 (or 3001)
- Backend API: http://localhost:8001
- Admin Panel: http://localhost:8001/admin/

#### `stop_app_vue_local.sh`
Stops all local WaterPlantApp and WaterVue processes.

**Features:**
- Stops processes by PID files
- Kills processes by name pattern
- Cleans up any remaining processes
- Shows port status
- Provides detailed feedback

**Usage:**
```bash
./stop_app_vue_local.sh
```

## Prerequisites

### For Container Scripts
- Podman installed and running
- podman-compose installed
- Dockerfiles and podman-compose.yml files in WaterPlantApp and WaterVue directories

### For Local Scripts
- Python 3.x installed
- Node.js and npm installed
- Django dependencies installed in WaterPlantApp
- Vue.js dependencies installed in WaterVue

## Default Credentials

Both container and local setups use the same default credentials:
- **Username:** testuser
- **Password:** testpass123

## Log Files

### Container Logs
Container logs are available through podman:
```bash
podman logs waterplantapp
podman logs watervue
```

### Local Logs
Local logs are stored in the `logs/` directory:
- `logs/waterplantapp.log` - Django backend logs
- `logs/watervue.log` - Vue.js frontend logs

## Status Checking

### Container Status
```bash
podman ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
```

### Local Status
The local startup script creates `check_app_vue_status.sh` for easy status checking:
```bash
./check_app_vue_status.sh
```

## Important Notes

⚠️ **Hardware Control Limitations:**
- These scripts do NOT start the WaterPlantOperator
- Hardware control features will not be available
- The system will run in "demo mode" without physical device control

## Troubleshooting

### Common Issues

1. **Port Already in Use:**
   - Check if services are already running: `ps aux | grep -E '(manage.py|vite)'`
   - Stop existing services: `./stop_app_vue_local.sh`

2. **Container Build Failures:**
   - Ensure Dockerfiles exist in WaterPlantApp and WaterVue directories
   - Check podman is running: `podman info`

3. **Database Issues:**
   - Delete `WaterPlantApp/pycharmtut/db.sqlite3` and restart
   - The script will recreate the database automatically

4. **Dependencies Missing:**
   - For local: Run `npm install` in WaterVue directory
   - For containers: Ensure Dockerfiles install dependencies

### Getting Help

- Check log files for detailed error messages
- Verify all prerequisites are installed
- Ensure you're running scripts from the project root directory

## Integration with Full System

These scripts are designed to work alongside the full system scripts:
- `start_complete_system.sh` - Starts all components including operator
- `start_all_containers.sh` - Starts all components in containers
- `stop_complete_system.sh` - Stops all components

The app+vue scripts provide a lightweight alternative when hardware control is not needed.
