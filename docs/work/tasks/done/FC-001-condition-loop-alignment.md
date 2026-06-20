<!-- COMMIT_STATUS START -->
> **커밋 상태**
> - 기준 커밋: `b0e0439333d8124f868b16da66c3849455b86f30` (`main`)
> - 최근 커밋: `b0e0439333d8` feat: align FullCon core loop
> - 커밋 일시: `2026-05-03T20:36:51+09:00`
> - 워킹트리: `dirty (73 files)`
> - 문서 갱신: `2026-06-20 22:34:20 +0900`
<!-- COMMIT_STATUS END -->

# Task

ID: `FC-001-condition-loop-alignment`

유형: `Build`

상태: `Done`

연결 Roadmap: `R-001-fullcon-rebrand-loop`

연결 Goal: `G-001-fullcon-core-loop`

마지막 갱신일: 2026-05-05

## 목표

현재 FullCon 브랜딩, 컨디션 기록 모델, 홈/온보딩 문구, 핵심 문서가 `컨디션 파악 -> 행동 제안 -> 결과 기록` 루프와 충돌하지 않게 맞춘다.

## 배경

zestinme repo에는 현재 앱 리브랜딩, 아이콘, 컨디션 모델, 문서 전환 변경이 넓게 쌓여 있다. 신규 기능보다 제품 약속 정리가 먼저다.

## 범위

포함:

- FullCon 브랜드 요소
- 컨디션 기록 모델
- 홈/온보딩/설정 문구
- 핵심 루프 문서 정리

제외:

- 결제 구현
- 장문 인사이트 리포트 구현
- 의료/치료 메시지

## 완료 기준

- [x] 앱 주요 화면 문구가 FullCon 약속과 충돌하지 않음
- [x] 컨디션 기록 모델이 핵심 루프 문서와 맞음
- [x] 테스트 또는 검증 완료
- [x] 관련 문서 업데이트
- [x] 남은 리스크 기록

## 작업 계획

1. 변경된 브랜딩/모델/화면 문구를 핵심 루프 문서와 대조한다.
2. 레거시 정원/감정/수면 표현 중 충돌하는 항목을 정리한다.
3. 테스트와 수동 QA로 첫 실행 흐름을 확인한다.

## 검증 계획

명령:

- `flutter analyze`
- `flutter test`

수동 확인:

- 온보딩 시작
- 홈 첫 화면
- 체크인/회복 로그
- 히스토리/설정

## 문서 업데이트 대상

- `docs/product/POSITIONING_DECISION.md`
- `docs/product/CORE_LOOP_SPEC.md`
- `docs/product/SCOPE_CLEANUP.md`
- `docs/operations/CURRENT_IMPLEMENTATION.md`

## 사용자 확인

필요 여부: `yes`

확인할 질문: FullCon의 첫 화면 약속을 `풀컨디션 유지` 중심으로 고정할지 확인한다.

결정:
- 첫 화면 약속은 `풀컨디션 유지` 중심으로 고정한다.
- 메인 제품 라우트는 온보딩 완료 전 우회 진입을 허용하지 않는다.

## 결과

완료 내용:
- 메인 라우터에서 `/seeding`, `/history`, `/sleep`, `/settings` 온보딩 우회 예외를 제거했다.
- 홈 상태에 `todayCondition`을 추가해 `오늘 체크인` 우선 규칙을 실제 오늘 기록 기준으로 맞췄다.
- 홈 대표 점수를 보정치 없는 canonical `conditionScore`로 맞추고, 데이터가 없을 때 가짜 기본 점수 `56`을 제거했다.
- 회복 로그 저장이 실제 성공 여부를 `bool`로 반환하고, 실패 시 화면을 유지하도록 바꿨다.
- 메인 런타임 초기화에서 수면 `Hive` write path를 제거하고 `LocalDbService -> Isar` 단일 경로로 정리했다.
- 설정 화면의 레거시 `계정/로그아웃` 인상을 제거하고 로컬 우선 저장 안내로 교체했다.
- 구현 요약과 범위 정리 문서를 현재 동작 기준으로 갱신했다.

검증 결과:
- `dart analyze lib/... test/...` 대상 수정 파일 기준 `No issues found!`
- `flutter test test/features/home/presentation/providers/home_provider_test.dart test/features/sleep_record/presentation/providers/sleep_provider_test.dart` 통과
- 추가 회귀 테스트:
  - 어제 기록만 있을 때 `todayCondition`이 비어 있는지
  - 오늘 기록이 있을 때 `hasTodayCondition`이 켜지는지
  - 새로고침 시 stale `todayCondition`/`todaySleep`가 비워지는지
  - 회복 로그 저장 성공/실패 결과가 `bool`로 반환되는지

남은 리스크:
- 온보딩 중단 후 마지막 안전 단계부터 복구하는 흐름은 아직 없다.
- 온보딩 강제 진입 후 원래 요청한 메인 라우트로 복귀시키는 로직은 아직 없다.
- `MindGardener`, `garden`, `seeding`, `caring`, `login/session` 계열 레거시 구조는 내부 코드에 남아 있다.
- `ConditionRecord`/`SleepRecord`의 nullable 스키마와 정본 문서의 필수 입력 표현은 아직 완전히 일치하지 않는다.

후속 task:
- `FC-002-first-run-core-loop-simulator-qa`
