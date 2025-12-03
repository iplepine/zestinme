# Architecture Specification

## 1. Overview
InsightMe는 **Clean Architecture**와 **MVVM (Model-View-ViewModel)** 패턴을 기반으로 하며, **Feature-first** 구조를 따릅니다. 유지보수성과 테스트 용이성을 최우선으로 설계되었습니다.

## 2. Tech Stack
*   **Language:** Dart / Flutter
*   **State Management:** Riverpod (Code Generation preferred)
*   **Dependency Injection:** GetIt + Injectable (or Riverpod)
*   **Local Database:** Isar (NoSQL)
*   **Navigation:** GoRouter

## 3. Layered Architecture
각 기능(Feature)은 내부적으로 3개의 계층으로 나뉩니다.

### A. Presentation Layer (UI)
*   **Widgets (View):** 사용자에게 보여지는 UI. 로직을 포함하지 않고 상태를 구독(Watch)하여 렌더링만 담당.
*   **ViewModel (StateHolder):** `Riverpod`의 `Notifier` 또는 `AsyncNotifier`를 사용. UI 상태를 관리하고 UseCase를 호출.

### B. Domain Layer (Business Logic)
*   **Entities:** 순수 Dart 객체. 비즈니스 로직의 핵심 데이터 구조.
*   **UseCases:** 단일 비즈니스 로직 단위 (예: `SaveEmotionRecordUseCase`). Repository 인터페이스에 의존.
*   **Repositories (Interface):** 데이터 계층과의 통신 규약 정의.

### C. Data Layer (Infrastructure)
*   **Data Sources:** 실제 데이터 접근 (Local DB, Remote API).
*   **DTOs (Data Transfer Objects):** DB나 API 응답 모델. Entity로 변환(Mapper)되어 Domain 계층으로 전달됨.
*   **Repositories (Implementation):** Domain 계층의 Repository 인터페이스 구현체.

## 4. Folder Structure (Feature-first)

```
lib/
├── app/                 # 앱 전역 설정 (Theme, Routes)
├── core/                # 공통 모듈 (Utils, Constants, Base Classes)
│   ├── constants/
│   ├── errors/
│   ├── services/        # 3rd party wrappers (LocalDB, Network)
│   └── models/          # 공통 모델
├── features/            # 기능별 모듈
│   ├── emotion_write/   # [Feature Name]
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── models/  # DTOs
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── providers/ # ViewModels
│   │       ├── screens/
│   │       └── widgets/
│   └── history/
└── main.dart
```

## 5. State Management Rules (Riverpod)
*   **Immutability:** 모든 상태 클래스는 `Freezed`를 사용하여 불변성을 보장한다.
*   **Single Source of Truth:** UI는 오직 ViewModel의 상태만을 바라본다.
*   **AsyncValue:** 로딩, 에러, 성공 상태 처리는 `AsyncValue`를 적극 활용한다.

## 6. Testing Strategy
*   **Unit Test:** UseCase, Repository(Mock), ViewModel 테스트.
*   **Widget Test:** 주요 화면의 렌더링 및 인터랙션 테스트.
*   **Integration Test:** 핵심 플로우(Happy Path) 통합 테스트.
