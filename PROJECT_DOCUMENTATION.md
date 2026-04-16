# ZestInMe / Mind-Gardener 프로젝트 문서

작성일: 2026-04-16  
기준 경로: `/Users/basil/Projects/flutter/zestinme`

이 문서는 현재 코드베이스의 구현 상태를 파악하기 위한 상세 문서입니다. 새로 프로젝트를 열 때는 먼저 `README.md`를 보고, 구현 세부사항이 필요할 때 이 문서를 참고합니다.

## 1. 프로젝트 개요

ZestInMe는 `Mind-Gardener` 콘셉트의 Flutter 앱입니다. 사용자의 감정, 수면, 회고 데이터를 정원과 식물의 상태로 시각화해 자기 인식과 자기 돌봄을 돕는 앱을 목표로 합니다.

핵심 제품 철학은 `spec/00-meta/00-master-concept.md` 기준으로 다음 세 가지입니다.

- 자각: 감정과 상태를 날씨, 식물, 정원 환경으로 객관화합니다.
- 수용: 부정적인 감정도 버릴 것이 아니라 성장의 재료로 다룹니다.
- 순환: 수면, 감정 기록, 감정 돌봄, 히스토리 확인의 루프를 만듭니다.

현재 구현은 Flutter 앱이 `app/` 하위에 있고, 제품/도메인/UI 설계 문서는 `spec/` 하위에 정리되어 있습니다.

## 2. 저장소 구조

```text
.
├── app/                         # Flutter 애플리케이션 본체
│   ├── lib/
│   │   ├── app/                 # 앱 루트, 라우팅, 테마
│   │   ├── core/                # 공통 모델, 서비스, 위젯, 상수
│   │   ├── di/                  # GetIt 기반 의존성 주입
│   │   ├── features/            # 기능별 모듈
│   │   └── l10n/                # 생성된 다국어 리소스
│   ├── assets/                  # 이미지, fallback 질문 데이터
│   ├── test/                    # Flutter 테스트
│   ├── android/ ios/ macos/ ... # 플랫폼별 프로젝트
│   └── pubspec.yaml             # Flutter 의존성 및 asset 설정
├── spec/                        # 제품/도메인/UI/ADR 설계 문서
├── bg_remover/                  # 배경 제거 관련 보조 도구
├── package.json                 # 루트 Node 의존성
└── TODO.md                      # 현재 TODO
```

## 3. 기술 스택

### Flutter 앱

- Flutter / Dart SDK: `app/pubspec.yaml` 기준 Dart `^3.8.1`
- 상태 관리: `flutter_riverpod`, `riverpod_annotation`
- 라우팅: `go_router`
- 의존성 주입: `get_it`
- 로컬 저장소: `isar`, `hive`, `shared_preferences`
- Firebase: `firebase_core`, `cloud_firestore`, `firebase_remote_config`
- UI/시각화: `fl_chart`, `flutter_animate`, `table_calendar`
- 음성 입력: `speech_to_text`
- 다국어: Flutter localization, `intl`
- 코드 생성: `build_runner`, `freezed`, `json_serializable`, Hive/Isar generator

### 루트 Node 의존성

루트 `package.json`에는 `@google/generative-ai`만 등록되어 있습니다. Flutter 앱 구동에는 `app/pubspec.yaml`이 주 설정 파일입니다.

## 4. 앱 시작 흐름

진입점은 `app/lib/main.dart`입니다.

1. Flutter binding 초기화
2. 한국어 날짜 포맷 초기화
3. `Injection.init()`으로 Firebase, Hive, Isar, Repository, UseCase, Coach 관련 서비스 초기화
4. Edge-to-edge 시스템 UI 설정
5. `ProviderScope`로 감싼 `MyApp` 실행

앱 루트는 `app/lib/app/app.dart`의 `MyApp`입니다.

- `MaterialApp.router` 사용
- `goRouterProvider`로 라우팅 구성
- Light/Dark theme 지원
- legacy localization과 새 l10n delegate를 함께 등록
- 텍스트 스케일을 `1.0 ~ 1.4` 범위로 제한

## 5. 라우팅

라우팅은 `app/lib/app/routes/app_router.dart`에 정의되어 있습니다.

| 경로 | 화면 | 설명 |
| --- | --- | --- |
| `/` | `MindGardenerHomeScreen` | 메인 정원 홈 |
| `/onboarding` | `OnboardingScreen` | 초기 온보딩 |
| `/history` | `HistoryScreen` | 감정 기록 히스토리 |
| `/seeding` | `SeedingScreen` | 감정 기록 |
| `/sleep` | `SleepRecordScreen` | 수면 기록 |
| `/dev` | `DevScreen` | 개발자 화면 |
| `/dev/plant-setting` | `HomePlantSettingScreen` | 홈 식물 설정 |
| `/settings` | `SettingsScreen` | 설정 |
| `/login` | `LoginPage` | 레거시 로그인 화면 |

현재 `initialLocation`은 `/dev`로 설정되어 있어 앱 실행 시 개발자 화면으로 시작합니다. 일반 사용자 플로우에서는 온보딩 완료 여부에 따라 `/onboarding` 또는 `/`로 이동하는 redirect 로직이 있습니다.

