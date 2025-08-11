from __future__ import annotations
import os
from typing import Any, Dict
import firebase_admin
from firebase_admin import credentials, auth

_initialized = False

def _ensure_initialized() -> None:
    global _initialized
    if _initialized:
        return
    cred_path = os.getenv("FIREBASE_CREDENTIALS") or os.getenv("GOOGLE_APPLICATION_CREDENTIALS")
    if cred_path and os.path.exists(cred_path):
        cred = credentials.Certificate(cred_path)
        firebase_admin.initialize_app(cred)
    else:
        # Try default app (for environments with ADC configured)
        if not firebase_admin._apps:
            firebase_admin.initialize_app()
    _initialized = True

class AuthError(Exception):
    pass

def verify_bearer(auth_header: str | None) -> Dict[str, Any]:
    _ensure_initialized()
    if not auth_header or not auth_header.startswith("Bearer "):
        raise AuthError("Missing or invalid Authorization header")
    token = auth_header.split(" ", 1)[1].strip()
    try:
        decoded = auth.verify_id_token(token)
        return decoded
    except Exception as e:  # noqa: BLE001
        raise AuthError(f"Invalid token: {e}")
