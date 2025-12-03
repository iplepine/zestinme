# LLM Prompt for Feature Implementation: Emotion Write Flow

## Role
너는 Android/iOS 모바일 앱 개발 전문가이자, UX 심리학에 능통한 시니어 개발자야.

## Context
우리는 사용자의 감정과 행동 패턴을 분석하는 'InsightMe' 앱을 만들고 있어.
지금 구현해야 할 기능은 **[Emotion Write Flow]**야.
이 기능은 단순한 폼 입력이 아니라, 사용자가 입력하면서 스스로 힐링이 되는 'Interactive Flow'여야 해.

## Requirements based on Spec
참조 파일: `/spec/10-domain/emotion.md`, `/spec/15-data-model/emotion-record.md`, `/spec/20-feature/emotion-write/10-flow-emotion-log.md`

1.  **UI Interaction:**
    * Russell's Circumplex Model을 구현한 XY 좌표 평면 UI를 만들어줘.
    * X축(쾌/불쾌), Y축(각성/이완)을 드래그하여 감정을 선택하게 해줘.
    * 선택된 영역에 따라 동적으로 감정 단어 칩(Chip)들이 변경되어야 해.

2.  **Data Logic:**
    * `EmotionRecord` 데이터 모델에 맞춰서 입력을 받아야 해.
    * `timestamp`는 기본적으로 현재 시간이지만, 수정 가능해야 해.

3.  **Step-by-Step UX:**
    * 한 화면에 모든 폼을 보여주지 말고, `Wizard` 형식이나 `BottomSheet`가 단계별로 확장되는 형태로 구현해줘 (Progressive Disclosure).
    * 사용자가 피로를 느끼지 않도록 애니메이션은 부드럽고 빨라야 해.

4.  **Special Logic (Coaching):**
    * 사용자가 '부정적 감정' + '강도 높음'을 선택하면, 입력 완료 후 즉시 "심호흡 가이드" 또는 "잠시 멈춤" 팝업을 띄울지 묻는 로직을 포함해줘.

## Code Style
* 언어: Kotlin (Android) or Swift (iOS) - *사용자가 지정하는 플랫폼에 맞게 수정*
* 아키텍처: MVVM + Clean Architecture
* 상태 관리: StateFlow (Android) / Combine or Observable (iOS)

## Output
* 위 요구사항을 구현하기 위한 View(UI), ViewModel, DataModel 코드를 작성해줘.