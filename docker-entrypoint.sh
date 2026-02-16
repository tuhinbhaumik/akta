#!/bin/bash
set -e

echo "========================================"
echo " AKTA - Agentic KT & Transition Assistant v1.0"
echo " Starting in Docker..."
echo "========================================"

# Resolve ports
python -c "from utils.port_finder import resolve_ports; resolve_ports()" 2>/dev/null || true

BACKEND_PORT=${BACKEND_PORT:-9000}
FRONTEND_PORT=${FRONTEND_PORT:-8501}

export API_BASE="http://localhost:${BACKEND_PORT}"

# Start backend
echo "Starting FastAPI backend on port ${BACKEND_PORT}..."
python -m uvicorn backend.main:app --host 0.0.0.0 --port "${BACKEND_PORT}" &

sleep 3

# Start frontend
echo "Starting Streamlit frontend on port ${FRONTEND_PORT}..."
streamlit run app.py --server.port "${FRONTEND_PORT}" --server.address 0.0.0.0 --server.headless true &

echo "========================================"
echo " AKTA is running..."
echo " Backend:  http://localhost:${BACKEND_PORT}"
echo " Frontend: http://localhost:${FRONTEND_PORT}"
echo " Demo login: demo / demo"
echo "========================================"

# Wait for any process to exit
wait -n

# Exit with status of process that exited first
exit $?
