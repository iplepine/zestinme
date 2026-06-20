<!-- COMMIT_STATUS START -->
> **커밋 상태**
> - 기준 커밋: `4a19cab93dfc60bebbcd001fbb8bbf196b447490` (`main`)
> - 최근 커밋: `4a19cab93dfc` docs: refresh project documentation status
> - 커밋 일시: `2026-06-20T22:38:59+09:00`
> - 워킹트리: `dirty (12 files)`
> - 문서 갱신: `2026-06-20 22:39:28 +0900`
<!-- COMMIT_STATUS END -->

# FullCon 현재 구현 문서

작성일: 2026-04-29  
마지막 갱신일: 2026-05-10
기준 경로: `/Users/basil/Projects/flutter/zestinme`

이 문서는 현재 코드베이스에 **실제로 구현된 내용**을 정리한 문서다.  
기획 의도나 과거 `Mind-Gardener` 문서가 아니라, **지금 앱이 어떤 구조로 돌아가고 무엇이 연결돼 있는지**를 빠르게 파악하는 데 목적이 있다.

## 1. 프로젝트 한 줄 정의

FullCon(`풀컨`)은 감정 일기 앱이 아니라, **오늘의 컨디션을 읽고 다음 행동을 먼저 제안하는 로컬 우선 컨디션 코치 앱**이다.

현재 사용자 중심 플로우는 다음 5개다.

- 온보딩
- 오늘 컨디션 체크인
- 회복 로그(수면/기상 상태 기록)
- 컨디션 타임라인
- 설정

## 2. 현재 제품 방향

현재 코드베이스의 사용자-facing 방향은 다음 키워드로 정리할 수 있다.

- 브랜드명: `FullCon` / `풀컨`
- 메인 언어: `컨디션`, `회복`, `체크인`, `제안`, `타임라인`, `오늘`
- 제품 포지션: `로컬 우선 컨디션 코치`
- 메인 메시지: 기록을 쌓는 데서 끝나지 않고, 오늘 무엇을 조정할지 보여주는 앱

과거 문서의 `정원`, `식물 성장`, `감정 씨앗`, `퀘스트` 메타포는 코드 안에 일부 흔적이 남아 있지만, 현재 메인 사용자 경험의 중심은 아니다.

## 3. 저장소 구조

```text
.
├── app/                      # Flutter 앱 본체
│   ├── lib/
│   │   ├── app/              # 앱 루트, 라우터, 테마
│   │   ├── core/             # 공통 모델, 서비스, 위젯, 상수
│   │   ├── di/               # GetIt 초기화
│   │   ├── features/         # 기능별 화면과 provider
│   │   └── l10n/             # 생성된 localization 코드
│   ├── assets/               # 배경, 아이콘, 질문 데이터 등
│   └── pubspec.yaml          # Flutter 의존성
├── README.md                 # 저장소 진입 문서
├── docs/operations/CURRENT_IMPLEMENTATION.md # 이 문서
├── docs/archive/PROJECT_DOCUMENTATION_LEGACY.md  # 레거시 전환 참고 문서
├── docs/product/MVP_SCOPE.md              # 현재 FullCon MVP 기준 문서
├── docs/product/current-spec/             # 현재 정본 스펙 묶음
└── docs/work/TODO.md                      # 현재 교차 TODO
```

## 4. 기술 스택

`app/pubspec.yaml` 기준:

- Flutter / Dart 3.8.x
- 상태 관리: `flutter_riverpod`, `riverpod_annotation`
- 라우팅: `go_router`
- DI: `get_it`
- 로컬 저장: `isar`, `hive`, `shared_preferences`
- Firebase: `firebase_core`, `cloud_firestore`, `firebase_remote_config`
- 시각화/애니메이션: `flutter_animate`, `table_calendar`, `fl_chart`
- 음성 입력: `speech_to_text`
- 다국어: Flutter localization, `intl`

## 5. 앱 시작 구조

앱 진입은 `app/lib/main.dart`다.

시작 순서는 다음과 같다.

1. Flutter binding 초기화
2. 한국어 날짜 포맷 초기화
3. `Injection.init()` 실행
4. Edge-to-edge 시스템 UI 설정
5. `ProviderScope(MyApp)` 실행

`MyApp`은 `MaterialApp.router`를 사용하고, 다음을 붙인다.

- `GoRouter`
- light/dark theme
- locale provider
- legacy localization delegate + new l10n delegate
- 텍스트 스케일 clamp (`1.0 ~ 1.4`)