## 6. 주요 기능 현황

### 6.1 온보딩

관련 경로:

- `app/lib/features/onboarding/`
- `app/lib/features/onboarding/presentation/providers/onboarding_provider.dart`

현재 온보딩은 닉네임, 온도, 햇빛, 습도, 정서 점수, 활성 모듈, 배정 식물 정보를 다룹니다. 완료 시 환경 값이 식물 배정 로직으로 전달되고, 결과가 로컬 DB에 저장됩니다.

식물 배정은 `PlantService`가 담당합니다.

- 입력: 빛, 온도, 습도
- 방식: 각 식물의 최적 환경값과 사용자 환경값의 정규화 거리 계산
- 결과: 가장 가까운 식물 종 반환

### 6.2 홈 / 마음 정원

관련 경로:

- `app/lib/features/home/`
- `app/lib/features/garden/`

홈 화면은 시간대별 배경 이미지, 유리 질감 카드, 중앙 식물, 하단 탭 바를 표시합니다.

현재 홈의 주요 동작은 다음과 같습니다.

- `MindPlantNotifier`가 온보딩 저장값에서 식물 상태를 임시 hydrate합니다.
- 식물은 `MindPlant.getDisplayStage()`의 날짜 기반 로직으로 표시 단계가 결정됩니다.
- 식물 또는 CTA를 누르면 감정 기록 화면(`/seeding`)으로 이동합니다.
- 하단 바에서 히스토리와 설정으로 이동할 수 있습니다.
- 발견/인사이트 탭은 현재 준비 중 메시지를 표시합니다.

### 6.3 감정 기록 / Seeding

관련 경로:

- `app/lib/features/seeding/`
- `app/lib/core/models/emotion_record.dart`

감정 기록은 Russell 감정 모델에 가까운 `valence`, `arousal` 좌표와 감정 태그, 메모를 저장합니다.

현재 저장되는 주요 필드는 다음과 같습니다.

- `timestamp`
- `valence`
- `arousal`
- `emotionLabel`
- `detailedNote`
- `status`

저장은 `GetIt`으로 주입된 `LocalDbService`를 통해 Isar의 `EmotionRecord` 컬렉션에 수행됩니다.

### 6.4 감정 돌봄 / Caring

관련 경로:

- `app/lib/features/caring/`
- `app/lib/features/caring/domain/services/caring_service.dart`

감정 돌봄은 기록된 감정이 일정 시간 지난 뒤 회고 질문을 통해 다듬는 기능입니다.

현재 서비스 로직:

- 감정 기록 후 4시간 이상 지나면 돌봄 가능
- 밤 22시부터 04시 사이에는 최근 24시간 기록을 정리할 수 있음
- 시간대와 각성도에 따라 코칭 깊이를 조절
- 감정 라벨과 메모를 기반으로 질문 템플릿을 선택하고 `{context}`를 치환

### 6.5 수면 기록

관련 경로:

- `app/lib/features/sleep_record/`
- `app/lib/core/models/sleep_record.dart`

수면 기능은 취침/기상 시간, 수면 질, 아침 상쾌함, 태그, 메모를 다룹니다.

데이터 모델의 주요 필드:

- `date`
- `inBedTime`
- `wakeTime`
- `sleepLatencyMinutes`
- `wasoMinutes`
- `durationMinutes`
- `sleepEfficiency`
- `qualityScore`
- `selfRefreshmentScore`
- `isNaturalWake`
- `isImmediateWake`
- `snoozeCount`
- `tags`
- `memo`

현재 수면 저장소는 두 흐름이 함께 존재합니다.

- `SleepRecordRepositoryImpl`: Hive box `sleep_records` 사용
- `LocalDbService`: Isar `SleepRecord` 컬렉션 사용

`SleepHomeController`는 최근 30일 수면 기록을 `LocalDbService`에서 조회합니다. 반면 UseCase 계층은 `SleepRecordRepository`와 Hive 구현체를 사용합니다. 이 부분은 저장소 일원화가 필요한 기술 부채입니다.

### 6.6 히스토리

관련 경로:

- `app/lib/features/history/`

히스토리는 현재 선택한 월의 감정 기록을 Isar에서 조회합니다.

- `HistoryDate`: 현재 선택 날짜 상태
- `historyRecords`: 선택 월의 시작/끝 범위를 계산해 `EmotionRecord` 목록 조회
- UI 구성 요소: 캘린더, 타임라인, 리스트 아이템

### 6.7 분노 코칭 모듈

관련 경로:

- `app/lib/features/anger/`

분노 코칭 모듈은 질문 은행과 규칙 엔진을 통해 Quick/Deep 코칭 질문을 선택하는 구조입니다.

`RuleEngine`의 주요 기준:

- 질문 타입: quick/deep
- 쿨다운
- 강도 조건
- 태그 조건
- 시간대 조건
- 사용자 효과 점수
- 강도 밴드별 카테고리 가중치
- 태그 기반 라우팅
- entry id 기반 결정적 샘플링

