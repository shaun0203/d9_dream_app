from __future__ import annotations
from typing import Dict, List
import re
import os
from . import firebase_auth  # noqa: F401  # reserved for future context

# Optional OpenAI support
_OPENAI_AVAILABLE = False
try:
    from openai import OpenAI  # type: ignore
    _OPENAI_AVAILABLE = True
except Exception:
    _OPENAI_AVAILABLE = False

class DreamAI:
    def __init__(self, api_key: str | None = None) -> None:
        self.api_key = api_key or os.getenv("OPENAI_API_KEY")
        self.client = OpenAI(api_key=self.api_key) if (_OPENAI_AVAILABLE and self.api_key) else None

    async def analyze(self, text: str, language: str = "en") -> Dict:
        if self.client is None:
            return self._heuristic_analysis(text)
        # OpenAI structured prompt
        prompt = (
            "You are a psychologist specializing in dream interpretation. "
            "Return a concise JSON object with keys: summary, symbols (array), themes (array), sentiment, advice. "
            f"Language: {language}. Dream: " + text
        )
        try:
            resp = self.client.chat.completions.create(
                model="gpt-4o-mini",
                messages=[{"role": "user", "content": prompt}],
                temperature=0.3,
            )
            content = resp.choices[0].message.content or ""
            # naive JSON extraction fallback
            import json
            start = content.find('{')
            end = content.rfind('}')
            if start != -1 and end != -1 and end > start:
                return json.loads(content[start:end+1])
            return {"summary": content.strip(), "symbols": [], "themes": [], "sentiment": None, "advice": None}
        except Exception:
            # Fall back to heuristic method if OpenAI fails
            return self._heuristic_analysis(text)

    def _heuristic_analysis(self, text: str) -> Dict:
        words = re.findall(r"[A-Za-z']+", text.lower())
        symbols: List[str] = []
        for key in ["water", "fall", "fly", "chase", "door", "mirror", "teeth", "exam", "snake", "cat", "dog", "baby", "death"]:
            if key in text.lower():
                symbols.append(key)
        themes: List[str] = []
        if any(k in words for k in ["running", "chase", "escape", "hide"]):
            themes.append("avoidance/fear")
        if any(k in words for k in ["fly", "flying", "float"]):
            themes.append("freedom/aspiration")
        if any(k in words for k in ["exam", "test", "late"]):
            themes.append("performance/anxiety")
        sentiment = "unsettling" if any(k in words for k in ["scared", "fear", "anxious", "lost"]) else "neutral"
        summary = (
            "This dream likely touches on "
            + (", ".join(themes) if themes else "general subconscious processing")
            + "."
        )
        advice = "Reflect on recent stressors and consider journaling your emotions upon waking."
        return {"summary": summary, "symbols": symbols, "themes": themes, "sentiment": sentiment, "advice": advice}
