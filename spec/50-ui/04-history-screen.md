# 04. History Screen: 정원 일지 (The Garden Journal)

> **"지나간 감정은 사라지는 것이 아니라, 토양이 되어 당신을 지탱합니다."**

History 화면은 단순한 데이터의 나열이 아닙니다.  
사용자가 가꿔온 마음의 정원을 **'계절(Calendar)'**과 **'수확물(List)'**의 형태로 돌아보는 공간입니다.

---

## 1. Core Philosophy (Expert Concepts)

### 🌱 Dr. Mind (Psychology)
*   **Narrative Integration (서사적 통합):** 파편화된 감정들을 시간 순서대로 엮어 '나의 이야기'로 만듭니다.
*   **Meaning Making (의미 부여):** 부정적인 감정(비, 구름)도 정원을 키우는 데 필수적인 '영양분'이었음을 시각적으로 확인합니다.

### 🧠 Dr. Neuro (Neuroscience)
*   **Pattern Recognition (패턴 인식):** "나는 언제 주로 붉은색(스트레스) 식물을 심는가?"를 스스로 인지하게 합니다.
*   **Reflective Pause:** 기록을 되돌아보는 행위 자체가 전두엽을 활성화시켜 감정 조절 능력을 키웁니다.

### 🎨 Artist Esthetic (Design)
*   **Botanical Illustration:** 딱딱한 리스트 대신, 식물 도감(Botanical Journal)을 보는 듯한 아날로그 감성을 전달합니다.
*   **Seasonality:** 월별(Month) 뷰는 계절의 흐름처럼 색감의 변화를 보여줍니다.

---

## 2. Default View: The Calendar (마음의 계절)

사용자가 진입했을 때 가장 먼저 마주하는 뷰입니다. 한 달 동안의 감정 흐름을 한눈에 파악합니다.

### 2.1 UI Components
1.  **Month Header:**
    *   `YYYY년 M월` 타이틀.
    *   좌우 스와이프 또는 화살표로 월 이동.
2.  **Mental Calendar:**
    *   일반적인 달력 그리드.
    *   날짜 대신 해당 날짜에 **가장 우세했던 감정의 '심볼(씨앗/식물 아이콘)'**이 표시됩니다.
    *   *Rule:* 하루에 여러 기록이 있다면?
        *   **Option A:** 가장 마지막 기록.
        *   **Option B:** 가장 강렬했던(Arousal이 높았던) 기록. (채택: Dr. Neuro 추천 - 강렬한 기억이 도파민 회로에 더 큰 영향을 줌)
    *   기록이 없는 날은 빈 땅(Soil)으로 표현.
3.  **Monthly Insight (Dr. Mind's Whisper):**
    *   달력 하단에 한 줄 요약 제공.
    *   *Ex) "이번 달은 비(우울)가 많이 내렸네요. 덕분에 뿌리가 더 깊어졌을 거예요."*

---

## 3. Detailed View: The Timeline (수확물 목록)

달력의 특정 날짜를 탭하거나, 뷰 모드를 변경하면 나타나는 상세 리스트입니다.

### 3.1 UI Components
1.  **Timeline Card (각 기록 아이템):**
    *   **Time:** 기록 시간 (오전 10:30).
    *   **Emotion Icon:** 저장된 식물/씨앗 아이콘.
    *   **Emotion Name:** 사용자가 선택했던 태그 (예: 씁쓸한, 홀가분한).
    *   **Note Preview:** 작성한 메모의 첫 1-2줄 (말줄임표).
2.  **Visual Metaphor:**
    *   카드 배경은 은은한 **Glassmorphism** (Dark Theme).
    *   왼쪽 라인을 따라 줄기(Stem)가 이어지는 듯한 연결선 디자인.

### 3.2 Interactions
*   **Tap:** 카드를 누르면 상세 팝업(또는 확장)되어 전체 메모와 태그를 확인.
*   **Long Press:** 수정 또는 삭제 (단, Dr. Mind는 삭제를 권장하지 않음 - "감정을 부정하지 마세요").

---

## 4. Technical Specs

### 4.1 Data Fetching (Isar)
*   **Collection:** `EmotionRecord`
*   **Query:**
    *   `filter().dateBetween(startOfMonth, endOfMonth)`
    *   `sortByDateDesc()`
*   **Pagination:**
    *   Calendar View: 월 단위 로드.
    *   List View: 20개씩 Infinite Scroll.

### 4.2 State Management (Riverpod)
*   `historyPeriodProvider`: 현재 조회 중인 년/월 상태.
*   `historyRecordsProvider`: 해당 기간의 비동기 데이터 리스트 (`AsyncValue`).

---

## 5. Implementation Roadmap (Planner Flow)

1.  **Lv 1 (MVP):** 단순 타임라인 리스트 (텍스트 + 아이콘) 구현. `query().sortByDateDesc()` 활용.
2.  **Lv 2:** 캘린더 뷰 구현. `table_calendar` 패키지 커스텀.
3.  **Lv 3:** 감정별 필터링 기능 및 Insight 메시지 로직 추가.
