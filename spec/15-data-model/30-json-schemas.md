# JSON Data Schemas

## 1. Quest Schema
퀘스트 정의를 위한 JSON 스키마입니다.

```json
{
  "quest_id": "quest_anger_management_01",
  "title": "가시 다듬기 (Pruning the Thorns)",
  "category": "CBT_Intervention",
  "trigger_condition": {
    "sam_valence_max": 3,
    "sam_arousal_min": 7,
    "liwc_keywords": ["anger", "hate", "annoyed"]
  },
  "steps": [
    {
      "step_id": "breath_work",
      "type": "interaction_long_press",
      "duration_sec": 15,
      "instruction": "화분의 가시 부분을 꾹 눌러서 부드럽게 만들어주세요."
    },
    {
      "step_id": "cognitive_reframing",
      "type": "journal_input",
      "prompt": "이 가시(화남)가 나를 보호하려 했던 이유는 무엇인가요?",
      "min_length": 20
    }
  ],
  "rewards": {
    "xp": 150,
    "item_drop": "golden_shears",
    "vibe_shift": "warm_sunset"
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
      "nutrient_type": "liquid_fertilizer_v2",
      "growth_impact": {
        "hydration": +10,
        "leaf_health": +5
      },
      "spawned_event": "new_bud_appeared"
    }
  }
}
```

## 3. Plant State Schema (New)
화분 상태 저장을 위한 스키마입니다.

```json
{
  "plant_state": {
    "plant_id": "user_main_pot_01",
    "species": "moon_flower_hybrid",
    "stage": "sprout",
    "health_stats": {
      "hydration": 80.5,
      "sunlight_exposure": 45.2,
      "love_level": 12
    },
    "visual_genes": {
      "color_palette": ["#FF5733", "#C70039"],
      "leaf_shape": "round"
    }
  }
}
```
