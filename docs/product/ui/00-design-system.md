# 50-UI: Design System & UI Specs

## 1. Accessibility (A11y)
### 1.1. Text Scaling
- **Philosophy**: 앱의 가독성을 해치지 않는 선에서 사용자의 글자 크기 설정을 존중한다.
- **Rule**: `MediaQuery.textScaler`를 사용하여 시스템 폰트 스케일을 **1.0배 ~ 1.4배** 사이로 제한(Clamp)한다.
    - `Clamp(1.0, 1.4)`
    - **Min 1.0**: 시스템 설정이 너무 작아도 기본 크기(1.0)를 유지하여 가독성 저하 방지.
    - **Max 1.4**: 시스템 설정이 너무 커도 1.4배까지만 확대하여 레이아웃 깨짐(Overflow) 방지.
- **Implementation**: `lib/app/app.dart`의 `MaterialApp.builder`에서 전역 적용.

### 1.2. Responsive Layout
- **Widgets**: 텍스트가 포함된 모든 컨테이너(Button, Card, TextField 등)는 고정 높이(`height`) 대신 `constraints`(`minHeight`)를 사용해야 한다.
- **Scroll**: 텍스트 확대로 인해 콘텐츠가 화면을 넘어갈 수 있으므로, 항상 `SingleChildScrollView` 등으로 스크롤 가능성을 열어둔다.

### 1.3. Screen Reader (Semantics)
- **Interactive Labels**: 모든 버튼(`IconButton`, `FilledButton` 등)과 탭 기능이 있는 요소는 `semanticLabel`을 반드시 포함해야 한다.
- **Visual-only content**: 단순히 배경을 꾸미는 아이콘이나 이미지는 `ExcludeSemantics`를 사용하여 스크린 리더가 건너뛰도록 한다.
- **Complex Data**: 날씨 게이지와 같이 시각적 정보가 중요한 요소는 `Semantics(label: "...", value: "...")`를 사용하여 수치를 음성으로 설명한다.

### 1.4. Touch Targets
- **Size**: 모든 유동적인 터치 영역(Button, Chip)은 최소 **48x48 dp**의 크기를 확보하거나, 패딩을 통해 유효 터치 영역을 확장해야 한다.

## 2. Visual Identity: Atmospheric Realism

### 2.1. Color Strategy: "Midnight Mist" (V2)
기존의 고대비 "Prism & Void"에서 더욱 차분하고 명상적인 **"Midnight Mist"**로 진화했습니다.

- **Dark Theme (Baseline):** 깊은 새벽 숲의 안개를 연상시키는 Deep Indigo 배경에 은은한 등불의 온기를 배치.
- **Light Theme:** 안개 낀 아침 같은 Soft Frost 배경에 차분한 색조를 사용.

#### Dark Mode Tokens (Midnight Mist)
- **Background (Deep Midnight):** `#0A121A` (깊은 공간감과 안개 낀 느낌)
- **Surface (Misty Glass):** `#1A262F` with 60% Opacity (블러 처리된 전면 레이어)
- **Primary (Lantern Glow):** `#FDF0D5` (따뜻한 등불의 빛, 핵심 액션 컬러)
- **Secondary (Spirit Teal):** `#80DED9` (신비로운 자연의 기운, 포인트 컬러)
- **Accent (Glow):** 주변 환경 광원 효과.

### 2.2. Materials & Surface
- **Glassmorphism:** 모든 모달과 카드는 뒷 배경이 은은하게 비치는 블러(Blur) 처리가 된 유리 질감을 기본으로 한다.
- **Mist Effect:** `glassBlur`를 `24.0` 이상으로 설정하여 전반적으로 몽환적인 안개 효과를 연출한다.
- **Elevation:** 단순한 그림자 대신, 상단 레이어에 더 밝은 테두리(Border Opacity)와 광원 효과를 부여하여 계층을 나타낸다.

### 2.3. Typography
- **Concept:** 정갈하면서도 감성적인 서체 활용.
- **Heading:** 굵은 가중치와 넓은 자간으로 가독성과 존재감 확보.
- **Body:** 여백을 충분히 두어 눈의 피로도를 낮춤.

### 2.4. Motion (Vibe)
- **Organic Flow:** 모든 애니메이션은 `Curves.easeOutCubic` 또는 `Curves.easeInOut`을 사용하여 기계적이지 않고 자연스럽게 움직인다.
- **Micro-interactions:** 버튼 클릭 시 미세한 진동(Haptic)과 함께 광원이 퍼지는 시각 효과 제공.
