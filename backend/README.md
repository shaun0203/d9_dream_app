# Backend (FastAPI)

Endpoints
- GET /healthz
- POST /v1/dream/analyze { dream: string }

Auth
- Configure AUTH_MODE=firebase and provide GOOGLE_APPLICATION_CREDENTIALS + FIREBASE_PROJECT_ID to verify ID tokens.
- In development, set AUTH_MODE=none to skip verification.

Run
```
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

Env
Copy .env.example to .env and adjust values.
