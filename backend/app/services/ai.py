from __future__ import annotations

import asyncio
from app.core.config import settings

try:
    from openai import AsyncOpenAI  # type: ignore
except Exception:  # pragma: no cover
    AsyncOpenAI = None


async def analyze_dream(dream: str) -> str:
    """Analyze a dream using OpenAI if configured, else a simple heuristic.
    """
    if settings.OPENAI_API_KEY and AsyncOpenAI:
        client = AsyncOpenAI(api_key=settings.OPENAI_API_KEY)
        prompt = (
            "You are a thoughtful therapist. Analyze the following dream in 5 short bullet points, "
            "include possible symbolism, emotions, and actionable reflection prompts. Dream: "
            f"{dream}"
        )
        resp = await client.chat.completions.create(
            model="gpt-4o-mini",
            messages=[{"role": "user", "content": prompt}],
            temperature=0.7,
        )
        return resp.choices[0].message.content or "No analysis returned."
    # fallback simple analysis
    await asyncio.sleep(0.2)
    themes = []
    text = dream.lower()
    if any(w in text for w in ["fly", "flying", "flight"]):
        themes.append("Desire for freedom or rising above challenges")
    if any(w in text for w in ["fall", "falling"]):
        themes.append("Feeling a loss of control or fear of failure")
    if any(w in text for w in ["chase", "chased", "pursuit"]):
        themes.append("Avoidance of unresolved issues or stressors")
    if not themes:
        themes.append("Processing recent memories and emotions")
    bullets = "\n".join(f"- {t}" for t in themes)
    return f"Preliminary analysis (offline):\n{bullets}\n\nReflection: What emotions did you feel most strongly during the dream?"
