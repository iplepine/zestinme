# 1.1 Home Screen: The Inner Sanctuary (내면의 안식처)

| Attribute | Value |
| :--- | :--- |
| **Version** | 2.1 (Full Immersion) |
| **Status** | Implementation Phase |
| **Concept** | **"The Window to the Soul"** |

## 1. 개요 (Overview)

> **"식물은 당신의 마음을 비추는 거울입니다."**

홈 화면은 사용자의 내면 세계를 시각적으로 투영하는 공간입니다. 기존의 대시보드 형태를 벗어나, **전체 화면(Full Screen)을 활용한 몰입형 정원**을 구현합니다.

시간의 흐름(아침, 저녁, 밤)에 따라 변화하는 배경과, 그 속에 자연스럽게 녹아든 식물을 통해 심리적 안정감을 제공합니다. UI는 **반투명(Glassmorphism)** 처리를 통해 배경과의 조화를 극대화합니다.

---

## 2. 화면 구성 (Layout)

화면 전체가 하나의 유기적인 공간으로 동작합니다.

### 2.1 Backgrounds (Time & Vibe)
*   **Layer 0 (Base):** 전체 화면을 덮는 고해상도 배경 이미지.
*   **Variables:**
    *   `bg_morning.png`: 활력, 시작 (06:00 ~ 17:00)
    *   `bg_evening.png`: 차분함, 성찰 (17:00 ~ 21:00)
    *   `bg_night.png`: 깊은 휴식, 무의식 (21:00 ~ 06:00)
*   **Effect:** 시간 변화 시 부드러운 Cross-fade 전환.

### 2.2 Hero Object (The Plant)
*   **Layer 1:** 중앙 하단에 배치된 식물 (`rubber_plant_small_01.png`).
*   **Position:** 화면 하단에서 약 15~20% 올라온 위치에 뿌리(화분)를 두고 안정감 있게 배치.
*   **Interaction:**
    *   **Tap:** 식물과 상호작용 (쓰다듬기 효과/대사 출력).
    *   **Idle:** 미세한 숨쉬기 애니메이션 (Scale 1.0 -> 1.02 -> 1.0).

### 2.3 Glass UI Overlay
UI 요소는 배경을 가리지 않도록 **반투명한 유리 질감(Glassmorphism)**으로 처리합니다.

#### Top Area (Status)
*   **Left:** "Mind Gardener" (심플한 로고 타입).
*   **Right:** 설정 등 메뉴 아이콘.
*   **Style:** 배경 흐림(Backdrop Filter + Blur) 없는 텍스트/아이콘 위주.

#### Center-Left/Right (Stats)
식물 주변에 떠있는 형태의 미니멀한 인디케이터.
*   **Moisture (수분):** 물방울 아이콘 + % (ex: 💧 72%).
*   **Growth (성장):** 새싹 아이콘 + Stage (ex: 🌱 Lv.3).

#### Bottom Navigation (Glass Dock)
*   **Style:** 모서리가 둥근 Floating Dock 형태. White w/ opacity 0.1 ~ 0.2.
*   **Blur:** `BackdropFilter` (Blur 10~20).
*   **Items:**
    1.  **Garden (Home)**
    2.  **Logs (기록)**
    3.  **(FAB) Seeding** - 중앙 돌출형, 반투명 그라데이션 버튼.
    4.  **Self (마이페이지)**

---

## 3. Visual Style & Assets
*   **Image Assets:**
    *   Plant: `app/assets/images/plants/rubber_plant_small_01.png`
    *   BG Morning: `app/assets/images/backgrounds/bg_morning.png`
    *   BG Evening: `app/assets/images/backgrounds/bg_evening.png`
    *   BG Night: `app/assets/images/backgrounds/bg_night.png`

*   **Colors (UI):**
    *   **Primary:** White (#FFFFFF)
    *   **Opacity:** 0.6 (Inactive) ~ 1.0 (Active)
    *   **Shadow:** Soft Drop Shadow for depth.

---

## 4. Implementation Note (From Architect Spec)
*   **Stack Widget:** `Stack`을 사용하여 Background -> Plant -> UI 순서로 레이어링.
*   **SafeArea:** 상단/하단 UI가 시스템 영역과 겹치지 않도록 주의하되, 배경 이미지는 `fit: BoxFit.cover`로 전체 영역을 침범해야 함.
*   **Provider:** `TimeSeriesProvider` (가칭)를 통해 현재 시간에 맞는 배경 이미지를 제공.
