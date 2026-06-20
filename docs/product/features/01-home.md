<!-- COMMIT_STATUS START -->
> **커밋 상태**
> - 기준 커밋: `4a19cab93dfc60bebbcd001fbb8bbf196b447490` (`main`)
> - 최근 커밋: `4a19cab93dfc` docs: refresh project documentation status
> - 커밋 일시: `2026-06-20T22:38:59+09:00`
> - 워킹트리: `dirty (12 files)`
> - 문서 갱신: `2026-06-20 22:39:28 +0900`
<!-- COMMIT_STATUS END -->

# 01. 홈 화면 (Home Screen) - The Living Mirror

## 1. 개요 (Overview)
*   **Concept:** **"The Mirror, Not a Game"** (게임이 아닌, 나를 비추는 거울)
*   **Core Value:** **Minimalism & Restoration** (미니멀리즘과 회복)
*   **Hierarchy:** **Discovery Card (주인공) > Plant (배경적 상징)**
*   **Version:** 2.0 (Glassmorphism & Discovery-First)

---

## 2. 화면 구성 (Layout Structure)

### 2.1 Z-Index Layers
화면은 크게 배경(식물 포함), 정보(유리 카드), 네비게이션으로 구분됩니다.

*   **Layer 0 (Background): [Atmosphere & Plant]**
    *   **Background Image:** 시간대(Morning, Afternoon, Evening, Night)에 따라 변하는 감성적인 배경.
    *   **Tone Down Mask:** 배경 위에 50% Dark Gray Mask를 씌워 차분한 분위기 조성 및 텍스트 가독성 확보.
    *   **Plant (De-emphasized):** 화면 **하단**에 배치, 크기 축소(Width 220), 투명도(Opacity 0.8) 적용. 시선을 강탈하지 않고 은은하게 존재.
*   **Layer 1 (Foreground): [Information & Action]**
    *   **Header Info:** 날짜 및 시간대 상태 텍스트 (e.g., "Thu, Jan 22 · Evening").
    *   **Glass Card (Focus Area):** '이번에 살펴보는 것', '나의 수면 패턴' 등 현재 집중 중인 **발견 퀘스트**를 보여주는 반투명 유리 카드.
    *   **CTA Button:** 하단에 부드러운 초대형 버튼 **"오늘의 기록 (Today's Log)"**. 투명도와 블러 효과로 강요하지 않는 디자인.
*   **Layer 2 (Navigation): [Bottom Dock]**
    *   **Glass Bottom Bar:** 4탭 구조의 하단 네비게이션.

---

## 3. 주요 오브젝트 (Key Objects)

### A. 🪟 Glass Discovery Card (상단 주인공)
*   **위치:** 화면 상단 (헤더 아래).
*   **기능:** 사용자가 현재 진행 중인 '발견 퀘스트'의 진행 상황과 주제 표시.
*   **Visual:** `BackdropFilter`를 활용한 Glassmorphism. 화면의 시각적 중심(Identity).

### B. � The Background Plant (하단 배경)
*   **위치:** 화면 하단 중앙 (네비게이션 바 위).
*   **역할:** 성장의 보상이 아닌, 내면 상태를 반영하는 **거울**.
*   **Visual:** 크기가 작고(20~25% 축소), 살짝 투명하며(0.8), 배경에 스며드는 느낌.

### C. 🔘 CTA Button (하단 액션)
*   **Label:** "오늘의 기록" (감정 기록하기 → 변경)
*   **Style:** `Icons.edit_outlined` + Text. 배경은 투명도 높은 화이트(Alpha 0.05) + 블러 처리. 테두리는 매우 얇게.
*   **Tone:** 명령(Do this!)이 아닌 **초대(Why not?)**의 뉘앙스.

---

## 4. 네비게이션 (Navigation)

### Bottom Tab Bar (4 Tabs)
중앙의 '추가(+)' 버튼을 삭제하고, 기능별 4탭 구조로 단순화.

1.  **🏠 홈 (Home):** 현재 화면. 발견 카드와 식물.
2.  **📅 기록 (Logs):** 과거의 감정 및 퀘스트 기록 모음 (History).
3.  **🧭 발견 (Discovery):** 새로운 발견 퀘스트 탐색 및 선택 (Insight).
4.  **🪷 휴식 (Rest):** (구 설정) 앱 설정 및 휴식 모드, 도감 등. 힐링 컨셉의 `Spa` 아이콘 사용.

---

## 5. Visual Interactions

*   **Time-based Vibe:** 시간(시)에 따라 `_getTimeStatus` 로직으로 Morning/Afternoon/Evening/Night 텍스트 및 배경 분위기 전환.
*   **Glass Effect:** 모든 컨테이너(카드, 버튼, 탭바)에 일관된 Glassmorphism(Blur + Translucency) 적용.
