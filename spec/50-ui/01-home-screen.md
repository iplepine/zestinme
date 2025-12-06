# 1.1 Home Screen: The Inner Garden (내면의 정원)

| Attribute | Value |
| :--- | :--- |
| **Version** | 1.1 |
| **Status** | Final Draft |
| **Date** | 2025-12-06 |
| **Author** | Mind-Gardener Committee |
| **Related** | `spec/20-feature/00-tutorial.md`, `spec/10-domain/20-core-mechanics.md` |

## 1. 기획 의도 (Design Intent)

> **"당신의 마음이 숨 쉬는 곳"**

홈 화면은 단순한 대시보드가 아니라, 사용자의 정신 상태(Mental State)가 **시각화된 정원(Biosphere)**입니다.
사용자는 이곳에서 자신의 '마음 식물'을 돌보며, 스스로를 돌보는 감각을 익힙니다.

**Core Philosophy:** "The Mirror"
*   이 화면은 게임의 '스테이지'가 아니라, 내 마음을 비추는 **'거울'**입니다.
*   식물을 조작하는 것이 아니라, 식물을 통해 나를 **'자각(Awareness)'**하는 것이 목표입니다.

## 2. 화면 구성 (Layout)

### 2.1 Top Area: Mental Weather (마음의 날씨)
*   **위치:** 상단 20%
*   **구성:** 현재 나의 심리 상태를 환경 변수로 표현한 **3가지 게이지 (Environment Gauge)**
    1.  **☀️ Sunlight (Valence):** 긍정/부정의 밝기. (높을수록 밝음)
    2.  **🌡️ Temperature (Arousal):** 에너지 레벨. (적정 온도가 좋음)
    3.  **💧 Water (Immersion):** 몰입/수분감. (식물의 목마름 상태)
*   **Interactions:** 게이지를 탭하면 현재 상태에 대한 짧은 코멘트(Insight)가 말풍선으로 뜹니다.

### 2.2 Center Area: The Plant (반려 식물)
*   **위치:** 중앙 60%
*   **구성:**
    *   **Main Visual:** 현재 키우고 있는 식물 (성장 단계에 따라 변화).
    *   **Background:** 시간대와 날씨(Mental Weather)를 반영한 동적 배경.
    *   **Pot:** 사용자가 선택하거나 획득한 화분.
*   **Animations:**
    *   **breathing:** 식물이 천천히 숨 쉬듯 미세하게 움직임 (Alive feel).
    *   **Wind:** 터치나 환경 변화에 따라 잎이 살랑거림.

### 2.3 Bottom Area: Insight Tools (마음 도구)
*   **위치:** 하단 20%
*   **구성:** 식물을 '키우는' 도구가 아니라, 나를 '들여다보는' 도구.
    1.  **💧 퀵 체크 (Check-in):** "지금 내 마음의 날씨는?" -> **[피드백]** 식물이 현재 상태를 반영하여 미세하게 변화(색감/자세).
    2.  **📝 깊은 기록 (Reflection):** "왜 그런 마음이 들었나요?" -> **[피드백]** 식물이 자라나며 새로운 잎(통찰)을 틔움.
    3.  **🗑️ 비워내기 (Let Go):** "무거운 마음 내려놓기." -> **[피드백]** 시든 잎이 떨어지고 정원이 정화됨.
    4.  **📖 회고 (History):** 나의 마음 변화 흐름 보기.

## 3. 핵심 인터랙션 (Core Interactions: Reflection Loop)

### 3.1 묻고 답하기 (Self-Talk)
*   **Concept:** 식물은 말을 하지 않지만, 질문을 던집니다.
*   **Action:** 식물을 탭하면, 식물이 현재 상태(Visual)에 기반한 **질문(Coaching Question)**을 띄웁니다.
    *   *Case (잎이 축 처짐):* "혹시 지금 너무 애쓰고 있지 않나요?"
    *   *Case (꽃이 만개함):* "이 기쁨을 누구와 나누고 싶나요?"
*   **Effect:** 사용자가 스스로 답을 생각하게 유도 (메타인지 강화).

### 3.2 바라보기 (Gazing)
*   **Action:** 아무 조작 없이 화면을 가만히 두면, **앰비언스 사운드(ASMR)**가 서서히 커지며 '멍 때리기(Mindfulness)' 모드로 진입.
*   **Visual:** 식물이 호흡하듯 천천히 움직이고, 빛의 입자가 주변을 감쌉니다.
*   **Vibe:** "아무것도 하지 않아도 괜찮아"라는 메시지를 전달.

### 3.3 기록의 시각화 (Visualization)
*   **Feedback:** 물을 주면 식물이 '기뻐하는' 것이 아니라, 나의 마음이 '촉촉해지는' 듯한 **화면 전체의 필터 효과(Bloom)**가 적용됩니다.
*   **Metaphor:** 기록은 식물에게 주는 영양분이자, 나에게 주는 선물입니다.

## 4. UI/UX Detail (Artist Esthetic)

### 4.1 Design System
*   **Colors:** 파스텔톤의 자연색(Earth Tones) 위주. 눈이 편안한 Green, Brown, Soft Blue.
*   **Typography:** 둥글고 부드러운 Sans-serif 서체 (Rounded). 이성적인 Gothic보다는 감성적인 명조나 둥근 고딕 계열.
*   **Shapes:** 각진 모서리 대신 곡선(Radius 24px+) 활용.

### 4.2 Micro-Interactions
*   **Transition:** 화면 진입 시 식물이 '인사하듯' 살짝 튀어오르는(Pop) 애니메이션.
*   **Particle:** 행복한 기록을 할 때는 따뜻한 빛 입자, 우울한 기록을 털어낼 때는 먼지가 날아가듯 사라지는 효과.

## 5. 예외 상황 처리 (Exceptions)
*   **Dead Plant:** 오랫동안 접속하지 않아 식물이 시들었을 때.
    *   **Dr. Mind:** 죄책감을 주지 않습니다. *"기다리고 있었어요"* 라는 메시지와 함께 물을 주면 금방 회복됩니다. (Game Over 없음)
