from fastapi import APIRouter, Depends, Header, HTTPException
from ...models.schemas import AnalyzeRequest, AnalyzeResponse, Analysis
from ...services.firebase_auth import verify_bearer, AuthError
from ...services.ai import DreamAI

router = APIRouter()

async def _require_auth(authorization: str | None = Header(default=None)) -> dict:
    try:
        return verify_bearer(authorization)
    except AuthError as e:
        raise HTTPException(status_code=401, detail=str(e))

@router.post('/analyze', response_model=AnalyzeResponse)
async def analyze(req: AnalyzeRequest, user=Depends(_require_auth)):
    ai = DreamAI()
    result = await ai.analyze(req.text, language=req.language)
    # Normalize to response model
    analysis = Analysis(
        summary=result.get('summary', ''),
        symbols=result.get('symbols', []) or [],
        themes=result.get('themes', []) or [],
        sentiment=result.get('sentiment'),
        advice=result.get('advice'),
    )
    return AnalyzeResponse(analysis=analysis)
