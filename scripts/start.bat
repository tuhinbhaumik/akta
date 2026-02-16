@echo off
echo ========================================
echo  AKTA - Agentic KT ^& Transition Assistant v1.0
echo  Starting services...
echo ========================================

cd /d "%~dp0.."

:: Check if .env exists, if not copy from example
if not exist ".env" (
    echo Creating .env from .env.example...
    copy .env.example .env
)

:: Resolve free ports using Python utility
echo Detecting free ports...
for /f "tokens=1,2 delims=," %%a in ('python -c "from utils.port_finder import resolve_ports; p=resolve_ports(); print(f\"{p['backend_port']},{p['frontend_port']}\")"') do (
    set BACKEND_PORT=%%a
    set FRONTEND_PORT=%%b
)

if not defined BACKEND_PORT set BACKEND_PORT=9000
if not defined FRONTEND_PORT set FRONTEND_PORT=8501

:: Update API_BASE in environment for this session
set API_BASE=http://localhost:%BACKEND_PORT%

:: Start FastAPI backend in background
echo Starting FastAPI backend on port %BACKEND_PORT%...
start "AKTA-Backend" cmd /c "python -m uvicorn backend.main:app --host 0.0.0.0 --port %BACKEND_PORT% --reload"

:: Wait for backend to initialize
timeout /t 3 /nobreak > nul

:: Start Streamlit frontend
echo Starting Streamlit frontend on port %FRONTEND_PORT%...
start "AKTA-Frontend" cmd /c "streamlit run app.py --server.port %FRONTEND_PORT%"

echo ========================================
echo  AKTA is starting...
echo  Backend:  http://localhost:%BACKEND_PORT%
echo  Frontend: http://localhost:%FRONTEND_PORT%
echo  Demo login: demo / demo
echo ========================================
echo.
echo Press any key to stop all services...
pause > nul

:: Kill processes
taskkill /FI "WINDOWTITLE eq AKTA-Backend" /F > nul 2>&1
taskkill /FI "WINDOWTITLE eq AKTA-Frontend" /F > nul 2>&1
echo Services stopped.
