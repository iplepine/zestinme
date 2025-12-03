# MVP Scope: InsightMe v0.1

## 1. Goal
사용자가 자신의 감정을 뇌과학적/심리학적 원리에 따라 기록하고, 즉각적인 회고를 할 수 있는 **'Core Loop'** 완성.

## 2. Included Features

### A. Emotion Write Flow (Core)
*   **Spec:** `/spec/20-feature/emotion-write/10-flow-emotion-log.md`
*   **Steps:**
    1.  **Affect Labeling:** Russell's Model (2D Grid) 터치 -> 감정 단어 선택.
    2.  **Context:** 활동(Activity), 사람(People), 장소(Location) 태그 선택.
    3.  **Body Sensation:** 신체 부위 선택 (Body Scan).
    4.  **Cognition:** 자동적 사고(Automatic Thought) 텍스트 입력.
    5.  **Action:** 대처 행동 입력 및 저장.

### B. Home Dashboard
*   **Function:**
    *   현재 날짜/시간 표시.
    *   "오늘의 감정 기록하기" (CTA 버튼).
    *   최근 기록 요약 (Simple List).

### C. History (Log List)
*   **Function:**
    *   과거 기록 리스트 뷰.
    *   상세 보기 (Detail View).

### D. Data Layer
*   **Storage:** 로컬 데이터베이스 (Isar or Hive preferred for Flutter, or SQLite).
*   **Model:** `EmotionRecord` 구현.

## 3. Excluded Features (Post-MVP)
*   회원가입/로그인 (로컬 퍼스트 원칙).
*   서버 동기화.
*   AI 분석 및 인사이트 (Rule-based 코칭만 일부 적용).
*   통계 차트 (History List로 대체).
*   설정 화면 (MVP에서는 하드코딩).

## 4. Success Metric
*   사용자가 앱을 켜서 감정 기록을 완료하기까지 **30초 이내**에 막힘없이 진행 가능한가?