## 6. 현재 라우트 표면

현재 `app/lib/app/routes/app_router.dart` 기준 라우트는 다음과 같다.

### 6.1 사용자 메인 라우트

| 경로 | 화면 | 역할 |
| --- | --- | --- |
| `/` | `MindGardenerHomeScreen` | 메인 홈 대시보드 |
| `/onboarding` | `OnboardingScreen` | 최초 진입 온보딩 |
| `/seeding` | `SeedingScreen` | 오늘 컨디션 체크인 |
| `/sleep` | `SleepRecordScreen` | 회복 로그 입력/수정 |
| `/history` | `HistoryScreen` | 컨디션 타임라인 |
| `/settings` | `SettingsScreen` | 설정 |

### 6.2 내부/레거시 라우트

| 경로 | 화면 | 상태 |
| --- | --- | --- |
| `/dev` | `DevScreen` | 개발용 네비 허브 |
| `/dev/plant-setting` | `HomePlantSettingScreen` | 개발용 설정 화면 |
| `/login` | `LoginPage` | 레거시 로그인 |

### 6.3 라우터 동작 특징

- `initialLocation`은 현재 `/`
- 온보딩이 완료되지 않았으면 `/onboarding`으로 리다이렉트
- 메인 제품 라우트(`/`, `/seeding`, `/history`, `/sleep`, `/settings`)는 온보딩 완료 후에만 진입 가능
- `/dev`, `/dev/plant-setting`, `/login`만 내부/레거시 용도로 온보딩 우회를 허용

## 7. 현재 핵심 사용자 플로우

### 7.1 온보딩

현재 온보딩은 3단계다.

1. `SceneVoid`
   - FullCon 소개
   - 회복/체크인/제안 미리보기
2. `SceneIdentity`
   - 닉네임 입력
3. `SceneEncounter`
   - 첫 컨디션 체크인
   - 체크인 요약
   - 완료 후 홈 이동

온보딩 완료 시 `OnboardingViewModel.complete()`가 실행되고:

- 환경값 기반 식물 배정
- 온보딩 데이터 저장
- `isCompleted = true` 반영
- 홈(`/`) 이동

주의할 점:

- 현재 온보딩의 마지막 단계는 사실상 `컨디션 체크인`을 재사용한다.
- 식물 배정 로직은 남아 있지만, 메인 제품 설명에서 전면에 드러나지는 않는다.

### 7.2 홈 대시보드

현재 홈은 최근 정리로 매우 단순화된 상태다.

첫 화면 계약은 다음 3블록이다.

1. `오늘 상태`
   - 점수 링
   - 현재 상태 헤드라인
   - 한 줄 제안
   - 상태 요약 한 줄
2. `지금 할 일`
   - 가장 우선해야 할 액션 1개
   - 보통 `오늘 체크인` 또는 `회복 로그 남기기`
3. `이번 주 한 줄`
   - 주간 인사이트
   - 1~2개의 핵심 하이라이트
   - 타임라인 이동 버튼

하단 바는 다음 4개 탭만 제공한다.

- 오늘
- 타임라인
- 회복
- 설정

### 7.3 오늘 컨디션 체크인

체크인 화면은 `SeedingScreen` + `SeedingContent`로 구현돼 있다.

현재 입력 구조:

- 기본 입력
  - 에너지
  - 회복
- 빠른 판독
  - 자동 계산 점수
  - 대표 상태 태그
- 저장
- 선택 입력 펼침 후
  - 집중
  - 스트레스
  - 상태 태그
  - 영향 준 상황
  - 몸 반응
  - 메모

저장 시 `ConditionRecord`가 생성되고 Isar에 저장된다.

현재 설계 특징:

- 첫 화면은 텍스트를 줄이고 30초 안에 끝내는 구조
- 상세 입력은 기본적으로 접혀 있음
- 홈 제안과 히스토리 점수 계산의 재료로 사용됨

### 7.4 회복 로그 / 수면 기록

현재 메인 수면 라우트 `/sleep`는 `SleepRecordScreen`이다.

즉, 사용자 메인 플로우는 `SleepHomePage`가 아니라 **상세 입력 화면 직행**이다.

수면 입력에서 다루는 값:

- 취침 시간 / 기상 시간
- 입면 잠복기
- 수면 질
- 아침 회복감
- 자연 기상 여부
- 바로 일어났는지 여부
- 스누즈 횟수
- 수면 관련 태그
- 메모

