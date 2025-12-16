# 1.1 Home Screen: The Inner Garden (내면의 정원)

| Attribute | Value |
| :--- | :--- |
| **Version** | 1.2 |
| **Status** | Final Spec |
| **Date** | 2025-12-16 |
| **Author** | Mind-Gardener Committee |
| **Related** | `spec/20-feature/00-tutorial.md`, `spec/50-ui/03-caring-flow.md`, `spec/50-ui/04-sleep-screen.md` |

## 1. 기획 의도 (Design Intent)

> **"당신의 마음이 숨 쉬는 곳"**

홈 화면은 사용자의 정신 상태(Mental State)가 **시각화된 정원(Biosphere)**입니다.
사용자는 이곳에서 자신의 '마음 식물'을 돌보며, 스스로를 돌보는 감각을 익힙니다. 이것은 앱의 **Main Hub** 역할을 합니다.

**Core Philosophy:** "The Mirror"
*   식물을 조작하는 것이 아니라, 식물을 통해 나를 **'자각(Awareness)'**하는 것이 목표입니다.

## 2. 화면 구성 (Layout)

### 2.1 Top Area: Mental Weather & Recharge
*   **좌측 (Weather):** 
    *   현재 정원의 환경 상태 (햇빛/온도/습도 게이지).
*   **우측 (Sleep Battery):** [NEW]
    *   **Icon:** `Icons.battery_charging_full` (수면 효율에 따라 잔량/색상 변화).
    *   **Action:** 탭 시 **수면 기록 화면 (`/sleep`)**으로 이동.
    *   **Metaphor:** "나의 에너지를 충전하는 곳".

### 2.2 Center Area: The Plant & Caring Trigger
*   **위치:** 중앙 60%
*   **구성:**
    *   **Main Visual:** 현재 키우고 있는 식물 (성장 단계에 따라 변화).
    *   **Background:** 시간대와 날씨(Mental Weather)를 반영한 동적 배경.
    *   **Pot:** 사용자가 선택하거나 획득한 화분.
*   **Caring Trigger (Water Drop):** [NEW]
    *   **Condition:** 돌봄(Caring)이 필요한 감정 기록(Seed)이 있을 때 식물 주변에 💧(물방울) 아이콘 등장.
    *   **Animation:** 은은하게 반짝이거나(Pulse), 식물 위를 부유함.
    *   **Action:** 탭 시 **돌보기 화면 (`/caring`)** 및 코칭 플로우 시작.

### 2.3 Bottom Area: Actions (FAB)
*   **좌측 (History):**
    *   **Icon:** `Icons.auto_stories` (앨범/관찰일지).
    *   **Action:** **지난 기록 (`/history`)** 화면으로 이동.
*   **우측 (Seeding):**
    *   **Icon:** `Icons.edit` (또는 `Icons.spa`).
    *   **Action:** **새 감정 기록 (`/seeding`)** 화면으로 이동.
*   **Note:** 기존의 하단 버튼 바("물주기/다듬기")는 제거되고 FAB로 통합됨.

## 3. 핵심 인터랙션 (Core Interactions)

### 3.1 Caring Loop (순환)
*   **Trigger (물방울)** -> **Action (돌보기)** -> **Reward (성장/빛남)**
*   홈 화면은 이 순환의 시작점이자 도착점입니다.

### 3.2 묻고 답하기 (Self-Talk)
*   식물을 탭하면, 식물이 현재 상태(Visual)에 기반한 **상태 메시지**나 **짧은 위로**를 띄웁니다.

## 4. Design System
*   **Theme:** `AppTheme.darkTheme` (Night Garden)
*   **Typography:** Rounded Fonts (감성적).
*   **Colors:** Deep Blue, Charcoal Background + Vignette.
