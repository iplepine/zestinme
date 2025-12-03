# Design System Specification

## 1. Design Philosophy
*   **Theme:** "Lemon & Lime" - 상쾌함(Lemon)과 안정감(Lime)의 조화.
*   **Core Value:** 사용자가 기록하는 과정에서 힐링을 느끼도록 따뜻하고 부드러운 UI 제공.
*   **Mode:** Light Mode를 기본으로 하며, 눈의 피로를 줄이는 Dark Mode를 완벽 지원.

## 2. Color System

### 2.1. Palette (Lemon Theme)

| Role | Light Color | Dark Color | Description |
| :--- | :--- | :--- | :--- |
| **Primary** | `#FFE135` (Lemon) | `#FFE135` | 주요 액션, 하이라이트, CTA |
| **On Primary** | `#2A2A00` | `#2A2A00` | Primary 위 텍스트 |
| **Secondary** | `#FFF8C4` (Pale Lemon) | `#4A4A00` | 보조 요소, 카드 배경 |
| **On Secondary** | `#2A2A00` | `#FFE135` | Secondary 위 텍스트 |
| **Accent** | `#FFF59D` | `#3A3A00` | 강조, 성공 상태 |
| **Muted** | `#FFFAEB` | `#444444` | 배경, 비활성, 부드러운 요소 |
| **Background** | `#FFFFFF` | `#252525` | 전체 화면 배경 |
| **Surface** | `#FFFFFF` | `#14181C` | 카드, 시트 등 표면 |
| **Error/Destructive** | `#D4183D` | `#E53E3E` | 에러, 삭제 등 파괴적 액션 |

### 2.2. Gradients
*   **Primary Gradient:** `LinearGradient(colors: [primary, accent])` (TopLeft -> BottomRight)
*   **Chart Gradient:** `LinearGradient(colors: [chart1...chart5])` (TopLeft -> BottomRight)
    *   Chart Colors: `#FFE135` -> `#FFF176` -> `#FFCC02` -> `#F9A825` -> `#FF8F00`

### 2.3. Usage Guidelines
*   **Primary Ratio:** 전체의 20% 이하로 유지하여 눈부심 방지.
*   **Text Contrast:** Primary 배경 위에는 반드시 `#2A2A00` (Dark Ink) 텍스트 사용 (대비 4.5:1 준수).

## 3. Typography

### 3.1. Scale
| Style | Size | Weight | Usage |
| :--- | :--- | :--- | :--- |
| **Display Large** | 32sp | Bold | 메인 타이틀, 강조 문구 |
| **Display Medium** | 28sp | Bold | 섹션 타이틀 |
| **Display Small** | 24sp | SemiBold | 카드 타이틀 |
| **Headline Large** | 22sp | SemiBold | |
| **Headline Medium** | 20sp | SemiBold | |
| **Headline Small** | 18sp | SemiBold | |
| **Title Large** | 16sp | SemiBold | 앱바 타이틀, 중요 버튼 |
| **Title Medium** | 14sp | Medium | 서브 타이틀, 일반 버튼 |
| **Title Small** | 12sp | Medium | 캡션, 보조 텍스트 |
| **Body Large** | 16sp | Regular | 본문 (강조) |
| **Body Medium** | 14sp | Regular | 본문 (기본) |
| **Body Small** | 12sp | Regular | 본문 (작게) |

### 3.2. Font Family
*   기본 시스템 폰트 사용 (Android: Roboto, iOS: San Francisco)
*   필요 시 Google Fonts의 `Inter` 또는 `Pretendard` 도입 고려.

## 4. Components & Styles

### 4.1. Shapes & Radius
*   **Base Radius:** `10.0` (CSS `--radius`)
*   **Small:** `6.0` (Chips, Checkbox)
*   **Medium:** `8.0` (Inputs, TextButtons)
*   **Large:** `10.0` (Cards)
*   **Extra Large:** `14.0` (Dialogs, BottomSheets)
*   **Full:** `20.0` (Chips, Pills)

### 4.2. Buttons
*   **Elevated Button:**
    *   Bg: `Primary`
    *   Fg: `OnPrimary`
    *   Radius: `12`
    *   Elevation: `2`
*   **Outlined Button:**
    *   Border: `Outline`
    *   Fg: `OnSurface`
    *   Radius: `12`

### 4.3. Inputs (TextField)
*   **Style:** Filled (Box)
*   **Fill Color:** `Surface`
*   **Border:** `Outline` (1px) -> Focused: `Primary` (2px)
*   **Radius:** `8`

### 4.4. Cards
*   **Bg:** `Surface`
*   **Elevation:** `2`
*   **Radius:** `16`
*   **Margin:** H:16, V:8

### 4.5. Chips
*   **Bg:** `SecondaryContainer`
*   **Selected Bg:** `PrimaryContainer`
*   **Radius:** `20` (Pill shape)

## 5. Layout & Spacing
*   **Touch Target:** 최소 48x48dp 보장.
*   **Button Gap:** 최소 8dp.
*   **Screen Margin:** 기본 16dp 또는 20dp.
