# Water Plant Automation System

A complete water plant automation system consisting of three main components:

## 🏗️ System Architecture

```
┌─────────────────┐    HTTP/API    ┌─────────────────┐    HTTP/API    ┌─────────────────┐
│   WaterVue      │◄──────────────►│  WaterPlantApp  │◄──────────────►│ WaterPlantOperator│
│  (Frontend)     │                │   (Backend)     │                │   (Hardware)    │
│  Port: 3000     │                │   Port: 8001    │                │   Port: 8000    │
└─────────────────┘                └─────────────────┘                └─────────────────┘
```

## 📦 Components

### 1. WaterVue (Frontend)
- **Technology**: Vue.js 3 + Vite + Tailwind CSS
- **Purpose**: Web-based user interface
- **Features**: Device dashboard, plan management, status monitoring, photo gallery

### 2. WaterPlantApp (Backend)
- **Technology**: Django + Django REST Framework + JWT Authentication
- **Purpose**: Central data management and API server
- **Features**: Device management, plan management, status tracking, photo management

### 3. WaterPlantOperator (Hardware Control)
- **Technology**: Python with hardware libraries
- **Purpose**: Controls physical hardware (pumps, sensors, cameras) on Raspberry Pi
- **Features**: Moisture sensor monitoring, water pump control, camera operations

## 🚀 Quick Start

### Prerequisites
- Python 3.9+
- Node.js 16+
- Podman (for containerized deployment)
- Git

### Option 1: Containerized Deployment (Recommended)
```bash
# Start all containers (including operator)
./start_all_containers.sh

# Or start with complete system
./start_complete_system.sh

# Or start only backend + frontend (without operator)
./start_app_vue_containers.sh
```

### Option 2: Local Development
```bash
# Start only backend + frontend locally (without operator)
./start_app_vue_local.sh

# Or manual setup:
# 1. Setup WaterPlantApp (Backend)
cd WaterPlantApp
./setup.sh
./start.sh

# 2. Setup WaterVue (Frontend)
cd ../WaterVue
npm install
npm run dev

# 3. Setup WaterPlantOperator (Hardware) - Optional
cd ../WaterPlantOperator
pip install -r requirements.txt
python run/main.py
```

## 🌐 Access Points

Once running:
- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8001
- **Hardware Control**: http://localhost:8000
- **Admin Interface**: http://localhost:8001/admin/

### Default Credentials
- **Username**: `testuser`
- **Password**: `testpass123`

## 📋 Available Scripts

### Complete System Management
- `./start_all_containers.sh` - Start all components in containers
- `./start_complete_system.sh` - Start complete system with monitoring
- `./stop_all_containers.sh` - Stop all containers
- `./stop_complete_system.sh` - Stop complete system
- `./check_system_status.sh` - Check system status

### App + Vue Only (Without Operator)
- `./start_app_vue_containers.sh` - Start WaterPlantApp and WaterVue in containers
- `./stop_app_vue_containers.sh` - Stop WaterPlantApp and WaterVue containers
- `./start_app_vue_local.sh` - Start WaterPlantApp and WaterVue locally
- `./stop_app_vue_local.sh` - Stop WaterPlantApp and WaterVue local processes

### Testing
- `./test_complete_integration.py` - Run integration tests
- `./create_production_user.py` - Create production user

## 📚 Documentation

- [Complete System Integration](COMPLETE_SYSTEM_INTEGRATION.md)
- [Containerized System Guide](CONTAINERIZED_SYSTEM_GUIDE.md)
- [Data Flow Architecture](DATA_FLOW_ARCHITECTURE.md)
- [System Scripts](SYSTEM_SCRIPTS.md)
- [Using Containerized Operator](USING_CONTAINERIZED_OPERATOR.md)
- [App + Vue Scripts](APP_VUE_SCRIPTS.md) - Scripts for running only backend and frontend

## 🔧 Development

This repository uses Git submodules to manage the three components:

```bash
# Clone with submodules
git clone --recursive <repository-url>

# Update submodules
git submodule update --remote

# Work on a specific component
cd WaterVue
# Make changes and commit
cd ../WaterPlantApp
# Make changes and commit
```

## 🧪 Testing

Run the complete integration test suite:
```bash
./test_complete_integration.py
```

## 📊 System Status

Check if all components are running:
```bash
./check_system_status.sh
```

## 🛠️ Troubleshooting

### Common Issues
1. **Port conflicts**: Ensure ports 3000, 8000, and 8001 are available
2. **Container issues**: Check container logs with `podman logs <container-name>`
3. **Database issues**: Run migrations in WaterPlantApp
4. **Authentication**: Use the default credentials or create new users

### Logs
- Container logs: `podman logs <container-name>`
- Application logs: Check `logs/` directory in each component

## 📄 License

This project is licensed under the MIT License.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📞 Support

For support and questions:
- Check the troubleshooting section
- Review the documentation
- Run the test suite to verify system health
- Check component logs for error details
