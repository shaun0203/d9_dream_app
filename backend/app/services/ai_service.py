import os
from typing import Any, Dict, List

try:
    from openai import AsyncOpenAI
except Exception:  # pragma: no cover
    AsyncOpenAI = None  # type: ignore

SYSTEM_PROMPT = (
    "You are a careful dream analyst. Given a user's dream narrative, extract: "
    "1) a concise summary (2-4 sentences), 2) key symbols (list), 3) major themes (list), "
    "and 4) a gentle, practical advice paragraph. Keep it supportive and non-diagnostic."
)

async def analyze_dream(dream: str, user_id: str | None = None) -> Dict[str, Any]:
    api_key = os.getenv("OPENAI_API_KEY")
    if api_key and AsyncOpenAI is not None:
        client = AsyncOpenAI(api_key=api_key)
        prompt = f"Dream text:\n{dream}\n\nReturn a JSON object with keys: summary, symbols (list), themes (list), advice."
        resp = await client.chat.completions.create(
            model=os.getenv("OPENAI_MODEL", "gpt-4o-mini"),
            messages=[
                {"role": "system", "content": SYSTEM_PROMPT},
                {"role": "user", "content": prompt},
            ],
            temperature=0.7,
        )
        text = resp.choices[0].message.content or "{}"
        # naive parse fallback
        import json
        try:
            data = json.loads(text)
        except Exception:
            data = {"summary": text, "symbols": [], "themes": [], "advice": ""}
        return _normalize(data)

    # Fallback heuristic stub
    return _normalize(_stub_analysis(dream))


def _normalize(d: Dict[str, Any]) -> Dict[str, Any]:
    return {
        "summary": str(d.get("summary", "")),
        "symbols": [str(s) for s in (d.get("symbols") or [])],
        "themes": [str(s) for s in (d.get("themes") or [])],
        "advice": str(d.get("advice", "")),
    }


def _stub_analysis(dream: str) -> Dict[str, Any]:
    # very naive extraction for offline demo
    dream_lower = dream.lower()
    symbols: List[str] = []
    for s in ["water", "flight", "teeth", "chase", "fall", "door", "forest", "animal", "house", "school"]:
        if s in dream_lower:
            symbols.append(s)
    themes: List[str] = []
    if "chase" in dream_lower or "run" in dream_lower:
        themes.append("anxiety")
    if "exam" in dream_lower or "school" in dream_lower:
        themes.append("performance")
    if "fall" in dream_lower:
        themes.append("control")
    if not themes:
        themes.append("exploration")
    summary = (
        "Your dream reflects inner processing of daily experiences. Key symbols and themes "
        "suggest emotional integration and growth."
    )
    advice = (
        "Consider journaling about the feelings present in the dream. Reflect on current life "
        "situations that relate to the themes, and take one gentle step that supports your well-being."
    )
    return {"summary": summary, "symbols": symbols, "themes": themes, "advice": advice}