저장 시 `SleepNotifier.saveRecord()`가 `SleepRecord`를 만들고 `LocalDbService.saveSleepRecord()`로 저장한다.

현재 구조상:

- 수면 입력 UI는 비교적 상세함
- 홈에서는 이를 `회복 로그`라는 이름으로 다룸
- 수면 홈(`SleepHomePage`)은 코드에 남아 있지만 메인 라우터에 붙어 있지 않음

### 7.5 컨디션 타임라인

히스토리 화면은 다음 2부분으로 나뉜다.

- 상단: 월간 캘린더
- 하단: 드래그 가능한 요약/타임라인 시트

여기서 중요한 점은, 타임라인이 `ConditionRecord`와 `SleepRecord`를 그대로 그리지 않고 **중간에 `EmotionRecord` 형태로 래핑해서** 하나의 리스트처럼 다룬다는 것이다.

즉:

- 컨디션 체크인 엔트리
- 회복 로그 엔트리

를 하나의 월간 흐름으로 보여준다.

### 7.6 설정

설정 화면에서 현재 가능한 것은 다음과 같다.

- 다크 모드 on/off
- Theme mode 선택
- 앱 언어 선택 (`ko`, `en`)
- 제품 소개 / 버전 확인
- 로컬 우선 저장 안내
- 계정 없이 핵심 루프가 동작한다는 안내

## 8. 현재 구현된 데이터 모델

### 8.1 핵심 영속 모델

| 모델 | 파일 | 역할 |
| --- | --- | --- |
| `ConditionRecord` | `app/lib/core/models/condition_record.dart` | 컨디션 체크인 저장 |
| `SleepRecord` | `app/lib/core/models/sleep_record.dart` | 회복 로그/수면 저장 |
| `EmotionRecord` | `app/lib/core/models/emotion_record.dart` | 감정 기록 + caring + 히스토리 래핑 표준 |
| `OnboardingDataModel` | `app/lib/features/onboarding/data/models/onboarding_data_model.dart` | 온보딩 완료값 저장 |

### 8.2 `ConditionRecord`

현재 필드:

- `timestamp`
- `energyScore`
- `focusScore`
- `recoveryScore`
- `stressScore`
- `descriptors`
- `contextSignals`
- `bodySignals`
- `note`

현재 앱의 메인 상태 입력은 사실상 이 모델 중심이다.

### 8.3 `SleepRecord`

현재 필드:

- `date`
- `inBedTime`
- `wakeTime`
- `sleepLatencyMinutes`
- `durationMinutes`
- `sleepEfficiency`
- `qualityScore`
- `selfRefreshmentScore`
- `isNaturalWake`
- `isImmediateWake`
- `snoozeCount`
- `tags`
- `memo`

`totalSleepHours`, `averageScore`, `sleepOnsetTime` 같은 derived getter도 갖고 있다.

### 8.4 `EmotionRecord`

현재는 두 역할이 섞여 있다.

1. 과거 감정 기록/caring 모델
2. 히스토리 화면에서 condition/sleep 엔트리를 표시하기 위한 래핑 표준

즉, 메인 제품 방향은 컨디션 중심으로 이동했지만, 히스토리 표현 계층은 아직 `EmotionRecord`를 재사용한다.

### 8.5 `OnboardingDataModel`

현재 저장값:

- 닉네임
- 생성 시각
- temperature/sunlight/humidity level
- arousal/valence score
- activeModuleId
- tutorialCompleted
- assignedPlantId
- growthStage

이 중 일부는 현재 FullCon 메인 플로우보다 과거 가드닝 구조의 흔적에 가깝다.

## 9. 저장 구조

### 9.1 Isar

현재 로컬 DB 엔트리 포인트는 `LocalDbService`다.

등록 스키마:

- `ConditionRecord`
- `EmotionRecord`
- `OnboardingDataModel`
- `SleepRecord`

주요 메서드:

- `saveConditionRecord`
- `getLatestConditionRecord`
- `getConditionRecordsByDateRange`
- `saveEmotionRecord`
- `getAllEmotionRecords`
- `getEmotionRecord`
- `getUncaredEmotionRecords`
- `getEmotionRecordsByDateRange`
- `saveSleepRecord`
- `getSleepRecordByDate`
- `getSleepRecordsByRange`
- `deleteSleepRecord`

현재 사용자 메인 플로우는 대부분 이 서비스에 직접 의존한다.

