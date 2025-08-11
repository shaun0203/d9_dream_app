# d9_dream_app

Dream Analysis App: Flutter (BLoC) frontend with Firebase Authentication and Speech-to-Text/Text-to-Speech, backed by a Python FastAPI service that verifies Firebase tokens and sends dreams to an AI for analysis.

Monorepo layout:
- mobile/ — Flutter app
- backend/ — FastAPI service

## High-level Architecture

```
Flutter (mobile)
  - Firebase Auth (ID token)  ----->  FastAPI (backend)
  - BLoC: AuthBloc, DreamBloc         - Token verify (Firebase Admin, optional in dev)
  - STT (speech_to_text)              - /v1/dream/analyze -> AI (OpenAI or rule-based fallback)
  - TTS (flutter_tts)                 - Optional DB later
```

## Prerequisites
- Flutter 3.22+
- Dart 3+
- Python 3.11+
- Node 18+ (for Firebase tools optional)
- A Firebase project (enable Email/Anonymous sign-in at minimum)

## Backend: FastAPI

1) Configure env

Create `backend/.env` from example:

```
cp backend/.env.example backend/.env
```

Env vars:
- AUTH_MODE: "firebase" to enforce verification, or "none" for local dev without verification
- FIREBASE_PROJECT_ID: your firebase project id (required if AUTH_MODE=firebase)
- GOOGLE_APPLICATION_CREDENTIALS: path to service account JSON (required if AUTH_MODE=firebase)
- OPENAI_API_KEY: set to enable real AI analysis; if empty, a simple rule-based fallback is used
- CORS_ORIGINS: comma-separated list (e.g., http://localhost:3000,http://localhost:5173)

2) Install and run

```
cd backend
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

Health check: http://localhost:8000/healthz

Analyze endpoint:
- POST /v1/dream/analyze
- Headers: Authorization: Bearer <firebase_id_token> (if AUTH_MODE=firebase)
- Body: { "dream": "I was flying over mountains..." }

## Mobile: Flutter

1) Configure Firebase

- Install Firebase CLI and FlutterFire:
```
npm i -g firebase-tools
dart pub global activate flutterfire_cli
```
- Login and init:
```
firebase login
flutterfire configure --project=<YOUR_FIREBASE_PROJECT_ID> --platforms=android,ios
```
This generates `mobile/lib/firebase_options.dart`. Commit it if permitted, or keep it locally.

2) Set backend URL

Edit `mobile/lib/core/env.dart` to point to your backend (default: http://10.0.2.2:8000 for Android emulator, http://localhost:8000 for iOS/macOS):

```
class Env {
  static const backendBaseUrl = String.fromEnvironment(
    'BACKEND_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000',
  );
}
```

You can override at build:
```
flutter run --dart-define=BACKEND_BASE_URL=http://localhost:8000
```

3) Run app

```
cd mobile
flutter pub get
flutter run
```

Sign-in flows included:
- Anonymous sign-in (for quick start)
- Email/password (enable in Firebase console; basic UI provided)

STT/TTS:
- Press mic to dictate the dream
- Toggle TTS to hear the analysis

## BLoC Overview
- AuthBloc: handles Firebase auth state, sign-in/out
- DreamBloc: manages dream input, STT start/stop, submission to backend, and result state

## Security Notes
- In development you can use AUTH_MODE=none to skip token verification. For production, set AUTH_MODE=firebase and provide service account credentials.
- Store secrets in environment variables or a secret manager. Do not commit them.

## GitHub Actions (optional)
A CI stub can be added later to lint/build mobile and run backend tests.

## License
MIT
