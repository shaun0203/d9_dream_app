from pydantic import BaseModel, Field
from typing import List, Optional

class AnalyzeRequest(BaseModel):
    text: str = Field(..., min_length=1)
    language: str = Field(default="en")

class Analysis(BaseModel):
    summary: str
    symbols: List[str] = []
    themes: List[str] = []
    sentiment: Optional[str] = None
    advice: Optional[str] = None

class AnalyzeResponse(BaseModel):
    analysis: Analysis
