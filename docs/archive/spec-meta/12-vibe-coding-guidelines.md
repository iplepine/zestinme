# Vibe Coding Guidelines

## 1. Philosophy: Vibe Coding
*   **Definition:** 기술적 완성도뿐만 아니라, 앱이 제공하는 '분위기(Vibe)' 자체가 치료적 개입의 일부가 되도록 설계하는 철학.
*   **Core Value:** 정서적 공명(Emotional Resonance)과 몰입감(Flow).
*   **Approach:** 기능 구현 이전에 사용자가 느낄 감정과 분위기를 먼저 정의하고 코드로 구현한다.

## 2. Development Methodology: Spec-Driven Development (SDD)
1.  **Spec First:** 코드를 작성하기 전에 반드시 기획서(`spec.md`)를 먼저 작성하거나 업데이트한다. 문서 없는 코드는 존재하지 않는다.
2.  **Step-by-Step:** Plan -> Task -> Code 순서로 진행하며, 한 번에 모든 것을 구현하지 않는다.
3.  **Context Aware:** 모호한 지시가 있을 경우, 4대 전문가 페르소나의 관점에서 역질문하여 의도를 명확히 한다.
4.  **Code Commit:** 코드 수정 후에 빌드가 정상적으로 동작하면 한글로 커밋메시지를 작성해서 커밋한다.

## 4. Visual Identity: "Atmospheric Realism"
현실적인 물리 법칙 위에 '공기감'과 '깊이감'을 더한 스타일로, 사용자가 디지털 공간에서도 정서적인 안정감을 느낄 수 있도록 설계합니다.

### Core Principles
1. **Depth & Layers:** 평면적인 UI를 지양하고, 재질(Material)의 겹침과 거리감을 표현합니다. (Glassmorphism, Z-index 활용)
2. **Ambient Lighting:** 정적인 색상 대신, 광원(Glow)과 그림자를 통해 공간의 부드러움을 표현합니다.
3. **Natural Transitions:** 화면 전환과 상호작용은 식물이 자라거나 바람이 부는 듯한 유기적인 움직임을 따릅니다.
4. **Contextual Atmosphere:** 현재 마음 상태에 따라 공간의 조도, 색온도, 공기의 질감이 실시간으로 변화합니다 (Midnight Mist 컨셉 기반).
