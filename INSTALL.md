# AKTA Installation Guide

## Option 1: Local Development (Recommended for first-time setup)

### Prerequisites

- **Python 3.10+** (3.11 recommended)
- **pip** (Python package manager)
- **Git** (optional, for cloning)

### Step 1: Get the code

```bash
git clone <repo-url> akta
cd akta
```

### Step 2: Create virtual environment (recommended)

```bash
# Windows
python -m venv venv
venv\Scripts\activate

# Linux/Mac
python3 -m venv venv
source venv/bin/activate
```

### Step 3: Install dependencies

```bash
pip install -r requirements.txt
```

### Step 4: Configure environment

```bash
# Copy the example env file
cp .env.example .env

# Edit .env to add your Gemini API key (optional — AI features)
# GEMINI_API_KEY=your-key-here
```

### Step 5: Start the application

```bash
# Windows
scripts\start.bat

# Linux/Mac
bash scripts/start.sh
```

The start script will:
1. Detect free ports automatically
2. Start the FastAPI backend
3. Start the Streamlit frontend
4. Print the URLs to access the app

### Step 6: Access the application

Open the frontend URL printed in the console (default: `http://localhost:8501`).

Login with **demo / demo** to explore all features with simulated data.

---

## Option 2: Docker

### Prerequisites

- **Docker** 20.10+
- **Docker Compose** v2+

### Quick Start

```bash
# Build and start
docker-compose up --build -d

# View logs
docker-compose logs -f

# Stop
docker-compose down
```

### Custom Configuration

Create a `.env` file before starting:

```env
GEMINI_API_KEY=your-gemini-api-key
MISTRAL_API_URL=http://host.docker.internal:11434
SECRET_KEY=your-production-secret-key
BACKEND_PORT=9000
FRONTEND_PORT=8501
```

### Using Local Ollama (Mistral)

If you have Ollama running on your host machine:

```bash
# Install and start Ollama (on host)
ollama pull mistral
ollama serve

# Docker will connect via host.docker.internal:11434
```

---

## Option 3: pip install

```bash
pip install -e .

# Start backend manually
python -m uvicorn backend.main:app --host 0.0.0.0 --port 9000

# Start frontend in another terminal
streamlit run app.py --server.port 8501
```

---

## Option 4: OCI Cloud Deployment

See [deploy/DEPLOY-README.md](deploy/DEPLOY-README.md) for full OCI Always Free tier deployment instructions.

---

## Post-Installation

### Enable AI Features

AI document analysis requires at least one LLM provider:

**Google Gemini (Cloud):**
1. Get an API key from [Google AI Studio](https://aistudio.google.com/)
2. Add to `.env`: `GEMINI_API_KEY=your-key`
3. Or configure per-user in Settings page

**Mistral via Ollama (Local):**
1. Install [Ollama](https://ollama.com/)
2. Run: `ollama pull mistral && ollama serve`
3. Default endpoint: `http://localhost:11434`

### Default Credentials

| Username | Password | Role | Data |
|----------|----------|------|------|
| demo | demo | Demo User | Simulated data (not persisted) |
| tm_admin | admin123 | Transition Manager | Empty (upload SOW) |
| dm_admin | admin123 | Delivery Manager | Empty (upload SOW) |
| tl_network | admin123 | Tech Lead - Network | Empty |
| tl_windows | admin123 | Tech Lead - Windows | Empty |
| tl_linux | admin123 | Tech Lead - Linux | Empty |
| tl_servicedesk | admin123 | Tech Lead - ServiceDesk | Empty |

### Database

- SQLite database at `db/akta.db`
- Auto-created on first run with demo data
- Delete `db/akta.db` to reset and re-seed

### Ports

AKTA automatically detects free ports at startup:
- Backend: starts at **9000**, finds next free if occupied
- Frontend: starts at **8501**, finds next free if occupied
- Active ports displayed in the UI header

---

## Troubleshooting

### Backend won't start
- Check if port 9000 is already in use: `netstat -an | findstr 9000`
- The start script will auto-detect a free port

### Frontend can't reach backend
- Ensure backend started before frontend (3-second delay in start script)
- Check `.ports.json` in project root for actual ports
- Verify `API_BASE` matches backend port

### Demo login fails
- Ensure backend is running
- Delete `db/akta.db` and restart to re-seed with `demo/demo` credentials

### AI features return fallback data
- Configure Gemini API key in `.env` or Settings page
- Or install Ollama with Mistral model locally
