from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel

from ..services.firebase_verify import verify_bearer_token
from ..services.ai_service import analyze_dream

router = APIRouter()

class AnalyzeRequest(BaseModel):
    dream: str

@router.post("/analyze")
async def analyze(req: AnalyzeRequest, user=Depends(verify_bearer_token)):
    if not req.dream.strip():
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="dream text required")
    result = await analyze_dream(req.dream, user_id=user["uid"])  # type: ignore
    return result
