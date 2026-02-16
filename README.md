# AKTA - Agentic KT and Transition Assistant v1.0

AI-powered platform for managing IT service transitions, automating knowledge transfer planning, tracking progress, and optimizing resource allocation.

## Features

- **SOW Analysis** — Upload PDF/DOCX/XLSX documents; AI extracts KT requirements automatically
- **KT Planner** — Auto-generated phased plans with Gantt charts across 5 transition phases
- **Progress Tracker** — Real-time KT tracking per technology tower with verification workflows
- **AI ChatOPS** — Conversational interface for status queries, reports, and recommendations
- **Resource Planning** — FTE allocation, shift management, and staffing gap analysis
- **Role-Based Access** — Tailored views for Transition Managers, Delivery Managers, and Tech Leads
- **Workflow Engine** — Discovery, Transfer, Shadowing, Reverse Shadowing, Steady State
- **Multi-Agent AI** — Google Gemini (cloud) + Mistral/Ollama (local) dual LLM architecture

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | Streamlit, Plotly |
| Backend | FastAPI, Uvicorn |
| Database | SQLite (SQLAlchemy ORM) |
| AI/LLM | Google Gemini, Mistral (Ollama), FastMCP |
| Auth | Bcrypt, Role-Based Access Control |
| Docs | PyPDF2, python-docx, openpyxl |

## Quick Start

### Prerequisites

- Python 3.10+
- pip

### Install & Run

```bash
# Clone the repository
git clone <repo-url> akta
cd akta

# Install dependencies
pip install -r requirements.txt

# Start the application (auto-detects free ports)
# Windows:
scripts\start.bat

# Linux/Mac:
bash scripts/start.sh
```

The startup script automatically:
1. Detects free ports for backend and frontend
2. Starts the FastAPI backend
3. Starts the Streamlit frontend
4. Displays the URLs and ports being used

### Demo Mode

Login with `demo` / `demo` to explore all features with simulated data.
Nothing is saved after logout in demo mode.

| Username | Password | Role |
|----------|----------|------|
| demo | demo | Demo User (full access, simulated data) |
| tm_admin | admin123 | Transition Manager |
| dm_admin | admin123 | Delivery Manager |
| tl_network | admin123 | Tech Lead - Network |
| tl_windows | admin123 | Tech Lead - Windows |
| tl_linux | admin123 | Tech Lead - Linux |
| tl_servicedesk | admin123 | Tech Lead - ServiceDesk |

Non-demo users start with empty data. Upload a SOW document to begin.

## Docker

```bash
# Build and run
docker-compose up --build

# Or build manually
docker build -t akta .
docker run -p 9000:9000 -p 8501:8501 akta
```

## Project Structure

```
akta/
├── app.py                  # Streamlit main entry
├── backend/
│   ├── main.py             # FastAPI REST API (20+ endpoints)
│   ├── models.py           # Pydantic schemas
│   └── file_handler.py     # Document processing
├── db/
│   ├── database.py         # SQLAlchemy setup
│   ├── models.py           # ORM models (9 tables)
│   └── seed.py             # Demo data seeding
├── auth/
│   ├── login.py            # Auth widget
│   ├── rbac.py             # Role permissions
│   └── session.py          # Session management
├── views/                  # Streamlit page modules
├── mcp/
│   ├── server.py           # LLM abstraction
│   ├── client.py           # API client
│   ├── agents/             # AI agents (SOW, planner, tracker, chat)
│   └── tools/              # Document parsing, analytics
├── utils/
│   └── port_finder.py      # Dynamic port detection
├── scripts/
│   ├── start.bat           # Windows launcher
│   └── start.sh            # Linux/Mac launcher
├── Dockerfile
├── docker-compose.yml
├── setup.py
└── requirements.txt
```

## Configuration

Environment variables (`.env`):

| Variable | Default | Description |
|----------|---------|-------------|
| `API_BASE` | `http://localhost:9000` | Backend API URL (auto-set by start scripts) |
| `GEMINI_API_KEY` | (empty) | Google Gemini API key for AI features |
| `MISTRAL_API_URL` | `http://localhost:11434` | Ollama endpoint for local Mistral |
| `SECRET_KEY` | (dev default) | Session secret key |

## Dynamic Port Detection

AKTA automatically finds free ports at startup:
- Backend defaults to **9000**, falls back to next available
- Frontend defaults to **8501**, falls back to next available
- Ports are saved to `.ports.json` and displayed in the UI

## License

All rights reserved. AKTA and all associated materials are proprietary.

## See Also

- [INSTALL.md](INSTALL.md) — Detailed installation guide
- [deploy/DEPLOY-README.md](deploy/DEPLOY-README.md) — OCI cloud deployment guide