### 9.2 Hive

수면 관련 `Hive` 구조가 코드에는 남아 있지만, 현재 메인 런타임 초기화 경로에서는 사용하지 않는다.

남아 있는 구조:

- `SleepRecordDto`
- `SleepRecordRepositoryImpl`
- `AddSleepRecordUseCase`
- `GetSleepRecordsUseCase`
- `UpdateSleepRecordUseCase`
- `DeleteSleepRecordUseCase`

하지만 실제 메인 UI는 `SleepNotifier -> LocalDbService -> Isar` 단일 경로를 탄다.

즉, 메인 플로우의 수면 저장은 현재 **Isar 단일 write path**로 돌아가고, `Hive` 구조는 레거시 정리 대상으로만 남아 있다.

### 9.3 Firebase

`FirebaseService`는 현재 다음만 초기화한다.

- Firebase Core
- Cloud Firestore
- Remote Config

현재 역할:

- question bank / 코칭 관련 원격 설정 기반
- 향후 코칭 저장소용 준비

제약:

- Firebase Auth는 아직 붙지 않음
- `CoachRepository.userId`는 현재 `anonymous_user`
- Analytics 미포함 상태에서 Remote Config 관련 경고가 날 수 있음

## 10. Provider / 상태 흐름

### 10.1 홈

`homeProvider`는 다음을 읽어 홈 상태를 만든다.

- 최신 컨디션 1건
- 최근 7일 컨디션 목록
- 오늘 수면 1건

계산값:

- `conditionScore`
- `averageEnergy`
- `averageFocus`
- `averageRecovery`
- `averageStress`
- `attentionCount`

이 값으로 홈의 상태 헤드라인과 CTA가 결정된다.

### 10.2 주간 요약

`weeklySelfUnderstandingProvider`는 최근 7일의 condition/sleep 데이터를 집계해서:

- 평균 점수
- 평균 수면
- 평균 스트레스
- 안정 비율
- 상위 신호
- 한 줄 인사이트

를 만든다.

### 10.3 히스토리

`historyProvider`는 선택 월 기준으로:

- `ConditionRecord`
- `SleepRecord`

를 조회하고, 모두 `EmotionRecord`로 변환한 뒤 timestamp 기준 정렬한다.

현재 히스토리는 이 중간 래핑 계층 덕분에 UI를 하나로 유지하고 있다.

### 10.4 온보딩

`OnboardingViewModel`은:

- 닉네임
- 환경값
- arousal/valence score
- assignedPlantId
- completion state

를 관리하고, 완료 시 repository/use case 경로를 통해 저장한다.

### 10.5 컨디션 체크인

`SeedingNotifier`는:

- 4개 점수
- 태그
- 상황 태그
- 몸 신호
- 메모

를 관리하고 `ConditionRecord`로 직렬화한다.

### 10.6 수면

`SleepNotifier`는 수면 입력 폼 상태를 관리하고, `saveRecord()`에서 `SleepRecord`를 만들어 직접 저장한다.

`SleepHomeController`도 존재하지만, 이는 최근 30일 기록을 읽어오는 별도 흐름이며 메인 라우트 중심 구조는 아니다.

## 11. 현재 화면 계약

### 11.1 홈

현재 홈은 다음 계약으로 보는 것이 맞다.

- 상단 브랜드
- 오늘 상태 1개
- 지금 할 일 1개
- 이번 주 한 줄 1개
- 하단 네비

### 11.2 체크인

현재 체크인은 다음 계약으로 보는 것이 맞다.

- 30초 안에 끝나는 핵심 입력
- 필요할 때만 펼치는 상세 입력
- 저장 즉시 홈 제안 개선에 기여

### 11.3 타임라인

현재 히스토리는 다음 계약이다.

- 월 단위 흐름 확인
- 날짜별 condition/sleep 확인
- 주간 요약 동시 제공

### 11.4 설정

현재 설정은 다음 계약이다.

- 테마
- 언어
- 브랜드/버전
- 로컬 우선 저장 안내
- 계정 없이 핵심 루프가 동작한다는 안내

## 12. 현재 디자인/UX 규칙

최근 구현 변경 기준으로 코드에서 드러나는 규칙은 다음과 같다.

