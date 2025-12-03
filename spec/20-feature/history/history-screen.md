# Screen Spec: History Screen

## 1. Overview
과거의 감정 기록을 시간순으로 조회하고, 상세 내용을 확인하는 화면.

## 2. UI Components

### A. App Bar
*   **Title:** "나의 기록"
*   **Back Button:** Home으로 이동.

### B. Filter / Sort (Optional for MVP)
*   **Month Picker:** "2023년 12월" (기본값: 현재 월)

### C. Log List (Main)
*   **Type:** Vertical Scroll List (ListView).
*   **Group:** 날짜별 그룹핑 (예: "오늘", "어제", "12월 1일").
*   **List Item Card:**
    *   **Left:** 감정 이모지 (크게) + 배경색(감정 컬러).
    *   **Center:**
        *   **Title:** 감정 단어 (예: "불안, 초조")
        *   **Subtitle:** 자동적 사고 요약 (1줄) or 활동 태그.
    *   **Right:** 시간 (오전 10:30).
    *   **Interaction:** 클릭 시 상세 다이얼로그/페이지 오픈.

### D. Empty State
*   **Condition:** 기록이 없을 때.
*   **UI:** "아직 기록된 감정이 없어요. 첫 기록을 남겨보세요!" + CTA 버튼.

## 3. Interactions
*   **Item Click:** `HistoryDetailScreen` (또는 Modal BottomSheet) 열기.
    *   상세 화면에서는 기록된 모든 정보(맥락, 신체감각, 생각, 대처)를 보여줌.
    *   수정/삭제 버튼 제공.

## 4. Data Requirements
*   **Query:** `EmotionRecord` 전체 조회 (Sort by `timestamp` DESC).
*   **Pagination:** MVP에서는 20개씩 끊어서 로딩 (Infinite Scroll) 또는 전체 로딩(개수 적을 시).
