# Feature 01: The Inner Garden (Home)

| Attribute | Value |
| :--- | :--- |
| **Version** | 1.0 |
| **Status** | Implementation Phase |
| **Date** | 2025-12-18 |
| **Author** | Mind-Gardener Committee |
| **Related UI** | `spec/50-ui/01-home-screen.md` |

## 1. 개요 (Overview)

> **"마음의 상태가 곧 정원의 날씨가 된다."**

홈 기능은 단순히 앱의 진입점이 아니라, 사용자의 **정신적 생태계(Mental Ecosystem)**를 시각화하는 핵심 기능입니다.
이곳에서 사용자는 자신의 감정(날씨)과 성장(식물)을 직관적으로 확인하고, 자기 돌봄(Caring)의 필요성을 자각합니다.

## 2. 핵심 메커니즘 (Key Mechanics)

### 2.1 Mental Weather (마음의 날씨)
사용자의 최근 감정 기록과 온보딩 데이터를 바탕으로 정원의 환경 변수가 결정됩니다.
(현재는 온보딩 시 설정된 값을 유지하지만, 추후 동적 변화 예정)

*   **Sunlight (햇빛) - Valence (긍부정)**
    *   긍정적 감정 기록이 많을수록 밝고 따뜻한 햇살.
    *   부정적 감정이 지속되면 흐리거나 비.
*   **Temperature (온도) - Arousal (각성도)**
    *   높은 각성(불안, 분노, 흥분) -> 붉고 뜨거운 톤.
    *   낮은 각성(우울, 차분) -> 푸르고 차가운 톤.
*   **Humidity (습도) - Immersion (몰입/강도)**
    *   감정의 깊이가 깊을수록 안개나 이슬 효과.

### 2.2 The Mystery Plant (미스터리 식물)
사용자가 키우는 식물은 완전히 자라기 전까지 정체가 숨겨집니다. 이는 사용자가 결과(식물 종류)보다 **과정(돌봄)**에 집중하게 유도합니다.

*   **Growth Stages (성장 단계):**
    *   **Stage 0: Seed (씨앗)** - "이름 없는 씨앗" (Mystery)
    *   **Stage 1: Sprout (새싹)** - "??? (아직 알 수 없음)"
    *   **Stage 2: Growing (성장)** - 줄기와 잎 발달.
    *   **Stage 3: Bloom (개화/완성)** - **[Reveal]** 식물 이름과 꽃말 공개.

### 2.3 Eco-System Loop (순환)
홈 화면은 모든 기능의 허브(Hub) 역할을 수행합니다.

1.  **Seeding (기록)**: 우측 하단 FAB. 감정의 씨앗을 심음 -> 날씨 변화에 영향.
2.  **Incubation (숙성)**: 기록된 감정은 4시간(또는 야간) 숙성 과정을 거침.
3.  **Caring (돌봄)**: 중앙 Water Drop 트리거. 숙성된 감정을 코칭으로 해소 -> 식물 성장(XP) 및 보상.
4.  **Sleep (수면)**: 우측 상단 배터리. 수면 효율에 따라 정원의 '에너지(배터리)' 충전.

## 3. 데이터 구조 (Data Structure)

### 3.1 Garden State (온보딩 및 메타 데이터)
`OnboardingState`를 확장하여 정원 상태를 관리합니다.

```dart
class OnboardingState {
  // ... existing fields ...
  
  // Gardening State
  final int? assignedPlantId; // 현재 키우는 식물 ID
  final int growthStage;      // 0 ~ 3 (3 = Reveal)
}
```

### 3.2 Interaction Helpers
*   **`HomeProvider`**: `LocalDbService`와 연동하여 실시간 상태(Uncared Records, Sleep Efficiency)를 집계.
*   **`GardenProvider`**: 정원의 환경(날씨, 식물 상태)을 제공.

## 4. UI/UX Detail
*   **Caring Trigger:** 돌봄이 필요한 기록(`uncaredRecords`)이 있을 때만 물방울 아이콘(💧)이 식물 근처에 부유하며 등장을 알림.
*   **Sleep Battery:** 당일 수면 효율이 90% 이상이면 초록색, 그 이하면 노란색/빨간색으로 표시하여 직관적인 컨디션 체크 지원.
