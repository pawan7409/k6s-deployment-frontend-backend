@echo off
REM setup.bat - Project Setup Script for Windows

echo.
echo 🚀 Kubernetes App Deployment - Setup Script (Windows)
echo.

REM Check Node.js
where node >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Node.js not found. Please install Node.js 18+
    exit /b 1
)
echo ✓ Node.js found

REM Check Python
where python >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Python not found. Please install Python 3.11+
    exit /b 1
)
echo ✓ Python found

REM Check Docker
where docker >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Docker not found. Please install Docker
    exit /b 1
)
echo ✓ Docker found

REM Setup Frontend
echo.
echo 📦 Setting up Frontend...
cd frontend
call npm install
cd ..
echo ✓ Frontend setup complete

REM Setup Backend
echo.
echo 🐍 Setting up Backend...
cd backend
python -m venv venv
call venv\Scripts\activate.bat
pip install -r requirements.txt
copy .env.example .env
cd ..
echo ✓ Backend setup complete

echo.
echo ✅ Setup complete!
echo.
echo 📝 Next steps:
echo 1. Configure backend\.env with your Azure settings
echo 2. Build Docker images: docker-compose build
echo 3. Start local development: docker-compose up
echo 4. Access Frontend: http://localhost:4200
echo 5. Access Backend: http://localhost:5000
