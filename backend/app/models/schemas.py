from pydantic import BaseModel, Field

class DreamRequest(BaseModel):
    dream: str = Field(..., min_length=3, description="User's dream text")

class DreamResponse(BaseModel):
    analysis: str
