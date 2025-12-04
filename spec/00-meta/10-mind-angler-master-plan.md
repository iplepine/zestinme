# 프로젝트 코드명: 마인드 앵글러 (Mind-Angler)
**바이브 코딩(Vibe Coding) 기반의 게임화된 디지털 표현형(Digital Phenotyping) 및 자가 코칭 플랫폼 상세 기획서**

*   **작성 주체:** 통합 전문가 위원회
*   **문서 버전:** 1.1.0 (Refactored)
*   **상태:** 상세 스펙 분할 완료

---

## 📚 문서 인덱스 (Document Index)

본 기획서는 가독성과 유지보수성을 위해 모듈별로 분할되었습니다. 각 섹션의 상세 내용은 아래 링크된 문서를 참조하십시오.

### 1. Project Philosophy & Rules (00-meta)
*   **[11-expert-personas.md](./11-expert-personas.md):** 4대 전문가 페르소나 (Dr. Neuro, Dr. Mind, Planner Flow, Architect Spec) 및 역할 정의.
*   **[12-vibe-coding-guidelines.md](./12-vibe-coding-guidelines.md):** 바이브 코딩 철학, SDD 개발 방법론, Tone & Manner.

### 2. Core Mechanics & Domain Logic (10-domain)
*   **[20-core-mechanics.md](../10-domain/20-core-mechanics.md):** 도파민 보상 회로, 가변 비율 강화, 낚시 메타포(Core Loop).
*   **[21-psychology-models.md](../10-domain/21-psychology-models.md):** 융기안 물고기 분류학, CBT/ACT 치료적 접근법.
*   **[22-digital-phenotyping.md](../10-domain/22-digital-phenotyping.md):** 데이터 수집(Passive/Active), SAM 척도, NLP 분석 파이프라인.

### 3. Data Models (15-data-model)
*   **[30-json-schemas.md](../15-data-model/30-json-schemas.md):** Quest, Diary Entry 등 핵심 데이터 JSON 스키마.

### 4. Feature Specifications (20-feature)
*   **[41-module-sleep.md](../20-feature/41-module-sleep.md):** 수면 모듈 (밤의 파수꾼) - 7일 수면 프로토콜.
*   **[42-module-anger.md](../20-feature/42-module-anger.md):** 분노 모듈 (화산 지대) - 용암 식히기 퀘스트.
*   **[43-module-happiness.md](../20-feature/43-module-happiness.md):** 행복/가치관 모듈 (나침반과 보물) - 가치관 카드 분류, 음미하기.

---

## 5. 결론: 전문가 위원회 종합 의견
본 프로젝트는 방대한 다학제적 지식을 포함하고 있으므로, 개발 시 각 도메인 문서를 수시로 참조하여 **'의도된 바이브(Intended Vibe)'**가 코드에 반영되도록 해야 합니다.

> **Architect Spec:** "문서의 모듈화는 시스템의 모듈화로 이어집니다. 각 문서는 하나의 독립된 마이크로서비스 명세와 같습니다."
