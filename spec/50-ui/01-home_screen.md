# UI Spec: Mind-Gardener Home Screen (Main)

## 1. Overview
메인 홈 화면은 사용자의 '마음의 정원'을 시각화하는 **관찰(Observation)** 및 **상호작용(Care)** 공간입니다. 온보딩에서 설정한 환경 변수와 심어진 씨앗이 실제 화분으로 구현되어 나타납니다.

## 2. Layout & Composition

### 2.1 환경 배경 (Environment Background)
*   **Sunlight (Valence):** 하늘의 밝기, 낮/밤의 변화, 태양/달의 위치.
*   **Temperature (Arousal):** 전체적인 색조(Tint). (Cool: 푸른빛, Warm: 붉은/주황빛)
*   **Humidity (Immersion):** 대기의 질감, 안개, 구름의 밀도. (Low: 선명/건조, High: 흐릿/몽환적)

### 2.2 화분 (My Mind Pot)
*   **Visual:** `assets/images/pots/pot_1.png` 이미지 사용 (테라코타 스타일).
*   **Interaction:**
    *   터치 시 약간의 흔들림 (Haptic Feedback).
    *   먼지 쌓임 효과 (장기 미접속 시).
*   **Plant State:** 현재 식물의 성장 단계(Seed -> Sprout -> Leaf -> Bud -> Bloom)를 보여줍니다.
*   **Physics:** 기기를 기울이면(Gyroscope) 식물이 살짝 흔들리거나, 터치 시 반응합니다.

### 2.3 UI Overlay (HUD)
최소한의 UI만 노출하여 몰입감을 높입니다.
*   **Top:**
    *   Date/Weather: 현실 날짜와 '마음의 날씨' 요약 아이콘.
    *   Menu: 설정 및 도감(Collection) 접근 버튼.
*   **Bottom:**
    *   **Action Bar:** Gardening actions.
        *   💧 **Watering:** 탭하여 기록하기 (Quick Log) -> 식물에게 물주기.
        *   ✂️ **Pruning:** 길게 눌러 상세 기록하기 (Deep Log) -> 가지치기/다듬기.

## 3. Interactions
*   **Idle:** 식물은 미세하게 숨을 쉬듯 움직입니다 (Breathing Animation).
*   **Tap Pot:** 화분이 톡톡거리는 소리와 함께 반응합니다. '잘 지내니?' 메시지 팝업.
*   **Watering (Short Record):** 물뿌리개 아이콘을 드래그하여 화분에 물을 주면, 토양 색이 젖어들고 식물이 생기를 띱니다.

## 4. Technical Requirements
*   **Data Source:** `OnboardingRepository`에서 초기 환경/씨앗 데이터 로드. 이후 `HappyRecordRepository`와 연동하여 성장 반영.
*   **Rendering:** `CustomPainter` 또는 Rive/Lottie 애니메이션 활용. (초기 단계는 Code-based CustomPaint 권장)
