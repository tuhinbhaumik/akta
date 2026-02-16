FROM python:3.11-slim

LABEL maintainer="AKTA Development Team"
LABEL description="AKTA - Agentic KT and Transition Assistant v1.0"

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first for layer caching
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Create necessary directories
RUN mkdir -p uploads/sow uploads/upt db

# Expose ports (dynamically detected at runtime, defaults shown)
EXPOSE 9000 8501

# Environment defaults
ENV API_BASE=http://localhost:9000
ENV GEMINI_API_KEY=""
ENV MISTRAL_API_URL=http://host.docker.internal:11434
ENV SECRET_KEY=akta-docker-secret-change-in-production

# Health check
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
    CMD python -c "import requests; requests.get('http://localhost:9000/docs', timeout=5)" || exit 1

# Start both services using the entrypoint script
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
