from __future__ import annotations

from typing import Optional

from app.core.config import settings

try:
    import firebase_admin
    from firebase_admin import auth, credentials
except Exception:  # pragma: no cover - optional dep during local dev
    firebase_admin = None
    auth = None
    credentials = None

_initialized = False

def _init():
    global _initialized
    if _initialized:
        return
    if settings.AUTH_MODE != "firebase":
        _initialized = True
        return
    if not firebase_admin:
        raise RuntimeError("firebase_admin not available but AUTH_MODE=firebase")
    if not firebase_admin._apps:
        cred = credentials.ApplicationDefault() if settings.GOOGLE_APPLICATION_CREDENTIALS else credentials.Certificate(settings.GOOGLE_APPLICATION_CREDENTIALS)  # type: ignore[arg-type]
        firebase_admin.initialize_app(cred, {'projectId': settings.FIREBASE_PROJECT_ID})
    _initialized = True


def verify_token(id_token: str) -> Optional[str]:
    """Verify a Firebase ID token and return uid or None on failure.
    In AUTH_MODE=none, always returns None (no-op).
    """
    _init()
    if settings.AUTH_MODE != "firebase":
        return None
    assert auth is not None
    decoded = auth.verify_id_token(id_token)
    return decoded.get('uid')
