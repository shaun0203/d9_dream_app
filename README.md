# d9_dream_app

Dream analysis application: Flutter (BLoC) frontend with Firebase Authentication + speech-to-text; FastAPI backend that verifies Firebase ID tokens and calls an AI provider to analyze dreams. Monorepo layout:

- mobile/ — Flutter app (BLoC throughout)
- backend/ — FastAPI service (token verification, AI analysis)

## High-level Architecture

User (Flutter) -> Firebase Auth (client) -> obtains ID token
User (Flutter) -> FastAPI /api/v1/dreams/analyze (Authorization: Bearer <ID token>)
FastAPI -> verifies token (Firebase Admin) -> calls AI provider -> returns analysis
FastAPI -> optionally persists records (future: Firestore/DB)

## Components

- Flutter + BLoC for all app flows (auth, input, analysis)
- Firebase Authentication on client; token verified in backend
- Speech-to-Text for voice dictation (optional Text-to-Speech for reading results)
- FastAPI backend exposing REST endpoints
- AI analysis provider (OpenAI by default, pluggable)

## Repository Structure

```
├── README.md
├── .gitignore
├── mobile/
│   ├── pubspec.yaml
│   ├── analysis_options.yaml
│   └── lib/
│       ├── main.dart
│       ├── app.dart
│       ├── repositories/
│       ├── bloc/
│       └── ui/
└── backend/
    ├── app/
    │   ├── main.py
    │   ├── core/config.py
    │   ├── models/schemas.py
    │   ├── services/
    │   │   ├── ai.py
    │   │   └── firebase_auth.py
    │   └── api/v1/routes/dreams.py
    ├── requirements.txt
    ├── Dockerfile
    └── .env.example
```

## Setup

### Prerequisites
- Flutter SDK (3.22+ recommended)
- Dart SDK (bundled with Flutter)
- Node.js (optional if using web debug proxy)
- Python 3.10+
- Firebase project with Authentication enabled
- Credentials for Firebase Admin (backend)
- Optional: OpenAI API key for AI analysis

### 1) Configure Firebase (Mobile)
1. Install FlutterFire CLI: `dart pub global activate flutterfire_cli`
2. Inside `mobile/`, run: `flutterfire configure`
   - Select your Firebase project
   - Generate `firebase_options.dart`
3. Add platform configs:
   - Android: add `google-services.json`
   - iOS: add `GoogleService-Info.plist`

### 2) Install mobile dependencies
```
cd mobile
flutter pub get
# If this repo was cloned fresh, bootstrap platform folders:
flutter create --platforms=android,ios,web .
```

### 3) Backend environment
Copy `.env.example` to `.env` and fill values:

```
cp backend/.env.example backend/.env
```

`.env` keys:
- `OPENAI_API_KEY` (optional) — If missing, backend falls back to heuristic analysis
- `FIREBASE_CREDENTIALS` — path to Firebase Admin service account JSON, or ensure `GOOGLE_APPLICATION_CREDENTIALS` env var points to it
- `ALLOWED_ORIGINS` — comma-separated list for CORS (e.g., http://localhost:8080,http://localhost:3000)

### 4) Install backend dependencies and run
```
cd backend
python -m venv .venv
source .venv/bin/activate  # Windows: .venv\\Scripts\\activate
pip install -r requirements.txt
uvicorn app.main:app --reload --port 8000
```

### 5) Run Flutter app
```
cd mobile
flutter run -d chrome   # or -d android / -d ios
```

## API Contract

POST /api/v1/dreams/analyze
- Headers: `Authorization: Bearer <Firebase ID token>`
- Body: `{ "text": "...", "language": "en" }`
- Response: `{ "analysis": { "summary": "...", "symbols": ["..."], "themes": ["..."], "sentiment": "..." } }`

## Notes
- This is the initial scaffold. Fill in Firebase configs and environment variables to run.
- The backend AI service uses OpenAI if configured; otherwise a simple heuristic produces a structured analysis for development.
- All UI flows are wired with BLoC; see `mobile/lib/bloc/*` for the implementation.
