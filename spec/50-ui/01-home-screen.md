# 1.1 Home Screen: The Inner Garden (내면의 정원)

| Attribute | Value |
| :--- | :--- |
| **Version** | 1.3 |
| **Status** | Implementation Phase |
| **Date** | 2025-12-18 |
| **Author** | Mind-Gardener Committee |
| **Related** | `spec/20-feature/01-home.md` |

## 1. 개요 (Overview)

> **"The Living Mirror"**

홈 화면은 기능의 목록이 아닌, **'공간(Space)'**입니다.
UI 요소들은 버튼이 아닌 **'오브젝트(Object)'**로서 존재하며, 정원의 깊이감(Depth) 속에 배치됩니다.

---

## 2. 화면 구성 (Layered Architecture)

화면은 `Stack` 기반의 3단 레이어로 구성됩니다.

### 2.1 Layer 0: Background (Atmosphere)
*   **Weather Shader:** 감정의 Valence(긍/부정) x Arousal(에너지)에 따라 실시간 렌더링.
    *   맑음(Sunny), 밤(Night), 폭풍(Storm), 흐림(Rainy).
*   **Soundscape:** 날씨에 맞는 백색소음 자동 재생.

### 2.2 Layer 1: Mid-Ground (The Garden)
*   **Ground:** 식물이 심어진 땅. 하단에서 1/3 지점.
*   **🌱 Mystery Plant (Center):**
    *   화면의 주인공. 사용자의 돌봄에 따라 성장.
    *   **Interaction:**
        *   **Tap:** `Seeding (마음 기록)` 화면으로 이동.
        *   **Thirsty (물방울):** `Pruning (다듬기)` 진입 트리거.
*   **🪞 Small Pond (Bottom Center):**
    *   식물 뿌리 근처의 작은 연못.
    *   **Action:** 탭 시 **자아 정체성 카드 (Self-Mirror)** 팝업.

### 2.3 Layer 2: Foreground (Props & UI)
*   **Header Area:**
    *   **Title (Center):** `"{User}의 내면 정원"` (스크롤 시 Fade Out 가능).
    *   **🔋 Moon Lantern (Top Left):**
        *   나무에 걸린 랜턴 형태. 수면 효율(Sleep Efficiency)에 따라 밝기 변화.
        *   **Action:** 탭 시 `Recharge (수면 충전)` 화면으로 이동.
*   **Middle Area:**
    *   **🍃 Wind Chime (Mid Right):**
        *   화면 우측 가장자리에 걸린 풍경.
        *   **Action:** 탭 시 `Ventilation (마음 환기)` 타이머 실행.
*   **Footer Area (FABs):**
    *   **Left (Archive):** `Icons.history` (뿌리/아카이브).
    *   **Right (Record):** `Icons.edit` ("마음 기록" / Seeding).

---

## 3. 핵심 인터랙션 (Core Interactions)

### 3.1 Growth Loop
1.  **Watering (기록):** 우측 하단 FAB 또는 식물 터치 -> 감정 기록.
2.  **Environment (날씨):** 기록 즉시 배경 날씨 변화.
3.  **Pruning (다듬기):** 4시간 후 식물에 **물방울** 생성 -> 터치하여 회고 -> **성장(Level Up)**.

### 3.2 Roots Gesture (Archive)
*   **Swipe Up:** 화면을 위로 쓸어 올리면 카메라가 땅속으로 들어가며 **Archive (Monthly View)**로 전환.

---

## 4. Design Details
*   **Theme:** `AppTheme.darkTheme` (기본값).
*   **Motion:** 모든 오브젝트는 미세하게 움직임(Breathing/Floating)을 가져야 함.
*   **Feedback:** 햅틱 반응 필수 (물방울 터치 시 톡! 하는 느낌 등).
