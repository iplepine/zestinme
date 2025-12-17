# 00. Product Requirement Document (PRD)

| Attribute | Value |
| :--- | :--- |
| **Project Name** | Mind-Gardener (마인드 가드너) |
| **Version** | 1.1 |
| **Date** | 2025-12-18 |
| **Core Concept** | Digital Phenotyping & Self-Caring Garden |
| **Slogan** | "The Mirror, Not a Game (놀이가 아닌 거울)" |
| **Target User** | 생산성 압박 없이 자아를 발견하고 치유받고 싶은 현대인 |

---

## 1. Product Philosophy (핵심 철학)

1.  **Awareness (자각):** 나의 감정과 상태를 시각적 환경(날씨, 식물)으로 객관화하여 바라봅니다.
2.  **Acceptance (수용):** 부정적인 감정도 식물을 키우는 양분으로 사용합니다. ('버릴 감정은 없다')
3.  **Circulation (순환):** 채움(수면), 비움(환기), 돌봄(감정)의 선순환 고리를 만듭니다.

---

## 2. Home Screen Architecture (홈 화면 구조)

홈 화면은 **'The Object Garden'** 컨셉으로, 기능별 오브젝트가 배치된 3D 깊이감의 공간입니다.

| 위치 | 오브젝트 (UI) | 연결 기능 | 시각적 피드백 (State) |
| :--- | :--- | :--- | :--- |
| **배경 (Layer 1)** | **Sky & Atmosphere** | **감정 상태** | Seeding 결과에 따라 날씨(비, 맑음, 구름, 번개)와 BGM 변화 |
| **중앙 (Layer 2)** | **🌱 Mystery Plant** | **감정 기록 & 다듬기** | 사용자의 케어에 따라 형태 진화, 잎의 처짐/생생함 표현 |
| **좌측 상단** | **🔋 Moon Lantern** | **수면 (Recharge)** | 수면 효율에 따라 랜턴 밝기 및 배터리 잔량 변화 |
| **우측 중앙** | **🍃 Wind Chime / Window** | **환기 (Ventilation)** | 환기 수행 시 정원의 안개가 걷히고 바람이 부는 연출 |
| **하단 중앙** | **🪞 Small Pond** | **자아 (Self-Mirror)** | 잔잔한 물결, 터치 시 요약 카드 부상 |
| **제스처 (Swipe Up)** | **Roots (Underground)** | **히스토리 (Archive)** | 땅속으로 카메라가 이동하며 과거 기록 열람 |

---

## 3. Key Features Specification (핵심 기능 명세)

### ① 감정 기록 (Seeding)
*   **Role:** 정원의 날씨(Environment) 설정.
*   **Action:** 사용자는 현재 감정의 종류(Valence)와 에너지(Arousal)를 선택.
*   **Logic:**
    *   입력 즉시 홈 화면의 날씨 렌더링 변경.
    *   입력된 감정은 **4시간**의 타이머(Incubation)를 가짐.

### ② 감정 다듬기 (Pruning / Caring)
*   **Role:** 식물에게 물(Water) 주기.
*   **Condition:** Seeding 후 4시간이 경과한 감정 씨앗.
*   **Action:**
    *   홈 화면 식물 주변에 맺힌 '물방울'을 터치.
    *   Dr.Mind(AI)의 회고 질문에 답변 (예: "그 감정 이면에 숨겨진 욕구는 무엇인가요?").
*   **Reward:**
    *   답변 완료 시 물방울이 식물 뿌리로 흡수.
    *   **식물 경험치 대폭 상승** (성장의 핵심 트리거).

### ③ 수면 충전 (Recharge)
*   **Role:** 정원의 빛(Light) 공급.
*   **Action:** 기상/취침 시간 입력 및 수면의 질(5단계) 평가.
*   **Logic:**
    *   수면 충족 시: 식물의 성장 속도 가속 (광합성 효과).
    *   수면 부족 시: 식물의 색채가 흐릿해짐, 랜턴 불빛 약화.

### ④ 마음 환기 (Ventilation) ✨ New
*   **Role:** 정원의 공기 순환(Wind).
*   **Concept:** "나를 위한 능동적인 시간 (Me-time)"
*   **Action:**
    *   활동 선택: 정적 환기(독서, 명상) / 동적 환기(산책, 운동).
    *   타이머 설정 (비주얼 타이머).
*   **Logic:**
    *   수행 완료 시 정원에 낀 **'안개(Stress Fog)' 제거**.
    *   식물에게 '활력(Vitality)' 버프 부여.

### ⑤ 히스토리 (Garden Archive)
*   **Role:** 정원의 역사(Roots) 확인.
*   **UI:** **'Monthly Garden'** 뷰. (한 달 동안 피워낸 식물들이 모인 화단)

### ⑥ 내 거울 보기 (Self-Mirror) ✨ New
*   **Role:** 정원의 주인(Identity) 정의.
*   **Data Analysis:** 축적된 데이터(감정, 수면, 환기) 기반 정체성 카드 생성.
*   **Output:** *"당신은 밤의 정원사입니다."* 등의 인사이트 제공.

---

## 4. Growth & Evolution System (식물 성장 로직)

사용자의 데이터가 식물의 형태(DNA)를 결정하는 **핵심 게이미피케이션** 요소입니다.

| 성장 단계 | 소요 기간 (예상) | 시각적 변화 |
| :--- | :--- | :--- |
| **Seed (씨앗)** | Day 1 | 땅에 심어진 작은 씨앗. |
| **Sprout (새싹)** | Day 2~3 | 떡잎 등장. (초기 감정 톤에 따라 색상 결정) |
| **Stem (줄기)** | Day 4~6 | 줄기 성장. (환기/수면 활동량에 따라 굵기/키 결정) |
| **Bloom (개화)** | Day 7 (Weekly) | **최종 형태 완성.** (주간 지배적 감정에 따른 꽃 종류 결정) |
| **Harvest (수확)** | Day 8 | Archive로 이동, 새로운 씨앗 심기(Reset). |

*   **진화 예시:**
    *   힘든 감정을 잘 다듬은 주간 -> **가시가 있지만 화려한 선인장 꽃.**
    *   평온하고 환기를 많이 한 주간 -> **잎이 넓고 푸른 관엽식물.**

---

## 5. Technical Roadmap (개발 로드맵)

### Phase 1: MVP (현재 단계)
*   **목표:** 핵심 4대 기능(감정, 수면, 기록, 다듬기)과 홈 화면 렌더링 구현.
*   **범위:**
    *   홈 화면: 기본 배경(Shader) 및 식물 3단계 성장 로직.
    *   기능: Seeding, Pruning, Recharge, History.
    *   데이터: 로컬 저장소(Isar) 활용.

### Phase 2: Update (Connection)
*   **목표:** 순환 구조 완성 및 앱의 풍성함 더하기.
*   **범위:**
    *   **[환기]** 기능 추가 (타이머 모듈).
    *   **[내 거울 보기]** 기능 추가 (통계 기반).
    *   푸시 알림 시스템 (Incubation 완료 알림).

### Phase 3: Expansion (Platform)
*   **목표:** 개인화 및 소셜 확장.
*   **범위:**
    *   다양한 식물/정원 테마 스킨.
    *   서버 연동 및 데이터 백업.
    *   소셜 공유 기능 (인스타그램 스토리 포맷).
