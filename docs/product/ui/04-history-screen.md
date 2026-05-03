# 04. Archive Screen: 정원 아카이브 (The Garden Archive)

> **"지나간 감정은 사라지는 것이 아니라, 뿌리(Roots)가 되어 당신을 지탱합니다."**

Archive 화면은 단순한 데이터의 나열이 아닙니다.
**땅속(Underground)**으로 내려가 식물의 **뿌리(Roots)**를 확인하는 경험입니다.

---

## 1. Core Concept (Roots & Seasons)
*   **Location:** 홈 화면에서 **Swipe Up** (땅속으로 이동).
*   **Metaphor:**
    *   **List/Timeline:** 깊게 뻗은 뿌리 줄기.
    *   **Calendar:** 계절의 흐름 (지층의 단면).

---

## 2. Views

### 2.1 Timeline View (Default: Roots)
*   **Visual:** 화면 좌측을 따라 굵은 뿌리 줄기가 이어짐.
*   **Nodes:** 각 기록(Record)이 뿌리의 매듭(Node)처럼 표현됨.
    *   **Color:** 감정의 색상으로 빛나는 보석 같은 매듭.
*   **Content:**
    *   시간, 감정 아이콘, 짧은 메모.

### 2.2 Calendar View (Monthly Seasons)
*   **Action:** 상단 '달력' 버튼 토글.
*   **Visual:** 한 달 동안 피워낸 **'마음의 정원'** 전경.
    *   날짜별 그리드에 해당 날짜의 대표 감정(아이콘) 표시.
    *   월별 **'Insight Message'** (Dr. Mind의 한마디) 제공.

---

## 3. Interactions
*   **Swipe Down (↓):** 다시 지상(홈 화면)으로 복귀.
*   **Tap Node:** 상세 내용 팝업.
*   **Long Press:** 수정/삭제 (권장하지 않음).

---

## 4. Technical Specs
*   **Data Source:** `LocalDbService` (Isar).
*   **Filters:** 날짜(Date), 감정(Emotion), 다듬기 여부(Cared).
