# 1.3 Emotion Refinement: Caring (돌보기) UI Spec

| Attribute | Value |
| :--- | :--- |
| **Version** | 1.2 |
| **Status** | Final Design Spec |
| **Date** | 2025-12-14 |
| **Author** | Mind-Gardener Committee |
| **Theme Ref** | `AppTheme.darkTheme` (Deep & Focused) |

## 1. Overview
*   **Goal:** 사용자가 기록된 감정에 대한 코칭 질문에 답하고, 가치를 발견하는 흐름을 시각적으로 구현.
*   **Key Metaphor:** "식물에게 물을 주듯, 내 마음을 돌본다."
*   **Theme:** **Night Garden (심야의 정원)** - 주변을 어둡게 처리하여 몰입감 조성.

---

## 2. Layout Structure (Root)

### 2.1 Scaffold
*   **BackgroundColor:** `AppTheme.darkScheme.background` (`#101418`)
*   **Status Bar:** Light Content (White icons)
*   **ResizeToAvoidBottomInset:** `true` (키보드 올라올 때 대응)

### 2.2 Background Layer
*   **Effect:** 감정의 잔향 (Emotional Resonance)
*   **Implementation:** 화면 중앙에 기록된 감정 컬러(`EmotionColor`)의 Radial Gradient를 아주 은은하게 배치.
    *   **Opactiy:** 0.15
    *   **Radius:** Screen Width * 0.8
    *   **Blur:** `MaskFilter.blur(BlurStyle.normal, 100)`

---

## 3. UI Flow & Component Specs

### 3.1 Header (Navigation)
*   **Type:** `AppBar` (Transparent)
*   **Leading:** `CloseIcon` (`Icons.close`, Color: `white`)
    *   **Action:** `context.pop()`
*   **Title:** (Empty) - 식물과 질문에 집중.

### 3.2 Hero Content (The Plant)
*   **Position:** Top Center (화면 높이의 15% 지점)
*   **Widget:** `SeedWidget` or `PlantWidget` (Hero Animation)
*   **Size:** 120x120 dp
*   **Animation:** 'Breathing' (Scale 1.0 -> 1.05 -> 1.0, Duration: 4s loop)

### 3.3 Intro Text (Fade In)
*   **Position:** Below Plant (Margin Top: 24dp)
*   **Text:** *"아까 '{EmotionLabel}' 기분을 느꼈었죠.\n지금 마음은 어떤가요?"*
*   **Style:** `textTheme.headlineSmall` (Color: `white`, Align: Center)
*   **Animation:** Fade In (Delay: 0ms, Duration: 600ms)

### 3.4 Card: The Coaching Question (Flip Interaction)
*   **Layout:**
    *   **Width:** Screen Width - 48dp (Horizontal Margin 24dp)
    *   **Height:** Min 200dp (Dynamic based on content)
    *   **Decoration:**
        *   Color: `AppTheme.darkScheme.surface` (`#14181C`)
        *   BorderRadius: `24.0`
        *   Border: `1dp solid` `AppTheme.darkScheme.outline.withOpacity(0.3)`
        *   Shadow: `BoxShadow(color: black26, blur: 20, offset: 0, 10)`

#### State A: Question (Front)
*   **Icon:** `Dr. Mind` Avatar or `Icon(Icons.psychology)` (Color: `primary`)
*   **Question Text:**
    *   **Font:** `textTheme.titleLarge` (Size: 18, Weight: w600)
    *   **Color:** `white`
    *   **LineHeight:** 1.5
*   **Instruction:** *"탭하여 답변 남기기"* (Color: `grey`, Size: 12)
*   **Interaction:** Tap -> **Flip Animation** (Duration: 600ms, Curve: `Curves.easeInOutBack`)

#### State B: Answer Input (Back)
*   **TextField:**
    *   **MaxLines:** 5
    *   **Style:** `bodyLarge` (Color: `white`)
    *   **CursorColor:** `primary`
    *   **Decoration:** `InputDecoration.collapsed` (Hint: *"솔직하게 적어보세요..."*)
*   **Action Button:** '가치 발견하기' (Bottom Right)
    *   **Type:** `TextButton.icon`
    *   **Icon:** `Icons.auto_awesome`
    *   **Text:** "Next"

### 3.5 Value Discovery Sheet (Slide Up)
*   **Trigger:** 답변 입력 완료 시 하단에서 올라옴 (`showModalBottomSheet` or Custom Slide)
*   **Height:** 300dp
*   **Background:** `AppTheme.darkScheme.surfaceVariant`
*   **Content:**
    1.  **Title:** *"이 감정 뒤에 숨겨진 가치는 무엇일까요?"* (`titleMedium`)
    2.  **Tag Cloud (Wrap):**
        *   추천 태그 5~6개 노출.
        *   **Chip Style:**
            *   **Base:** `OutlinedButton` stlye (Rounded)
            *   **Selected:** `AppTheme.darkScheme.primaryContainer` (Gold Glow)
            *   **Text:** `labelLarge`
    3.  **Confirm Button:** "물 주기 (완료)"
        *   **Style:** `ElevatedButton` (Full Width)
        *   **Color:** `primary` (`#FFDB26`) -> Black Text

---

## 4. Animation Choreography

1.  **Entry (0ms ~ 800ms):**
    *   배경 Gradient Fade In.
    *   식물(Hero) Scale Up.
    *   Intro Text Slide Up + Fade In.
2.  **Card Appearance (800ms ~ 1200ms):**
    *   질문 카드가 아래에서 위로 `SlideY(0.1 -> 0.0)` + `FadeIn`.
3.  **Flip (Interaction):**
    *   `Transform(matrix: Matrix4.identity()..rotateY(pi))` 활용.
4.  **Growth (Completion):**
    *   가치 선택 후 "물 주기" 클릭 시.
    *   **Water Drop Particles:** 식물 위로 물방울 파티클 떨어짐.
    *   **Plant Evolve:** 식물 이미지가 다음 단계(Seed -> Sprout)로 CrossFade 교체.

---

## 5. Asset Requirements
*   **Icons:** `Icons.water_drop`, `Icons.psychology`, `Icons.spa`.
*   **Sound (Optional):**
    *   Flip Sound (Paper turn)
    *   Watering Sound (Liquid pour)
