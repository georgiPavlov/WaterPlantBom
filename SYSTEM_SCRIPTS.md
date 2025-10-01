# System Management Scripts

This document describes the system management scripts available in the WaterVue project for controlling the complete Water Plant Automation System.

## 📋 Available Scripts

### Complete System Scripts

#### 1. `start_complete_system.sh`

**Purpose**: Starts all three components of the Water Plant Automation System.

**What it does**:
- Starts WaterPlantApp (Django backend) on port 8001
- Starts WaterVue (Vue.js frontend) on port 3000
- Starts WaterPlantOperator (hardware controller) on port 8000
- Sets up database migrations
- Creates production user for authentication
- Monitors service startup and reports status

**Usage**:
```bash
./start_complete_system.sh
```

**Output**: Displays system status, URLs, credentials, and process information.

#### 2. `stop_complete_system.sh`

**Purpose**: Stops all running services of the Water Plant Automation System.

**What it does**:
- Stops WaterPlantApp Django server
- Stops WaterVue development server
- Stops WaterPlantOperator hardware controller
- Cleans up any remaining processes
- Verifies all services are stopped

**Usage**:
```bash
./stop_complete_system.sh
```

**Output**: Confirms all services have been stopped.

#### 3. `check_system_status.sh`

**Purpose**: Checks the current status of all system components.

**What it does**:
- Tests WaterPlantApp backend connectivity
- Tests WaterVue frontend accessibility
- Tests WaterPlantOperator hardware controller
- Displays login credentials
- Reports overall system health

**Usage**:
```bash
./check_system_status.sh
```

**Output**: Status report for each component (✅ Running or ❌ Not responding).

#### 4. `test_complete_integration.py`

**Purpose**: Runs comprehensive integration tests for the complete system.

**What it does**:
- Tests WaterPlantApp server connectivity
- Tests WaterVue frontend accessibility
- Tests JWT authentication flow
- Tests API endpoints functionality
- Tests device creation workflow
- Provides detailed test results

**Usage**:
```bash
python3 test_complete_integration.py
```

**Output**: Detailed test results with pass/fail status for each test.

#### 5. `create_production_user.py`

**Purpose**: Creates or updates the production user for API authentication.

**What it does**:
- Creates/updates user in the main Django database
- Sets up user with proper permissions (staff, superuser)
- Tests authentication to verify user works
- Displays user credentials

**Usage**:
```bash
python3 create_production_user.py
```

**Output**: User creation status and credentials.

### App + Vue Only Scripts (Without Operator)

#### 6. `start_app_vue_containers.sh`

**Purpose**: Starts only WaterPlantApp and WaterVue in containers (without WaterPlantOperator).

**What it does**:
- Creates shared network for container communication
- Builds and starts WaterPlantApp container on port 8001
- Builds and starts WaterVue container on port 3000
- Waits for services to be ready
- Creates production user for authentication
- Shows system status and access URLs

**Usage**:
```bash
./start_app_vue_containers.sh
```

**Output**: Container status, access URLs, and credentials.

#### 7. `stop_app_vue_containers.sh`

**Purpose**: Stops and removes WaterPlantApp and WaterVue containers.

**What it does**:
- Stops WaterPlantApp container
- Stops WaterVue container
- Removes containers
- Shows remaining containers

**Usage**:
```bash
./stop_app_vue_containers.sh
```

**Output**: Confirmation of stopped containers.

#### 8. `start_app_vue_local.sh`

**Purpose**: Starts only WaterPlantApp and WaterVue as local processes (without WaterPlantOperator).

**What it does**:
- Sets up Django database if needed
- Creates production user
- Starts Django development server on port 8001
- Starts Vite development server on port 3000/3001
- Creates status check script
- Shows comprehensive system information

**Usage**:
```bash
./start_app_vue_local.sh
```

**Output**: Process information, access URLs, credentials, and log file locations.

#### 9. `stop_app_vue_local.sh`

**Purpose**: Stops all local WaterPlantApp and WaterVue processes.

**What it does**:
- Stops processes by PID files
- Kills processes by name pattern
- Cleans up any remaining processes
- Shows port status
- Provides detailed feedback

**Usage**:
```bash
./stop_app_vue_local.sh
```

**Output**: Process stop confirmation and port status.

## 🎯 When to Use Which Scripts

### Complete System Scripts
Use these when you need the full system with hardware control:
- **Development with hardware**: When testing with actual sensors and pumps
- **Full integration testing**: When testing all components together
- **Production deployment**: When deploying the complete system