Firebase Remote Config와 Firestore를 통해 질문 은행과 코칭 기록을 다루는 구조가 준비되어 있습니다.

## 7. 데이터 저장 구조

### Isar

`LocalDbService`가 다음 스키마를 열어 사용합니다.

- `EmotionRecord`
- `OnboardingDataModel`
- `SleepRecord`

주 용도:

- 감정 기록 저장/조회/삭제
- 돌봄 전 감정 기록 조회
- 기간별 감정 기록 조회
- 수면 기록 저장/조회/삭제
- 온보딩 데이터 저장

### Hive

`Injection.init()`에서 `SleepRecordDtoAdapter`를 등록하고 `sleep_records` box를 엽니다. Sleep UseCase/Repository 흐름에서 사용됩니다.

### Firebase

`FirebaseService`가 다음을 초기화합니다.

- Firebase Core
- Cloud Firestore
- Firebase Remote Config

Remote Config 기본값으로 `question_bank_json`을 설정하며, fetch 실패 시에도 앱 시작은 계속되도록 되어 있습니다.

현재 코칭 저장소는 `anonymous_user`를 사용합니다. 실제 사용자별 데이터 분리는 Firebase Auth 연동이 필요합니다.

## 8. 다국어와 UI 리소스

다국어 설정은 `app/l10n.yaml` 기준입니다.

- ARB 위치: `app/l10n/`
- 템플릿: `app_en.arb`
- 생성 결과: `app/lib/l10n/app_localizations.dart`
- 지원 언어: 영어, 한국어

앱에서는 `core/localization`의 legacy localization과 `lib/l10n`의 새 localization이 함께 사용됩니다. 장기적으로는 한쪽으로 정리하는 것이 좋습니다.

이미지 asset은 `app/pubspec.yaml`에 다음 범위로 등록되어 있습니다.

- `assets/question_bank_fallback.json`
- `assets/images/`
- `assets/images/pots/`
- `assets/images/plants/`
- `assets/images/backgrounds/`

## 9. 테스트 현황

현재 확인된 테스트 파일:

- `app/test/features/anger/rule_engine_test.dart`
- `app/test/features/garden/domain/services/plant_service_test.dart`
- `app/test/features/sleep_record/presentation/controller/sleep_home_controller_test.dart`
- `app/test/features/sleep_record/presentation/home/sleep_home_page_test.dart`
- `app/test/features/sleep_record/presentation/integration/sleep_home_integration_test.dart`
- `app/test/features/sleep_record/presentation/widgets/sleep_history_chart_test.dart`

테스트 커버리지는 분노 코칭 규칙 엔진, 식물 배정 서비스, 수면 홈/차트 주변에 집중되어 있습니다. 감정 기록, 돌봄, 히스토리, 온보딩 저장 플로우는 추가 테스트 여지가 큽니다.

## 10. 실행 및 개발 명령

Flutter 앱 작업은 `app/` 디렉터리에서 수행합니다.

```bash
cd app
flutter pub get
flutter run
```

정적 분석:

```bash
cd app
flutter analyze
```

테스트:

```bash
cd app
flutter test
```

코드 생성:

```bash
cd app
dart run build_runner build --delete-conflicting-outputs
```

## 11. 현재 주요 기술 부채와 주의점

- 앱 시작 경로가 `/dev`로 되어 있어 일반 사용자 플로우 검증 시 `initialLocation` 조정이 필요합니다.
- 수면 기록 저장소가 Hive Repository 흐름과 Isar `LocalDbService` 흐름으로 나뉘어 있습니다.
- `MindPlantNotifier`는 온보딩 데이터에서 임시로 식물 상태를 구성하며, 전용 GardenRepository 저장은 TODO 상태입니다.
- `TODO.md`에는 `PlantStaticData`를 Isar 또는 Remote DB로 이전하는 작업이 명시되어 있습니다.
- Firebase Auth가 아직 연결되지 않아 코칭 저장소의 user id가 `anonymous_user`로 고정되어 있습니다.
- legacy localization과 generated l10n이 공존합니다.
- 일부 구현에는 개발용 화면과 테스트 페이지가 남아 있습니다.

## 12. 설계 문서 맵

`spec/` 디렉터리는 제품 방향과 상세 기획의 기준 문서입니다.

- `spec/00-meta/00-master-concept.md`: 전체 PRD와 제품 철학
- `spec/10-domain/`: 성장 시스템, 심리 모델, 디지털 phenotyping, 식물 DB, 감정 가치 프레임워크
- `spec/15-data-model/`: Isar 엔티티 설계
- `spec/20-feature/`: 기능별 명세
- `spec/50-ui/`: 화면별 UI 설계와 디자인 시스템
- `spec/adr/`: 아키텍처 의사결정 기록

현재 구현과 설계 문서가 완전히 1:1로 맞지는 않습니다. 기능 추가 또는 리팩터링 전에는 관련 `spec/` 문서를 먼저 확인하고, 구현과 차이가 생긴 부분은 문서 또는 코드 중 어느 쪽을 기준으로 삼을지 결정하는 것이 좋습니다.
