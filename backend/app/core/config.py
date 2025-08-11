from pydantic import BaseSettings
import os

class Settings(BaseSettings):
    OPENAI_API_KEY: str | None = None
    FIREBASE_CREDENTIALS: str | None = None
    ALLOWED_ORIGINS: str = "http://localhost:3000,http://localhost:8080,http://localhost:8000"

    class Config:
        env_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(__file__))), ".env")

settings = Settings()
