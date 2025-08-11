import json
import os
from typing import Any, Dict

import firebase_admin
from fastapi import Depends, HTTPException, Request, status
from firebase_admin import auth, credentials

_app_initialized = False

def _ensure_app():
    global _app_initialized
    if _app_initialized:
        return
    creds_json = os.getenv("FIREBASE_CREDENTIALS_JSON")
    if creds_json:
        info = json.loads(creds_json)
        cred = credentials.Certificate(info)
        firebase_admin.initialize_app(cred)
    else:
        # fallback to GOOGLE_APPLICATION_CREDENTIALS env var or default app
        try:
            firebase_admin.get_app()
        except ValueError:
            firebase_admin.initialize_app()
    _app_initialized = True

async def verify_bearer_token(request: Request) -> Dict[str, Any]:
    _ensure_app()
    auth_header = request.headers.get("Authorization", "")
    if not auth_header.startswith("Bearer "):
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Missing bearer token")
    token = auth_header.split(" ", 1)[1].strip()
    try:
        decoded = auth.verify_id_token(token)
        return decoded  # contains uid, email, etc
    except Exception as e:  # noqa: BLE001
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail=str(e))
