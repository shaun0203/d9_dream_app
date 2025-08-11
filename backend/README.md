# Backend (FastAPI)

FastAPI service that verifies Firebase ID tokens and calls an AI provider to analyze dreams.

## Endpoints
- GET /healthz — health check
- POST /api/v1/analyze — body: { dream: string }, returns structured analysis

Authorization: send Firebase ID token in header Authorization: Bearer <token>

## Setup

1) Python env
- python -m venv .venv && source .venv/bin/activate
- pip install -r requirements.txt

2) Environment
- cp .env.example .env
- Set OPENAI_API_KEY if you want OpenAI analysis; otherwise stub is used.
- For Firebase verification: set GOOGLE_APPLICATION_CREDENTIALS to your service account json path or set FIREBASE_CREDENTIALS_JSON in .env

3) Run
- uvicorn app.main:app --reload

4) Swagger
- http://localhost:8000/docs
