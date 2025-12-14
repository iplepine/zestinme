# Feature 03: Caring (돌보기)

| Attribute | Value |
| :--- | :--- |
| **Version** | 1.0 |
| **Status** | Final Draft |
| **Date** | 2025-12-14 |
| **Author** | Mind-Gardener Committee |
| **Related UI** | `spec/50-ui/03-caring-flow.md` |
| **Domain Logic** | `spec/10-domain/23-emotion-value-framework.md` |

## 1. 개요 (Overview)
**Caring(돌보기)**은 `Seeding` 단계에서 심어진 감정 씨앗을, 일정 시간(Incubation Time)이 지난 후 '코칭 질문'을 통해 성찰하고 '핵심 가치'를 발견하여 식물을 성장시키는 프로세스입니다.

> **Core Loop:** Emotion Log -> Incubation (Waiting) -> Coaching Question -> Value Discovery -> Plant Growth

## 2. 데이터 모델 및 상태 (Data Model & State)

### 2.1 EmotionRecord (Update)
기존 `EmotionRecord` 엔티티에 다음 필드들이 **업데이트(Update)** 됩니다.

| Field | Type | Description |
| :--- | :--- | :--- |
| `coachingQuestionId` | `String?` | 사용자에게 제시된 질문 ID (재현 가능성 확보). |
| `coachingAnswer` | `String?` | 사용자의 서술형 답변. |
| `valueTags` | `List<String>` | 발견된 핵심 가치 태그 리스트 (예: `['#존중', '#공정성']`). |
| `caredAt` | `DateTime?` | 돌보기(Caring) 완료 시각. |
| `status` | `enum` | `Status.seeded` -> **`Status.cared`** (상태 변경). |

### 2.2 Caring Status (Life Cycle)
1.  **Pending (Seeded):** 씨앗이 심어졌으나 아직 돌보지 않음.
    *   *Condition:* `caredAt == null`.
2.  **Ready (Incubated):** 심어진 지 **4시간** 경과.
    *   *Trigger:* `DateTime.now() >= record.createdAt + Duration(hours: 4)`.
    *   *UI Effect:* 물방울 아이콘(💧) 표시.
3.  **Completed (Cared):** 돌보기 완료.
    *   *Condition:* `caredAt != null`.
    *   *Effect:* 식물 성장 (Seed -> Sprout) 및 XP 지급.

## 3. 비즈니스 로직 (Business Logic)

### 3.1 Trigger Condition (알림 조건)
*   **Default Rule:** 감정 기록 후 **4시간** 뒤.
*   **Exceptions:**
    *   *수면 시간 (Sleep Mode):* 사용자의 수면 설정 시간(예: 23:00 ~ 07:00)에는 알림을 보내지 않고, 기상 후(08:00)에 모아서 알림.
    *   *Too Many:* 미완료 Caring이 3개 이상 쌓이면, "정원에 목마른 식물들이 기다려요"라며 묶음 알림(Batch Notification) 발송.

### 3.2 Question Selection (Coaching Algorithm)
*   입력된 `Emotion Tag`를 Key로 하여 `CoachingQuestions` 테이블(Constant)에서 질문을 추출합니다.
*   **Rotation Logic:** 동일한 감정 태그에 대해 여러 질문이 있다면, 최근에 사용하지 않은 질문을 우선 선택(Linear Round-Robin or Random Shuffle)하여 지루함을 방지합니다.

### 3.3 Value Recommendation
*   (V1 MVP) 정적 맵핑: `spec/10-domain/23-emotion-value-framework.md`에 정의된 감정별 추천 가치 리스트를 UI에 제공합니다.
*   (V2 AI) 사용자가 작성한 `coachingAnswer`를 분석하여 연관성 높은 가치를 상위에 노출합니다.

### 3.4 Growth & Reward
*   **Action:** Caring 완료 시.
*   **Reward:**
    *   **Plant Stage:** `Seed` -> `Sprout` (즉시 성장).
    *   **Garden XP:** +20 XP (단순 기록보다 더 높은 보상).
    *   **Inventory:** (Optional) '물조리개' 아이템 소모 (Gamification 요소 도입 시).

## 4. 예외 처리 (Exception Handling)
*   **Skipped:** 사용자가 답변을 거부하거나 건너뛰기 한 경우.
    *   `status`는 `cared`로 변경하되 `valueTags`는 빈 값으로 저장.
    *   보상은 절반(+10 XP)만 지급. 식물은 성장하지만 '빛바랜 색' 등으로 표현 가능 (Optional).
*   **Offline:** 오프라인 상태에서도 Caring 수행 가능 (Local DB 저장), 온라인 전환 시 백업 동기화.

## 5. Testing Requirements
*   **Time Travel:** 디버그 모드에서 강제로 '4시간 경과' 상태를 만드는 치트 기능 필요.
*   **Status Check:** DB에서 `status` 필드가 `seeded`에서 `cared`로 정상 업데이트 되는지 확인.
