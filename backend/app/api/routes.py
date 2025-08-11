from fastapi import APIRouter, Depends
from fastapi import HTTPException, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer

from app.core.config import settings
from app.core.firebase import verify_token
from app.models.schemas import DreamRequest, DreamResponse
from app.services.ai import analyze_dream

router = APIRouter()
security = HTTPBearer(auto_error=False)


def _require_auth(creds: HTTPAuthorizationCredentials | None):
    if settings.AUTH_MODE == "none":
        return None
    if not creds or creds.scheme.lower() != "bearer":
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Missing token")
    uid = verify_token(creds.credentials)
    if not uid:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid token")
    return uid


@router.post("/dream/analyze", response_model=DreamResponse)
async def dream_analyze(payload: DreamRequest, creds: HTTPAuthorizationCredentials | None = Depends(security)):
    _require_auth(creds)
    try:
        analysis = await analyze_dream(payload.dream)
        return DreamResponse(analysis=analysis)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