### App + Vue Only Scripts
Use these when you don't need hardware control:
- **Frontend/Backend development**: When working on UI or API features
- **Demo/testing without hardware**: When showing the system without physical devices
- **Lightweight development**: When you want faster startup and fewer resources
- **API testing**: When testing backend functionality without hardware dependencies

## 🔧 Script Configuration

### Directory Structure

The scripts expect the following directory structure:
```
project_root/
├── WaterVue/              # Frontend (where scripts are located)
├── WaterPlantApp/         # Backend
└── WaterPlantOperator/    # Hardware controller
```

### Port Configuration

Default ports used by the system:
- **WaterPlantApp**: 8001
- **WaterVue**: 3000
- **WaterPlantOperator**: 8000

### Log Files

All scripts create log files in the `logs/` directory:
- `logs/waterplantapp.log` - Backend logs
- `logs/watervue.log` - Frontend logs
- `logs/waterplantoperator.log` - Hardware controller logs

### Process Management

Scripts use PID files to track running processes:
- `logs/waterplantapp.pid`
- `logs/watervue.pid`
- `logs/waterplantoperator.pid`

## 🚀 Quick Start Workflow

### 1. Start the System
```bash
cd WaterVue
./start_complete_system.sh
```

### 2. Check Status
```bash
./check_system_status.sh
```

### 3. Run Tests
```bash
python3 test_complete_integration.py
```

### 4. Stop the System
```bash
./stop_complete_system.sh
```

## 🛠️ Script Customization

### Changing Ports

To change the ports used by the system, edit the scripts:

1. **start_complete_system.sh**: Update port numbers in the script
2. **test_complete_integration.py**: Update URLs in the IntegrationTester class

### Adding New Services

To add a new service to the system:

1. Add startup logic to `start_complete_system.sh`
2. Add stop logic to `stop_complete_system.sh`
3. Add status check to `check_system_status.sh`
4. Add tests to `test_complete_integration.py`

### Custom Logging

Scripts use colored output for better readability:
- 🔵 Blue: Information messages
- 🟢 Green: Success messages
- 🟡 Yellow: Warning messages
- 🔴 Red: Error messages
- 🟣 Purple: Headers and important information

## 🔍 Troubleshooting Scripts

### Common Issues

1. **Permission Denied**:
   ```bash
   chmod +x *.sh
   ```

2. **Script Not Found**:
   ```bash
   # Ensure you're in the WaterVue directory
   ls -la *.sh
   ```

3. **Services Won't Start**:
   ```bash
   # Check if ports are already in use
   lsof -i :8001
   lsof -i :3000
   lsof -i :8000
   ```

4. **Database Issues**:
   ```bash
   # Run migrations manually
   cd ../WaterPlantApp/pycharmtut
   python3 manage.py migrate
   ```

### Debug Mode

To run scripts with more verbose output, you can modify them to include debug flags:

```bash
# Add -x flag to bash scripts for debugging
bash -x start_complete_system.sh
```

## 📊 Script Dependencies

### System Requirements

- **Bash**: For shell scripts
- **Python 3.9+**: For Python scripts
- **Node.js 16+**: For frontend
- **npm**: For frontend dependencies
- **curl**: For HTTP testing
- **lsof**: For port checking

### Python Dependencies

The Python scripts require:
- `requests` - For HTTP requests
- `django` - For Django integration
- `djangorestframework` - For API functionality

## 🔄 Script Lifecycle

### Startup Sequence

1. **Cleanup**: Kill any existing processes
2. **Backend**: Start Django server with database setup
3. **Frontend**: Start Vue.js development server
4. **Hardware**: Start hardware controller
5. **Verification**: Check all services are running
6. **Reporting**: Display system status and credentials

### Shutdown Sequence

1. **Graceful Stop**: Send SIGTERM to all processes
2. **Force Stop**: Send SIGKILL if needed
3. **Cleanup**: Remove PID files
4. **Verification**: Confirm all services stopped

## 📝 Script Maintenance

### Regular Maintenance

1. **Update Dependencies**: Keep Python and Node.js dependencies updated
2. **Check Logs**: Regularly review log files for issues
3. **Test Scripts**: Run integration tests regularly
4. **Backup Data**: Backup database and configuration files

### Version Control

All scripts are version controlled and should be committed with the project. Changes to scripts should be tested thoroughly before deployment.

---

**Note**: These scripts are designed for development and testing environments. For production deployment, consider using proper process managers like systemd, PM2, or Docker.


