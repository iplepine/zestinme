# Screen Spec: Home Screen

## 1. Overview
앱 실행 시 가장 먼저 진입하는 메인 대시보드. 사용자의 현재 상태를 환기하고, 기록을 유도하는 것이 주 목적.

## 2. UI Components

### A. Header (Top Bar)
*   **Date Display:** "12월 4일 수요일" (현재 날짜)
*   **Greeting:** 시간대에 따른 인사말 (예: "좋은 아침이에요, Basil님", "오늘 하루도 고생 많았어요")
*   **Settings Icon:** 우측 상단. 설정 화면 이동.

### B. Main Action Area (Center)
*   **CTA Button:** "오늘의 감정 기록하기" (Primary Color, Large Size)
    *   *Micro-copy:* "지금 어떤 기분인가요?"
*   **Character/Image:** 편안함을 주는 일러스트 또는 캐릭터 (Lottie Animation 권장).

### C. Recent History (Bottom)
*   **Section Title:** "최근 기록"
*   **List Item (Preview):**
    *   최근 3개 항목 노출.
    *   구성: 감정 이모지 + 감정 단어 + 시간 (예: "😡 분노 · 오후 2:30")
    *   클릭 시 상세 화면 이동.
*   **View All:** "전체 보기" 버튼 -> History Screen 이동.

## 3. Interactions
*   **CTA Click:** `EmotionWriteScreen`으로 이동 (Bottom-up transition).
*   **List Item Click:** `HistoryDetailScreen`으로 이동.
*   **View All Click:** `HistoryScreen`으로 이동.

## 4. Data Requirements
*   **User Name:** 로컬 저장된 사용자 닉네임.
*   **Recent Records:** `EmotionRecord` DB에서 `timestamp` 내림차순으로 상위 3개 조회.
