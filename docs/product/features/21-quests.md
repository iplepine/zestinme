# 21. Feature: Special Quests (Mind Labs)

## 0. Meta Info
- **Role:** Planner Flow, Dr. Neuro
- **Goal:** Behavioral Activation & Self-Discovery (행동 활성화 및 자기 발견)
- **Key Concept:** "Experiment on yourself." (스스로를 실험하라)

## 1. Overview
특별 수행 퀘스트는 단순한 숙제가 아닌, **일정 기간 동안 지속되는 행동 실험(Behavioral Experiment)**입니다. 사용자가 자신의 생활 패턴(수면, 집중, 스트레스 등)을 직접 관찰하고 데이터화하도록 유도합니다.

## 2. Quest Types

### Type A: Tracking Quests (Pattern Finding)
사용자의 기존 패턴에서 상관관계를 찾아내는 퀘스트입니다.
*   **Example:** "나의 수면 골든타임 찾기"
*   **Duration:** 3~7일.
*   **Action:** 매일 기상 직후 '수면 시간'과 '개운함 정도'를 기록.
*   **Analysis:** 데이터 분석 후 "당신은 7시간 15분 잘 때 가장 개운해합니다"라는 인사이트 리포트 제공.

### Type B: Intervention Quests (Solution Testing)
새로운 행동을 시도하고 효과를 측정하는 퀘스트입니다.
*   **Example:** "뽀모도로 집중법 실험"
*   **Duration:** 1일 (반복 가능).
*   **Action:** 집중 전 타이머 설정 -> 수행 -> 집중도/만족도 평가.
*   **Analysis:** "이 방법이 평소보다 업무 몰입도를 20% 높였습니다."

## 3. UX Flow
1.  **Quest Board:** 수행 가능한 퀘스트 목록 (홈 화면 또는 별도 탭).
2.  **Accept:** 퀘스트 수락 시 '계약서'에 서명하거나 '씨앗'을 받는 인터랙션.
3.  **Daily Check:** 매일 진행 상황을 체크하면 식물 주변에 특별한 '기운'이 생김.
4.  **Completion:** 수행 완료 시 최종 리포트 발행 및 보상(특별한 식물 품종 등) 지급.

## 4. Integration with Core Loop
*   퀘스트 수행 기록은 `EmotionRecord`와 연동될 수 있습니다. (예: 특정 수면 패턴이 기분에 미치는 영향 분석)
*   퀘스트 완료 시 얻는 특별한 식물은 정원에 '개성'을 더하는 요소가 됩니다.
