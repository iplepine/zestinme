# 📱 Mind-Gardener: Home Screen Specification

| 항목 | 내용 |
| :--- | :--- |
| **Project** | Mind-Gardener (마인드 가드너) |
| **Screen Name** | Home (Main View) |
| **Screen ID** | `SCR_HOME_01` |
| **Version** | 1.0 |
| **Date** | 2025-12-18 |
| **Concept** | **"The Living Mirror"** (데이터에 따라 실시간으로 변하는 3D 공간) |

---

## 1. Layout Structure (화면 구성)

전체 화면은 깊이감이 있는 **3단 레이어(Layer)** 구조로 설계합니다.

### 1.1 Z-Index Layers
* **Layer 0 (Background): [Sky & Atmosphere]**
    * 하늘, 날씨, 조명, 환경음(BGM).
    * 사용자의 감정 상태(Valence/Arousal)를 반영하는 Shader 배경.
* **Layer 1 (Mid-Ground): [Main Objects]**
    * **🌱 Mystery Plant (Center):** 식물 본체.
    * **Ground:** 식물이 심어진 땅.
* **Layer 2 (Foreground): [Interaction Props]**
    * **🔋 Moon Lantern (Top Left):** 수면 상태 표시.
    * **🍃 Wind Chime (Mid Right):** 환기 기능 진입.
    * **🪞 Small Pond (Bottom Center):** 자아 정체성 확인.
* **Layer 3 (Overlay): [System UI]**
    * Toast Message, Modal, Bottom Sheet.

---

## 2. Object Specifications (오브젝트 명세)

각 UI 요소는 버튼이 아닌 정원 속 '사물'처럼 배치되며, 상태에 따라 시각적으로 변화합니다.

### A. 🌱 The Mystery Plant (중앙 오브젝트)
* **위치:** 화면 정중앙 하단 (Ground 위).
* **기능:** 감정 기록(Seeding) 및 감정 다듬기(Pruning).
* **States (상태 변화):**
    | 상태 | 조건 | 시각적 표현 (Visual) | 인터랙션 (Tap) |
    | :--- | :--- | :--- | :--- |
    | **Idle (기본)** | 기록 대기 중 | 미세하게 호흡하듯 Scale 애니메이션 (Zoom In/Out loop). | **[감정 기록 시트]** 호출 |
    | **Thirsty (숙성)** | 기록 후 4시간 경과 | 식물 주변에 빛나는 **물방울(💧)** 오브젝트 생성. | **[감정 다듬기 대화창]** 호출 |
    | **Growing (성장)** | 다듬기/수면 완료 | 파티클 효과와 함께 식물 크기/형태 변화 (Level Up). | (터치 불가 - 애니메이션 재생) |
    | **Withered (시듦)** | 3일 이상 미접속 | 잎이 처지고 채도가 낮아짐. | **[복귀 환영 메시지]** 출력 |

### B. 🔋 Moon Lantern (좌측 상단)
* **위치:** 화면 좌측 상단 (나무에 걸려 있거나 공중에 부유).
* **기능:** 수면 기록 및 배터리 상태 확인 (Recharge).
* **States:**
    | 수면 상태 | 시각적 표현 (Visual) |
    | :--- | :--- |
    | **충전 완료 (Good)** | 밝고 따뜻한 노란빛. 유리관 안이 가득 차 있음. |
    | **부족/보통 (Normal)** | 은은한 불빛. |
    | **방전/나쁨 (Bad)** | 불빛이 깜빡거림(Flickering). 유리관이 비어 있음. |
* **Interaction:** 터치 시 **[수면 기록/수정 시트]** 호출.

### C. 🍃 Wind Chime (우측 중단)
* **위치:** 화면 우측 가장자리 (허공에 매달린 풍경 또는 작은 창문 틀).
* **기능:** 마음 환기 (Ventilation).
* **States:**
    | 환기 상태 | 시각적 표현 (Visual) |
    | :--- | :--- |
    | **기본 (Idle)** | 바람이 없어 멈춰 있음. 주변에 옅은 안개(Fog). |
    | **환기 중 (Active)** | 풍경이 흔들리며 맑은 소리 냄. 안개가 걷힘. |
