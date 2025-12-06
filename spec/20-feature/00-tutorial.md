# 1.0 Onboarding: The Void Garden

| Attribute | Value |
| :--- | :--- |
| **Version** | 2.1 |
| **Status** | Narrative Refined |
| **Date** | 2025-12-06 |
| **Author** | Mind-Angler Committee |
| **Related** | `spec/10-domain/20-core-mechanics.md` |

## 1. 기획 의도 (Design Intent)

> **Narrative Theme:** "Restoration & Resounding" (회복과 공명)

온보딩은 단순한 설정 과정이 아니라, **방치된 마음(Void)을 안식처(Sanctuary)로 바꾸는 의식(Ritual)**입니다.

## 2. 시퀀스 상세 흐름 (User Flow)

### Scene 0: 재회 (The Reunion)
*   **Context:** 칠흑 같은 어둠 속, 낡은 화분 하나가 덩그러니 놓여 있습니다.
*   **Line:** *"오랫동안 방치된 화분을 찾았습니다."*
*   **Action:** 터치하여 화분에 다가갑니다.

### Scene 1: 닦아내기 (Restoration)
*   **Context:** 화분에 먼지가 자욱합니다.
*   **Action:** 사용자가 손가락으로 문찔러 먼지를 닦아냅니다. (Scratch Interaction)
*   **Line:** *"마음에도 먼지가 쌓이나 봅니다."*
*   **Climax:** 먼지가 다 닦이면, 화분의 태그가 반짝입니다. *"이 화분의 주인은..."*
*   **Input:** 닉네임 입력.

### Scene 2: 공명 (Resonance - Environment)
*   **Context:** 화분은 깨끗해졌지만, 주변 공기가 멈춰 있습니다.
*   **Line:** *"당신의 마음 날씨는 어떤가요?"*
*   **Interaction:** 
    *   **조도 (Sunlight/Valence):** "오늘 기분은 밝은가요, 차분한가요?" (밝음 ↔ 어둠)
    *   **온도/습도 (Temp/Hum/Arousal):** "에너지가 넘치나요, 아니면 쉬고 싶은가요?" (활력 ↔ 휴식)
*   **Feedback:** 조절에 따라 주변 배경색과 BGM(앰비언스)이 실시간으로 바뀝니다. 환경이 준비되면 *"준비되었습니다."*

### Scene 3: 만남 (The Encounter - Mystery Seed)
*   **Event:** (구 '씨앗 선택' 삭제) 사용자가 설정한 환경에 반응하여, 하늘에서 빛나는 씨앗 하나가 천천히 내려와 흙에 안착합니다.
*   **Line:** *"당신의 마음에 이끌려, 작은 씨앗이 찾아왔습니다."*
*   **Mystery:** 씨앗의 종류는 알려주지 않습니다. 단지 그 존재감(두근거림)만 느낄 수 있습니다. *"어떤 꽃을 피우게 될까요?"*

### Scene 4: 첫 심기 (The Planting - Commitment)
*   **Step 1 (Selection):** *"지금 이 순간, 당신의 마음은 어떤 이름인가요?"*
    *   감정 단어 선택 (기쁨, 슬픔, 화남, 불안, 평온 등)
*   **Step 2 (Detail):** *"그 마음의 깊은 곳에는 무엇이 있나요?"*
    *   구체적인 이유나 상황을 짧게 기록합니다.
*   **Action:** 기록이 끝나면, 그 감정이 **'마음의 씨앗'**으로 응축됩니다.
*   **Animation:** 씨앗을 터치하여 화분에 심습니다.
*   **Ending:** *"당신의 '슬픔'은 이제 이 화분 속에서 새로운 의미로 자라날 것입니다."*
*   **Trasition:** 홈 화면 진입.

## 3. 데이터 흐름 (Data Flow)

1.  **Scene 2 완료 시점:** 사용자 입력(환경값)에 따라 `PlantService`가 **Stochastic Niche Model**을 돌려 보이지 않는 곳에서 이미 식물 종을 배정합니다.
2.  **Scene 3/4:** 배정된 식물의 ID를 DB에 저장하지만, 사용자에게는 `Mystery Seed` 아이콘과 `? ? ?` 이름으로 표시합니다.
3.  **Home:** 일정 성장치(Level 2 or 3)에 도달했을 때 종(Species)을 공개(Revelation)합니다.

## 4. UI/UX Detail
*   **Tone:** 신비롭고, 고요하며, 서정적인 어조.
*   **Visual:** 입자(Particle) 효과를 많이 사용하여 '마법적인' 느낌 강조.
