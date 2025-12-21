# 00-Meta: Project Identity & Philosophy

## 1. Project Overview
- **Product Name:** Mind-Gardener (마인드 가드너)
- **Motto:** "식물은 당신의 마음을 비추는 거울입니다 (Your plant is a mirror of your mind)."
- **Core Philosophy:** **"The Mirror, Not a Game"**
    - 사용자가 식물을 키우는 것이 목적이 아니라, **기록을 통해 자신의 마음을 객관화(Objectification)**하는 것이 본질입니다.
    - 식물의 변화는 보상이 아니라 **피드백(Feedback)**이어야 합니다. ("내가 우울해서 식물이 시들었네" X -> "내 마음이 지금 휴식이 필요하구나" O)
    - **Psychological Safety:** 사용자가 솔직하게 기록할 수 있는 안식처 같은 환경을 제공합니다.

## 2. Visual Identity: "Atmospheric Realism"
현실적인 물리 법칙 위에 '공기감'과 '깊이감'을 더한 스타일로, 사용자가 디지털 공간에서도 정서적인 안정감을 느낄 수 있도록 설계합니다.

### 2.1. Core Principles
1. **Depth & Layers:** 평면적인 UI를 지양하고, 재질(Material)의 겹침과 거리감을 표현합니다. (Glassmorphism, Z-index 활용)
2. **Ambient Lighting:** 정적인 색상 대신, 광원(Glow)과 그림자를 통해 공간의 부드러움을 표현합니다.
3. **Natural Transitions:** 화면 전환과 상호작용은 식물이 자라거나 바람이 부는 듯한 유기적인 움직임을 따릅니다.
4. **Contextual Atmosphere:** 현재 마음에 상태에 따라 공간의 조도, 색온도, 공기의 질감이 변화합니다.

## 3. Tech Stack
- **Framework:** Flutter (Dart)
- **Local DB:** Isar (Local-First Architecture)
- **State Management:** Riverpod
- **Architecture:** Clean Architecture + MVVM + Feature-first
