#!/bin/bash
echo "========================================"
echo " AKTA - Agentic KT & Transition Assistant v1.0"
echo " Starting services..."
echo "========================================"

cd "$(dirname "$0")/.."

# Check if .env exists
if [ ! -f ".env" ]; then
    echo "Creating .env from .env.example..."
    cp .env.example .env
fi

# Resolve free ports using Python utility
echo "Detecting free ports..."
PORTS=$(python -c "from utils.port_finder import resolve_ports; p=resolve_ports(); print(f\"{p['backend_port']},{p['frontend_port']}\")" 2>/dev/null)

if [ -n "$PORTS" ]; then
    BACKEND_PORT=$(echo "$PORTS" | cut -d',' -f1)
    FRONTEND_PORT=$(echo "$PORTS" | cut -d',' -f2)
else
    BACKEND_PORT=9000
    FRONTEND_PORT=8501
fi

export API_BASE="http://localhost:${BACKEND_PORT}"

# Start FastAPI backend
echo "Starting FastAPI backend on port ${BACKEND_PORT}..."
python -m uvicorn backend.main:app --host 0.0.0.0 --port "${BACKEND_PORT}" --reload &
BACKEND_PID=$!

sleep 3

# Start Streamlit frontend
echo "Starting Streamlit frontend on port ${FRONTEND_PORT}..."
streamlit run app.py --server.port "${FRONTEND_PORT}" &
FRONTEND_PID=$!

echo "========================================"
echo " AKTA is running..."
echo " Backend:  http://localhost:${BACKEND_PORT}"
echo " Frontend: http://localhost:${FRONTEND_PORT}"
echo " Demo login: demo / demo"
echo "========================================"
echo "Press Ctrl+C to stop all services..."

trap "kill $BACKEND_PID $FRONTEND_PID 2>/dev/null; echo 'Services stopped.'; exit" INT TERM
wait
