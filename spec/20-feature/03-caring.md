# 1.3 Emotion Refinement: Caring (돌보기/숙성)

| Attribute | Value |
| :--- | :--- |
| **Version** | 1.1 |
| **Status** | Implementation Phase |
| **Date** | 2025-12-16 |
| **Author** | Mind-Gardener Committee |
| **Related** | `spec/10-domain/20-core-mechanics.md`, `spec/50-ui/03-caring-flow.md` |

## 1. 개요 (Overview)

> **"식물을 통해 나의 마음을 객관화한다."**

**Caring(돌보기)**은 `Seeding(기록)` 후 일정 시간이 지나 '숙성된' 감정을 다시 마주하고, 객관적인 질문(Coaching)을 통해 **핵심 가치(Core Value)**를 발견하는 과정입니다.

## 2. 핵심 메커니즘 (Key Mechanics)

### 2.1 The Mirror Effect (거울 효과)
*   **Contextual Reflection**: 코칭 질문은 항상 사용자가 처음에 기록한 내용(`detailedNote`)을 포함합니다.
    *   *Ex:* "아까 **'정말 화가 나'**라고 적으셨군요. 지금 다시 보니 어떤가요?"
*   시스템은 조언자가 아니라, 사용자의 마음을 비추는 **'거울'** 역할입니다.

### 2.2 Dynamic Coaching Depth (가변 깊이)
코칭은 사용자의 상황과 에너지 레벨에 따라 **1단계에서 3단계**까지 유동적으로 진행됩니다.

1.  **Stage 1: Mirroring & Grounding (거울 비추기)**
    *   **Goal:** 감정의 재확인 및 신체 감각 인식.
    *   **Logic:** 모든 세션의 시작점.
2.  **Stage 2: Expansion & Differentiation (확장)**
    *   **Goal:** 감정의 이면 탐색 (두려움, 욕구 분리).
    *   **Logic:** Default Depth.
3.  **Stage 3: Core Value Discovery (핵심 가치)**
    *   **Goal:** 감정 너머의 본질적인 가치 발견.
    *   **Logic:** 에너지 레벨이 적절하고 운(Random)이 좋을 때 진입.

#### Depth Algorithm Constraints
*   **Time (Nightly Wrap-up):** 22:00 ~ 04:00 사이에는 **Stage 1**만 진행 (수면 방해 최소화).
*   **Arousal (High Energy):** 각성도(Arousal) > 7 인 경우 **Stage 1**만 진행 (흥분 상태에서는 깊은 사고 불가, Grounding 우선).

## 3. 데이터 구조 (Data Structure)

*   **Incubation Time:** 기본 4시간 (Dev Mode: 즉시).
*   **Status Flow:** `incubating` -> `readyForAnalysis` (Caring Trigger) -> `analyzed` (Complete).
*   **Fields:**
    *   `coachingQuestionId`: 제공된 질문 식별자.
    *   `coachingAnswer`: 사용자의 답변.
    *   `valueTags`: 발견된 가치 (List<String>).

## 4. User Flow
1.  **Trigger:** 홈 화면에서 물방울 아이콘(💧) 탭.
2.  **Intro:** "감정이 찾아왔네요." (감정 레이블 표시).
3.  **Coaching Cards:** Stage 1 -> (2) -> (3) 순차 진행. 각 단계마다 답변 작성.
4.  **Value Selection:** 답변을 바탕으로 태그(가치) 선택.
5.  **Closing:** "물 주기" 완료 애니메이션 및 보상.
