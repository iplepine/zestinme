<!-- COMMIT_STATUS START -->
> **커밋 상태**
> - 기준 커밋: `4a19cab93dfc60bebbcd001fbb8bbf196b447490` (`main`)
> - 최근 커밋: `4a19cab93dfc` docs: refresh project documentation status
> - 커밋 일시: `2026-06-20T22:38:59+09:00`
> - 워킹트리: `dirty (12 files)`
> - 문서 갱신: `2026-06-20 22:39:28 +0900`
<!-- COMMIT_STATUS END -->

# 1.0 Onboarding: The Void Garden (Refined)

| Attribute | Value |
| :--- | :--- |
| **Version** | 2.6 |
| **Status** | Concept Refined (No Pot) |
| **Date** | 2026-01-21 |
| **Author** | Mind-Gardener Committee |
| **Related** | `domain/20-core-mechanics.md` |

## 1. 기획 의도 (Design Intent)

> **Narrative Theme:** "Restoration & Resounding" (회복과 공명)

온보딩은 단순한 설정 과정이 아니라, **방치된 마음(Void)을 안식처(Sanctuary)로 바꾸는 의식(Ritual)**입니다. 이제 '화분'이라는 틀을 벗어나, 광활하고 깊은 **내면의 정원(Void Garden)** 그 자체와 마주합니다.

## 2. 시퀀스 상세 흐름 (User Flow)

### Scene 0: 재회 (The Reunion)
*   **Context:** 칠흑 같은 어둠 속, 한 줄기 빛이 비치는 **작은 흙집(Ground) 또는 빈 공간**이 보입니다.
*   **Line:** *"오랫동안 잊고 지낸 당신의 마음 공간을 찾았습니다."*
*   **Action:** 터치하여 그곳으로 다가갑니다.

### Scene 1: 걷어내기 (Clarification)
*   **Context:** 공간이 뿌연 안개나 먼지로 가득 차 형체가 흐릿합니다.
*   **Action:** 사용자가 손가락으로 문질러 안개를 걷어내고 바닥을 맑게 만듭니다. (Scratch Interaction)
*   **Line:** *"마음에도 먼지가 쌓이나 봅니다. 잠시 걷어내 볼까요?"*
*   **Climax:** 공간이 맑아지면, 바닥의 문양이 반짝입니다. *"이곳을 가꿀 당신의 이름은..."*
*   **Input:** 닉네임 입력.

### Scene 2: 공명 (Resonance - Environment)
*   **Context:** 공간은 맑아졌지만, 아직 온기가 없습니다.
*   **Line:** *"지금 당신의 마음 날씨는 어떤가요?"*
*   **Interaction:** 
    *   **조도 (Sunlight/Valence):** "오늘 기분은 밝은가요, 차분한가요?" (밝음 ↔ 어둠)
    *   **온도/습도 (Temp/Hum/Arousal):** "에너지가 넘치나요, 아니면 쉬고 싶은가요?" (활력 ↔ 휴식)
*   **Feedback:** 조절에 따라 주변 배경색과 BGM(앰비언스)이 실시간으로 바뀝니다. 환경이 준비되면 *"준비되었습니다."*

### Scene 3: 만남 (The Encounter - Mystery Seed)
*   **Event:** 사용자가 설정한 환경에 반응하여, 하늘에서 빛나는 씨앗 하나가 천천히 내려와 정중앙에 안착합니다.
*   **Line:** *"당신의 마음에 이끌려, 작은 씨앗이 찾아왔습니다."*
*   **Mystery:** 씨앗의 종류는 알려주지 않습니다. 단지 그 존재감(두근거림)만 느낄 수 있습니다. *"어떤 꽃을 피우게 될까요?"*

### Scene 4: 첫 심기 (The Planting - Commitment)
*   **Step 1 (Selection):** *"지금 이 순간, 당신의 마음은 어떤 이름인가요?"*
    *   감정 단어 선택 (기쁨, 슬픔, 화남, 불안, 평온 등)
*   **Step 2 (Detail):** *"그 마음의 깊은 곳에는 무엇이 있나요?"*
    *   구체적인 이유나 상황을 짧게 기록합니다.
*   **Action:** 기록이 끝나면, 그 감정이 **'마음의 씨앗'**으로 응축됩니다.
*   **Animation:** 씨앗을 터치하여 내면의 땅에 심습니다.
*   **Ending:** *"당신의 '슬픔'은 이제 이 공간 속에서 새로운 의미로 자라날 것입니다."*
*   **Trasition:** 홈 화면 진입.

## 3. 데이터 흐름 & 지속성 (Data Flow & Persistence)

1.  **Scene 2 완료 시점:** 사용자 입력(환경값)에 따라 `PlantService`가 이미 식물 종을 배정합니다.
2.  **Scene 3/4 (Persistence):**
    *   배정된 식물의 ID를 DB에 저장합니다.
    *   **온보딩 완료 플래그(`tutorialCompleted = true`)를 로컬 DB(Isar)에 영구 저장합니다.**
3.  **App Launch (Auto-Skip):**
    *   앱 실행 시 `AppRouter`와 `OnboardingViewModel`이 DB를 조회합니다.
    *   `tutorialCompleted`가 `true`인 경우, **온보딩 화면을 건너뛰고 즉시 홈 화면으로 진입합니다.**
4.  **Home:** 식물은 더 이상 화분에 갇혀 있지 않고, 정원의 풍경 그 자체가 되어 자라납니다.

## 4. UI/UX Detail
*   **Tone:** 신비롭고, 고요하며, 서정적인 어조.
*   **Visual:** '틀(Pot)'을 깨고 나가는 해방감을 주기 위해 테두리가 없는 유기적인 형태의 레이아웃 지향.
