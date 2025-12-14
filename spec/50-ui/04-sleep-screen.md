# 1.4 Sleep Recording: Recharge (충전하기)

| Attribute | Value |
| :--- | :--- |
| **Version** | 1.1 |
| **Status** | Final Draft |
| **Last Updated** | 2025-12-14 |
| **Related** | `spec/20-feature/04-sleep.md` |

## 1. 기획 의도 (Design Intent)
> **"Sleep is the soil of the mind."**

수면은 당일의 컨디션을 결정짓는 가장 중요한 요소입니다. 단순히 "몇 시간 잤나"를 넘어, **"얼마나 개운하게 일어났나" (Refreshment)**를 기록하고, 이를 바탕으로 **최적의 수면 시간(Golden Hour)**을 찾는 여정을 시각화합니다.

## 2. 진입 (Trigger)
1.  **Morning Check-in (모닝 체크인):**
    *   기상 예정 시간 이후 앱 실행 시 자동으로 팝업.
    *   "좋은 아침입니다! 어젯밤은 어떠셨나요?"
2.  **Manual Entry:** 홈 화면 > 수면 배터리 위젯 터치.

## 3. 화면 구성 및 플로우 (Layout & Flow)

### 3.1 메인 스크린 (Sleep Dashboard)
*   **Concept:** **The Golden Hour & Sleep Battery**
*   **Moon Time Dial:** 24시간 원형 다이얼 시계.
    *   **Golden Hour Marker:** 나의 최적 취침 시간 구간(예: 23:15~23:45)을 별무리로 하이라이팅.
*   **Sleep Battery:** 다이얼 중앙에 오늘의 **수면 효율(Sleep Efficiency)**에 따른 배터리 잔량 표시.
    *   🔋 Green (90%↑): "완전 충전! 상쾌한 하루 되세요."
    *   🔋 Yellow (85~89%): "적절한 휴식입니다."
    *   🪫 Red (<85%): "충전이 부족해요. 오늘 밤은 일찍 쉬세요."

### 3.2 모닝 체크인 (Morning Check-in)
기상 직후 순차적으로 진행되는 인터랙션 플로우입니다.

#### Step 1: Time Check
*   "오늘 몇 시에 일어나셨나요?"
*   기본값: 알람 해제 시간 or 핸드폰 사용 시작 시간.

#### Step 2: Sleep Latency (입면 잠복기) [NEW]
*   "자려고 누워서 잠들기까지 얼마나 걸렸나요?"
*   Input: Segmented Control or Slider
    *   🚀 5분 미만 (기절)
    *   😌 15분 (양호)
    *   🤔 30분 (보통)
    *   😵 1시간 이상 (불면)

#### Step 3: Refreshment (개운함)
*   "얼마나 개운한가요?" (0-100 Slider).
*   이모지로 상태 피드백 (🧟 좀비 ... ✨ 상쾌).

#### Step 4: Wake Type (기상 유형)
*   "알람 없이 눈이 떠졌나요?" (Yes/No).
*   "알람 끄고 바로 일어났나요?" (Yes/No) - *스누즈 횟수 카운팅 제거 (단순화)*

#### Step 4: Factors (수면 영향 태그)
어젯밤 수면에 영향을 준 요인을 선택합니다. 4가지 카테고리로 분류하여 제공합니다.

*   **A. 섭취 (Ingestion):** ☕ #카페인_오후, 🍺 #알코올, 🍗 #야식, 🍽 #공복
*   **B. 활동 (Activity):** 📱 #스크린타임, 🏃 #격한운동_저녁, 📖 #독서/명상, 💤 #낮잠
*   **C. 환경 (Environment):** 🔊 #소음, 💡 #빛, 🌡 #온도_부적절, 🏨 #잠자리_변경
*   **D. 상태 (Condition):** 🤯 #스트레스, 🩸 #생리통/호르몬, 🤒 #통증/질병

## 4. 기록 완료 및 피드백 (Feedback)
*   **Visual Reward:** 기록 완료 시, 메인 정원의 하늘이 수면 질에 따라 변화 (맑음/흐림/안개).
*   **Buff Effect:** 높은 Refreshment 점수 기록 시, 당일 **경험치(XP) +10% 버프** 제공.
*   **Insight Card:** "술을 마신 날은 개운함이 평균 15점 낮아요." (수면-태그 상관분석 결과).
