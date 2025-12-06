# 21. Feature: Special Quests (Mind Labs)

## 0. Meta Info
- **Role:** Planner Flow, Dr. Neuro
- **Goal:** Behavioral Activation & Self-Discovery
- **Key Concept:** "Experiment on yourself." (스스로를 실험하라)

## 1. Overview
특별 수행 퀘스트는 단발성 미션이 아닌, **일정 기간 동안 지속되는 행동 실험(Behavioral Experiment)**입니다. 사용자가 자신의 패턴(수면, 집중, 스트레스 등)을 발견하도록 유도합니다.

## 2. Quest Types

### Type A: Tracking Quests (Pattern Finding)
*   **Example:** "나의 수면 골든타임 찾기"
*   **Duration:** 3~7일.
*   **Action:** 매일 기상 직후 '수면 시간'과 '개운함 정도'를 기록.
*   **Analysis:** 데이터가 쌓이면 상관관계를 그래프로 보여주고 "당신은 7시간 잘 때 가장 개운해합니다" 리포트 제공.

### Type B: Intervention Quests (Solution Testing)
*   **Example:** "뽀모도로 집중법 실험"
*   **Duration:** 1일 (반복 가능).
*   **Action:** 집중하기 전 타이머 설정 -> 수행 -> 집중도 평가.
*   **Analysis:** "이 방법이 평소보다 집중도를 20% 높였습니다."

## 3. Structure (Quest Object)
*   `QuestID`: Unique ID.
*   `Title`: 퀘스트 제목 (예: 수면 탐험대).
*   `Description`: 스토리텔링이 가미된 설명.
*   `Duration`: 수행 기간.
*   `Tasks`: 일일 단위 수행 항목. (Checklist).
*   `Reward`: 완료 시 제공되는 특별한 식물(Seed) 또는 아이템.

## 4. UX Flow
1.  **Quest Board:** 현재 수행 가능한 퀘스트 목록 노출 (게시판 느낌).
2.  **Accept:** 퀘스트 수락 시 '계약서'에 서명하는 듯한 인터랙션.
3.  **Daily Check:** 홈 화면 또는 퀘스트 탭에서 매일 진행상황 체크.
4.  **Completion:** 리포트 발행 및 보상 지급.

## 5. Integration with Core Loop
*   퀘스트 수행 기록도 경우에 따라 `EmotionRecord`와 연동될 수 있음 (예: "불면증 때문에 짜증남" -> 감정 기록 + 수면 퀘스트 데이터).