- 상단은 safe area 우선
- 카메라/펀치홀 아래에서 헤더가 시작되도록 조정
- 홈 첫 화면은 의사결정 블록 수를 줄임
- 설명형 문장보다 짧고 행동 중심인 카피 사용
- 다크 테마 중심
- 유리 질감 카드 + 발광 포인트 색상 사용
- 하단 네비를 중심으로 핵심 이동 제공

현재 톤은 `심리상담 앱`보다 `컨디션 운영 화면`에 가깝다.

## 13. 코드에 남아 있지만 메인 플로우가 아닌 것

다음은 코드에 남아 있으나 현재 메인 사용자 경로에서는 비중이 낮거나 미연결 상태다.

- `SleepHomePage`
- `SleepGuidePage`
- `caring` 플로우
- `anger` 모듈
- `garden` 시각화/도메인 다수
- `Quest`, `Record`, `RecordPhoto`, `RecordLocation`
- 레거시 로그인

즉, 코드베이스는 아직 완전히 FullCon 전용으로 정리된 상태가 아니다.

## 14. 현재 기술 부채

### 14.1 저장 구조 이원화

- 메인 플로우는 `Isar` 단일 저장 경로로 정리됐지만, `Hive` 레거시 코드가 파일 단위로 남아 있음

### 14.2 문서와 코드의 불일치

- `docs/archive/spec-meta/`, `docs/product/features/`, `docs/product/ui/`, `docs/product/domain/` 상당수가 `Mind-Gardener` 시대 기준
- `docs/archive/PROJECT_DOCUMENTATION_LEGACY.md`는 현재 제품 스펙이 아니라 레거시 전환 참고용으로만 봐야 함

### 14.3 레거시 네이밍

- 클래스/폴더명에 `MindGardener`, `garden`, `seeding`, `caring` 등이 남아 있음
- 제품 카피는 FullCon 기준으로 바뀌었지만 코드 네이밍은 혼재

### 14.4 세션/로그인

- 현재 인증은 실제 백엔드 연동이 아님
- `Session`은 로컬 시뮬레이션 수준

### 14.5 라우트 표면과 내부 구조의 차이

- 메인 `/sleep`는 상세 입력 화면
- 별도 수면 홈 구조는 남아 있지만 라우터에 직접 연결되지 않음

### 14.6 검증 기준선

- targeted regression 검증:
  - `dart analyze` 대상 수정 파일 기준 통과
  - `flutter test test/features/home/presentation/providers/home_provider_test.dart test/features/sleep_record/presentation/providers/sleep_provider_test.dart` 통과
- 전체 프로젝트 기준:
  - `flutter analyze`는 현재 `146 issues found`
  - `flutter test`는 현재 legacy `garden`, `anger`, `sleep/home` 계열 일부 테스트에서 실패
- 즉, FullCon 메인 루프 쪽 회귀는 일부 막았지만 전역 품질 기준은 아직 정리 중이다.

## 15. 이 문서를 어떻게 읽으면 좋은가

현재 프로젝트를 이어서 볼 때는 다음 순서가 가장 효율적이다.

1. `README.md`
2. `docs/operations/CURRENT_IMPLEMENTATION.md` (이 문서)
3. `app/lib/app/routes/app_router.dart`
4. `app/lib/features/home/presentation/screens/mind_gardener_home_screen.dart`
5. `app/lib/features/seeding/...`
6. `app/lib/features/sleep_record/...`
7. `app/lib/features/history/...`
8. 필요 시 `docs/archive/PROJECT_DOCUMENTATION_LEGACY.md`, `docs/archive/spec-meta/`, `docs/product/features/`, `docs/product/ui/`를 레거시 참고용으로만 확인

## 16. 결론

현재 FullCon은 다음 상태로 요약할 수 있다.

- 브랜드와 사용자 메시지는 `컨디션 코치` 방향으로 재정렬됨
- 메인 사용자 플로우는 온보딩, 체크인, 회복 로그, 타임라인, 설정까지 연결돼 있음
- 핵심 저장은 Isar 중심으로 돌아감
- 히스토리는 condition/sleep 데이터를 하나의 타임라인으로 재구성함
- targeted analyze/test 기준으로 핵심 루프 회귀를 일부 막아둔 상태다
- 온보딩 복구, 원래 요청 라우트 복귀, 레거시 모듈 정리는 아직 후속 작업이다

즉, 이 프로젝트는 이미 **동작하는 FullCon MVP**에 가깝지만, 내부적으로는 아직 `FullCon 현재 구조`와 `Mind-Gardener 레거시 구조`가 함께 존재하는 과도기 코드베이스다.