* **Interaction:** 터치 시 **[환기 타이머 시트]** 호출.

### D. 🪞 Small Pond (하단 중앙)
* **위치:** 식물 뿌리 근처 바닥.
* **기능:** 자아 정체성 확인 (Self-Mirror).
* **Visual:** 물 표면에 식물과 하늘이 반사됨.
* **Interaction:** 터치 시 **[Identity Card (요약 정보)]** 팝업.

---

## 3. Environment Rendering Logic (날씨 로직)

홈 화면의 배경(Layer 0)은 사용자의 **최근 감정 데이터**에 따라 실시간으로 렌더링 됩니다.

### 3.1 Weather Map (Valence x Arousal)
* **Trigger:** 감정 기록(Seeding) 완료 즉시 변경.

| 감정 (Valence) | 에너지 (Arousal) | 날씨 (Weather) | 색감 (Color Tone) |
| :--- | :--- | :--- | :--- |
| **긍정 (Positive)** | 높음 (High) | **☀️ 맑은 낮/화창함** | Warm Orange / Yellow |
| **긍정 (Positive)** | 낮음 (Low) | **🌙 맑은 밤/별똥별** | Deep Blue / Purple |
| **부정 (Negative)** | 높음 (High) | **⚡️ 폭풍우/번개** | Dark Red / Grey |
| **부정 (Negative)** | 낮음 (Low) | **☔️ 부슬비/흐림** | Muted Grey / Blue-Grey |

### 3.2 Soundscape (BGM)
* 날씨 상태값에 매핑된 백색 소음(ASMR) 자동 재생.
    * *비:* 빗소리, 천둥소리.
    * *밤:* 귀뚜라미, 바람 소리.
    * *낮:* 새소리, 나뭇잎 흔들리는 소리.
* **옵션:** 설정에서 On/Off 및 볼륨 조절 가능.

---

## 4. Gestures & Transitions (제스처 및 전환)

버튼 터치 외의 제스처를 통해 공간 이동의 경험을 제공합니다.

* **Swipe Up (↑): [Go to Underground]**
    * 카메라가 땅속으로 내려가며 **[히스토리/뿌리 뷰]**로 전환.
* **Swipe Down (↓): [Refresh / Interaction]**
    * (히스토리 뷰에서) 다시 땅 위(홈)로 복귀.
* **Long Press (Background): [Focus Mode]**
    * UI 요소(랜턴, 연못 등)가 Fade Out 되고 오직 식물과 배경만 감상하는 모드.

---

## 5. Haptic Feedback (햅틱 가이드)

사용자의 행동에 따른 물리적 피드백을 제공합니다.

| 상황 | 햅틱 종류 | 느낌 |
| :--- | :--- | :--- |
| **감정 기록 완료** | `Heavy Impact` | 쿵- 하는 묵직한 무게감. |
| **물방울 터치** | `Light Pop` | 톡! 터지는 가볍고 경쾌한 느낌. |
| **식물 성장/진화** | `Success Pattern` | 두구두구- 징! 하는 점층적 상승감. |
| **환기 타이머 종료** | `Soft Notification` | 부드럽게 울리는 알림. |

---

## 6. Edge Cases (예외 처리)

* **Case 1: 최초 진입 시 (Onboarding)**
    * 식물 없음. 텅 빈 땅과 씨앗 구멍(Hole)만 존재.
    * **Action:** 중앙을 터치하여 첫 감정을 심도록 유도 (Hand Pointer Animation).
* **Case 2: 3일 이상 미접속 시 (Withering)**
    * 날씨와 상관없이 화면 전체 채도(Saturation) 감소.
    * 식물 잎이 축 처짐.
    * **Action:** 접속 시 "식물이 당신을 기다렸어요" 토스트 메시지 출력.
* **Case 3: 위험 감정 감지 시 (SOS)**
    * '죽고 싶음', '자해' 등 극단적 부정 감정 기록 시.
    * **Action:** 배경 렌더링 전, **[위로/도움 팝업]** 우선 노출 ("잠시, 괜찮으신가요? 전문가의 도움이 필요하면...").