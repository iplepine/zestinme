# UI Spec: 05-dev-setting-screen (Plant Setting Dev)

## 1. 개요 (Overview)
- **목적:** 식물의 배치, 스케일, 화분과의 간격, 배경 위치 등을 실시간으로 조정하여 최적의 '바이브(Vibe)'를 찾기 위한 개발자 전용 도구 화면.
- **철학:** Vibe Coding - 수치상의 정확함보다 시각적인 균형과 감성적 몰입감을 우선시하여 레이아웃을 미세 조정함.

## 2. 주요 기능 및 UI 구성 (Key Features & UI)

### A. 실시간 프리뷰 영역 (Interactive Preview)
- `ScenicBackground`와 `MysteryPlantWidget`이 실제 홈 화면과 동일한 비율로 렌더링됨.
- 설정 패널의 슬라이더 조작 시 즉각적으로 위치와 크기가 반영됨.

### B. 설정 패널 (Control Panel)
- **위치:** 상단 툴바 아래, 반투명 검은색 컨테이너(Glassmorphism 적용).
- **구조:** **3단계 네비게이션(3-Step Pager)** 방식.
- **구성:**
    1. **Step 1: 식물 선정 (Species):** 드롭다운을 통해 특정 식물 종을 선택하여 프리뷰.
    2. **Step 2: 성장 및 리소스 설정 (Stage & Resource):** 0~4단계 성장 슬라이더와 식물 리소스(herb, leaf, succulent 등)를 한 번에 조절.
    3. **Step 3: 수치값 미세 조정 (Layout):** 
        - Species Scale, Species Offset Y
        - Global Anchor (Bias), Pot Width, Plant Base Size
        - Plant Internal Offset, Background Offset, Scale Per Stage

### C. 도구 및 액션 (Tools & Actions)
- **Toggle Visibility (AppBar):** 눈 아이콘 버튼으로 설정 패널 숨김.
- **Save to Code (AppBar):** 현재 조정된 수치를 콘솔에 출력. 저장 시 성공 스낵바 노출.
- **Exit Safety:** 수정 사항이 있을 때 저장하지 않고 나갈 경우 '이탈 방지 팝업' 노출.

## 3. 사용 방법 (Usage Flow)
1. **식물 정하기:** Step 1에서 조정이 필요한 식물 종을 선택합니다.
2. **성장 및 리소스 정의:** Step 2에서 성장 상태와 리소스 키를 매칭하여 외형을 확인합니다.
3. **수치값 설정:** Step 3에서 모든 레이아웃 파라미터를 미세하게 조정합니다.
4. **저장:** 상단 'Save to Code' 버튼을 눌러 결과값을 콘솔에 출력하고, 소스 코드에 반영합니다.

## 4. 기술적 스펙 (Technical Specs)
- **State Management:** Riverpod (`plantLayoutProvider`) 사용.
- **Exit Logic:** `PopScope`와 `_hasUnsavedChanges` 플래그를 이용한 데이터 유실 방지.
- **UI Persistence:** 세션 내 유지, 'Save to Code'를 통한 수동 반영.
