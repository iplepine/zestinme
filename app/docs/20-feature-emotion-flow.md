# 20. Feature: Emotion Recording Flow (The Mirror Protocol)

## 0. Meta Info
- **Role:** Dr. Neure, Dr. Mind
- **Goal:** Objectification of Emotions (감정의 객관화)
- **Key Concept:** "Plant a seed of emotion." (감정의 씨앗 심기)

## 1. Overview
감정 기록은 단순한 일기가 아닙니다. **1) 씨앗 심기(Seeding)** -> **2) 발아(Germination)** -> **3) 개화(Bloom/Analysis)**의 3단계 프로세스를 통해 감정을 소화 가능한 형태로 만듭니다.

## 2. Process Flow

### Phase 1: Seeding (The Catch) - "Quick & Gentle"
*   **Goal:** 감정의 'Vibe'를 빠르고 직관적으로 심는 것. 복잡한 설문조사 제거.
*   **Interaction:** **"Planting Gesture"**
    *   **Action:** 화면의 씨앗(Seed)을 드래그하여 감정의 토양(Valence/Arousal Map)에 심음.
    *   **Visual:** 씨앗을 둔 위치에 따라 흙의 색과 온도가 변함 (Energy/Pleasantness Feedback).
        *   *Up-Right (High Energy+Pleasant):* 따뜻하고 기름진 흙 (Sunny colors)
        *   *Down-Left (Low Energy+Unpleasant):* 차갑고 척박한/젖은 흙 (Cool colors)
    *   **Release:** 손을 놓으면 씨앗이 흙 속으로 파고듦.
*   **Optional Tag:** 심은 후 피어날 꽃(감정 단어)을 예측하듯 선택 (e.g., "Angry", "Happy", "Tired").
*   **Output:** `EmotionRecord` 생성 (Status: `caught/planted`).

### Phase 2: Germination (Incubation)
*   **Logic:** 기록 후 일정 시간(예: 최소 3시간 or 다음날 아침) 동안은 "분석"을 할 수 없게 함.
*   **Why (Dr. Neuro):** 감정적 뇌(Amygdala)가 진정되고 이성적 뇌(Prefrontal Cortex)가 작동할 시간을 확보.
*   **UI:** 기록된 감정은 흙 속에서 "발아 중"인 상태. 겉으로는 작은 새싹만 보임.

### Phase 3: Bloom (Reframe/Analysis)
*   **Trigger:** 일정 시간 경과 후 알림 ("새싹이 자라났어요. 어떤 꽃인지 확인해볼까요?").
*   **Action:** 
    *   과거의 기록을 다시 열어봄 (꽃이 핌).
    *   **구체적인 내용 기록 (Detailed Journaling):** 그때의 상황을 자세히 서술 (물 주기).
    *   **Cognitive Analysis:**
        *   자동적 사고(Automatic Thought) 가지치기.
        *   인지적 오류(Cognitive Distortion) 식별.
        *   대안적 사고(Alternative Thought)로 열매 맺기.
*   **Reward:** 'Insight Fruit' 획득 -> 정원 꾸미기 아이템으로 활용.
*   **Output:** `EmotionRecord` 업데이트 (Status: `analyzed`).

## 3. Data Requirements
*   **Delay Duration:** Default 3 hours (Configurable).
*   **Analysis Prompts:** 식물 성장을 돕는 정원사의 조언 같은 톤앤매너.
