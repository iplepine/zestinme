# Domain Rule: Coaching Logic

## 1. 개요
사용자의 기록에 대해 즉각적인 피드백이나 질문을 던지는 로직을 정의한다. 룰 기반(Rule-based)과 AI 기반(Gen-AI)을 혼용한다.

## 2. 질문 알고리즘 (Questioning Algorithms)

### A. Socratic Questioning (소크라테스식 문답법)
* **Trigger:** 사용자가 `Cognitive Distortion`(인지 왜곡)이 의심되는 기록을 남길 때.
    * 예: "나는 항상 실패해" (과잉 일반화)
* **Logic:** `Always`, `Never`, `Everyone` 같은 절대적 단어가 포함되면 작동.
* **Response:** "살면서 실패하지 않았던 작은 순간이 단 한 번도 없었나요?" (반증 탐색 유도)

### B. Value-Action Gap Analysis (가치-행동 괴리 분석)
* **Trigger:** 사용자가 설정한 `Core Value`와 반대되는 행동을 기록했을 때.
    * 예: 가치=`건강`, 행동=`야식 폭식`
* **Response:** 비난하지 않고 의도를 묻는다. "그 행동이 그 순간 당신에게 어떤 긍정적 의도(예: 위로, 휴식)를 주었나요?"

## 3. 피드백 강도 조절 (Throttling)
* **Brain Science Rule:** 조언이 너무 잦으면 뇌는 이를 '잔소리(Noise)'로 인식하여 차단한다.
* **Limit:**
    * Deep Coaching 질문은 하루 최대 3회로 제한한다.
    * 감정 강도가 9 이상인 'Crisis' 상태에서는 질문을 멈추고 '진정(Grounding)' 기법만 제공한다.