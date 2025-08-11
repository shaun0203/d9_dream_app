from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    AUTH_MODE: str = "none"  # 'firebase' or 'none'
    FIREBASE_PROJECT_ID: str | None = None
    GOOGLE_APPLICATION_CREDENTIALS: str | None = None
    OPENAI_API_KEY: str | None = None
    CORS_ORIGINS: str = "*"

    class Config:
        env_file = ".env"
        case_sensitive = True

settings = Settings()
