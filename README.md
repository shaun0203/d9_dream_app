# d9_dream_app

Dream analysis application monorepo.

- Frontend: Flutter (BLoC), Firebase Authentication, text input + speech-to-text
- Backend: FastAPI (Python), Firebase ID token verification, AI analysis (OpenAI or stub)

## Repository layout

- mobile/ — Flutter app (Android, iOS, web, desktop)
- backend/ — FastAPI service for analysis and auth verification

## Quick start

1) Backend
- Copy backend/.env.example to backend/.env and set values.
- Option A: Docker
  - docker build -t d9_dream_backend ./backend
  - docker run -p 8000:8000 --env-file backend/.env d9_dream_backend
- Option B: Local
  - python -m venv .venv && source .venv/bin/activate
  - pip install -r backend/requirements.txt
  - uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload

2) Mobile (Flutter)
- Ensure Flutter SDK is installed.
- From mobile/, run: flutter pub get
- Bootstrap platform folders if missing: flutter create .
- Configure Firebase (see mobile/README.md) and replace mobile/lib/firebase_options.dart via FlutterFire CLI.
- Create .env from assets/.env.example and set API_BASE_URL to your backend (e.g., http://localhost:8000 on desktop/web or http://10.0.2.2:8000 on Android emulator).
- Run: flutter run

## Notes
- The backend verifies Firebase ID tokens sent by the app in the Authorization: Bearer <id-token> header.
- Analysis endpoint: POST /api/v1/analyze { dream: string }
- If OPENAI_API_KEY is set, the service uses OpenAI for richer analysis; otherwise a heuristic stub is returned.

## License
MIT (add your preferred license if different)
