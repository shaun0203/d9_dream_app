from pydantic_settings import BaseSettings, SettingsConfigDict

class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file='.env', env_file_encoding='utf-8', extra='ignore')

    OPENAI_API_KEY: str | None = None
    OPENAI_MODEL: str = 'gpt-4o-mini'
    FIREBASE_CREDENTIALS_JSON: str | None = None

settings = Settings()
