# Screen Spec: Emotion Write Screen (The Flow)

## 1. Overview
사용자가 감정을 기록하는 핵심 플로우. 5단계의 Wizard(Step-by-step) 형태로 구성되어 부담을 줄이고 몰입을 유도함.

## 2. Navigation Structure
*   **Type:** PageView or Stepper (Horizontal Scroll disabled, controlled by buttons).
*   **Progress Indicator:** 상단에 현재 단계 표시 (Step 1/5).
*   **Close Button:** 우측 상단 'X'. 기록 중단 시 "저장되지 않은 내용은 사라집니다" 경고 팝업.

## 3. Steps Detail

### Step 1: Affect Labeling (감정 명명)
*   **UI:**
    *   **Russell's Grid:** 2D 좌표 평면 (X: Unpleasant~Pleasant, Y: Low~High Energy).
    *   **Interaction:** 드래그하여 점을 찍으면 해당 좌표에 맞는 감정 단어 리스트(Chips)가 하단에 업데이트됨.
    *   **Emotion Chips:** 추천 단어 3~5개 (예: 분노, 짜증, 불안). 하나 선택 필수.
*   **Next Condition:** 감정 단어 선택 시 '다음' 버튼 활성화.

### Step 2: Context (맥락)
*   **Question:** "지금 어떤 상황인가요?"
*   **UI:**
    *   **Activity Tags:** 업무, 공부, 식사, 이동, 휴식, 수면 등.
    *   **People Tags:** 혼자, 가족, 친구, 동료, 연인 등.
    *   **Location Tags:** 집, 회사, 학교, 카페, 야외 등.
*   **Interaction:** 다중 선택 가능.

### Step 3: Body Sensation (신체 감각)
*   **Question:** "몸에서는 어떤 신호가 느껴지나요?"
*   **UI:**
    *   **Body Map:** 사람 형상 이미지 (머리, 가슴, 배, 손/발).
    *   **Symptom Chips:** 부위 선택 시 관련 증상 노출 (예: 머리 -> 두통, 어지러움).
*   **Interaction:** 부위 터치 -> 증상 선택. (Skip 가능)

### Step 4: Cognition (자동적 사고)
*   **Question:** "그 순간 머릿속을 스쳐 지나가는 생각은 무엇인가요?"
*   **UI:**
    *   **Text Area:** 자유 텍스트 입력창.
    *   **Placeholder:** "예: 나만 뒤처지는 것 같아 불안해."
*   **Interaction:** 텍스트 입력. (Skip 가능)

### Step 5: Action (대처 및 저장)
*   **Question:** "이 감정을 위해 무엇을 했나요?"
*   **UI:**
    *   **Action Input:** 텍스트 입력 또는 추천 칩 (심호흡, 산책, 음악듣기).
    *   **Save Button:** "기록 완료" (Primary Color).
*   **Interaction:** 저장 버튼 클릭 시 DB 저장 후 Home으로 이동 + Success Snackbar.

## 4. Data Requirements
*   각 단계의 입력값은 `EmotionRecord` 객체 하나에 누적됨.
*   최종 저장 시점에 `timestamp` 확정.
