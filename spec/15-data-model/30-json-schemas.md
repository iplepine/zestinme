# JSON Data Schemas

## 1. Quest Schema
퀘스트 정의를 위한 JSON 스키마입니다.

```json
{
  "quest_id": "quest_anger_management_01",
  "title": "용암 식히기 (Cooling the Lava)",
  "category": "CBT_Intervention",
  "trigger_condition": {
    "sam_valence_max": 3,
    "sam_arousal_min": 7,
    "liwc_keywords": ["anger", "hate", "annoyed"]
  },
  "steps": [
    {
      "step_id": "breath_work",
      "type": "interaction_mic_blow",
      "duration_sec": 15,
      "instruction": "마이크에 천천히 숨을 불어넣어 물고기를 식혀주세요."
    },
    {
      "step_id": "cognitive_reframing",
      "type": "journal_input",
      "prompt": "상대방의 입장에서 이 상황을 한 문장으로 다시 써보세요.",
      "min_length": 20
    }
  ],
  "rewards": {
    "xp": 150,
    "item_drop": "obsidian_scale",
    "vibe_shift": "calm_ocean"
  }
}
```

## 2. Diary Entry Schema
사용자 일기 및 분석 결과 저장을 위한 스키마입니다.

```json
{
  "diary_entry": {
    "timestamp": "2025-10-27T22:30:00Z",
    "raw_text_hash": "a1b2c3d4...",
    "sentiment_analysis": {
      "liwc_scores": {
        "posemo": 0.05,
        "negemo": 0.8,
        "insight": 0.1,
        "focus_past": 0.6
      },
      "detected_topics": ["insomnia", "work_stress"],
      "sam_score": {
        "valence": 2,
        "arousal": 8
      }
    },
    "game_metadata": {
      "bait_type": "text_lure_v2",
      "caught_item_id": "fish_volcanic_eel"
    }
  }
}
```
