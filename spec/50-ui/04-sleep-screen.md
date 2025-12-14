# 1.4 Sleep Recording: Dreaming (꿈꾸기)

| Attribute | Value |
| :--- | :--- |
| **Version** | 1.0 |
| **Status** | Final Draft |
| **Date** | 2025-12-14 |
| **Author** | Mind-Gardener Committee |
| **Related** | `spec/10-domain/20-core-mechanics.md` |

## 1. 기획 의도 (Design Intent)
> **"Sleep is the soil of the mind."**

수면은 마음 정원의 토양입니다. 밤사이 충분히 쉬었는지 확인하는 것은 감정 조절의 기본입니다. 복잡한 수면 분석보다는 **'주관적인 개운함'**을 기록하는 데 집중합니다.

## 2. 진입 (Trigger)
1.  **Morning Check-in:** 기상 시간 설정(예: 07:00) 이후 첫 접속 시 팝업.
2.  **Manual:** 홈 화면 하단 메뉴(또는 설정)에서 진입.

## 3. 화면 구성 (Layout)

### 1. Concept: **The Golden Hour**
*   **Core Metaphor:** "수면 배터리 (Sleep Battery)" - 잠은 충전이다.
*   **Key Message:** "언제 자느냐가 얼마나 자느냐보다 중요합니다."
*   **Golden Logic:** 기상 희망 시간을 기준으로 90분 사이클(1.5h) 배수로 최적 취침 시간을 역산하여 제안.

## 2. Screen Layout (Feature-Sliced)

### 2.1 Top: Sleep Battery & Moon Phase
*   **Moon Time Dial:** 기존 문 페이즈 다이얼 유지. (직관적인 24시간 원형 시계).
*   **Battery Indicator:** 다이얼 중앙에 수면 효율(Sleep Efficiency)과 충전 상태를 시각화.
    *   초록빛: 90% 이상 (7.5h + 5 Cycles)
    *   노란빛: 85% ~ 89%
    *   붉은빛: 85% 미만
*   **Golden Hour Marker:** 다이얼 상에 **'최적 취침 시간'** 구간을 하이라이팅 표시.
    *   *Ex: 07:00 기상 시 -> 23:15~23:45 구간을 반짝이는 별무리로 표시.*

### 3.3 Quality Slider (수면 질)
*   **Question:** *"오늘 아침, 얼마나 개운한가요?"*
*   **Input:** 5단계 이모지 슬라이더.
    1.  🧟 **Exhausted (좀비):** 하나도 못 잤음.
    2.  😫 **Tired (피곤):** 자다 깸/꿈자리 사나움.
    3.  😐 **Okay (보통):** 그냥 적당함.
    4.  🙂 **Good (좋음):** 꽤 개운함.
    5.  ✨ **Refreshed (상쾌):** 날아갈 것 같음.

### 3.4 Sleep Factors (수면 변수)
*   **Alarm Check:** *"알람 없이 일어났나요?"* (Switch/Checkbox).
*   **Tags:** *"어젯밤, 잠들기 전에..."* (Multi-select Chips).
    *   🍺 음주, ☕ 카페인, 📱 스마트폰, 🍗 야식
    *   🏃 운동, 🛁 샤워, 💊 약, 🧘 명상

## 4. Feedback & Reward
*   **Visual:** 기록 완료 시, 정원의 하늘 색깔이 바뀜 (상쾌하면 맑은 아침, 피곤하면 흐린 안개).
*   **Buff:** '상쾌함' 기록 시, 당일 획득 XP +10% 보너스 (Well-rested Buff).
*   **Alert:** '피곤함'이 3일 연속 지속되면, *"카페인을 줄여보세요"* 등의 Dr. Neuro 팁 카드 제공.
