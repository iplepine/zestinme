<!-- COMMIT_STATUS START -->
> **커밋 상태**
> - 기준 커밋: `b0e0439333d8124f868b16da66c3849455b86f30` (`main`)
> - 최근 커밋: `b0e0439333d8` feat: align FullCon core loop
> - 커밋 일시: `2026-05-03T20:36:51+09:00`
> - 워킹트리: `dirty (73 files)`
> - 문서 갱신: `2026-06-20 22:34:20 +0900`
<!-- COMMIT_STATUS END -->

# Task

ID: `FC-002-first-run-core-loop-simulator-qa`

유형: `Verify`

상태: `Active`

연결 Roadmap: `R-001-fullcon-rebrand-loop`

연결 Goal: `G-001-fullcon-core-loop`

마지막 갱신일: 2026-06-20

## 목표

FullCon 첫 실행부터 홈, 체크인, 행동 제안, 결과 기록까지 `풀컨디션 유지` 루프가 앱에서 끊기지 않는지 simulator 기준으로 확인한다.

## 배경

`FC-001-condition-loop-alignment`에서 브랜딩, 컨디션 기록 모델, 문구 정합성을 맞췄다. 다음에는 실제 앱 첫 경험이 감정 일기나 수면 기록장이 아니라 컨디션 코치로 읽히는지 검증해야 한다.

## 범위

포함:

- 온보딩 첫 화면 약속 확인
- 홈에서 현재 컨디션 파악 흐름 확인
- 행동 제안과 결과 기록 흐름 확인
- 레거시 정원/감정/수면 표현이 제품 약속을 흐리는지 기록

제외:

- 결제
- 장문 인사이트 리포트
- 의료/치료 효능 메시지

## 완료 기준

- [ ] 첫 화면이 `풀컨디션 유지` 약속으로 설명됨
- [ ] 체크인 후 행동 제안과 결과 기록까지 흐름이 확인됨
- [ ] 레거시 표현의 유지/수정/제거 판단이 기록됨
- [ ] `flutter analyze` 통과
- [ ] `flutter test` 통과
- [ ] 관련 문서 업데이트
- [ ] 남은 리스크 기록

## 작업 계획

1. `FC-001`의 문구/모델 정합성 작업 결과를 기준으로 앱을 실행한다.
2. iOS simulator에서 첫 실행부터 결과 기록까지 수동 확인한다.
3. 반복 사용과 유료 인사이트로 이어지지 않는 표현을 문서화한다.

## 검증 계획

명령:

- `flutter analyze`
- `flutter test`

수동 확인:

- iOS simulator 온보딩
- 홈 첫 화면
- 컨디션 체크인
- 행동 제안
- 결과 기록
- 히스토리/설정

## 문서 업데이트 대상

- `docs/product/POSITIONING_DECISION.md`
- `docs/product/CORE_LOOP_SPEC.md`
- `docs/product/SCOPE_CLEANUP.md`
- `docs/operations/CURRENT_IMPLEMENTATION.md`
- `docs/work/README.md`
- `docs/work/TODO.md`
- `docs/work/goals/active/G-001-fullcon-core-loop.md`
- `docs/work/roadmaps/active/R-001-fullcon-rebrand-loop.md`

## 사용자 확인

필요 여부: `no`

확인할 질문: 첫 화면 약속을 `풀컨디션 유지` 중심으로 고정한 뒤 simulator QA를 진행한다.

결정:
- 첫 화면 약속은 `풀컨디션 유지` 기준으로 고정한다.
- FC-002는 이 기준이 실제 첫 실행 플로우에서 유지되는지 simulator로 검증한다.

## 결과

완료 내용:
- FC-001 결과를 기준으로 simulator QA 대상 플로우와 남은 리스크를 재정리했다.
- targeted regression 검증으로 홈 `todayCondition` 우선 규칙과 회복 로그 저장 성공/실패 반환을 확인했다.
- 전체 `flutter analyze`와 `flutter test`를 한 번 돌려 FC-002 종료 전 남아 있는 전역 blocker를 수집했다.

검증 결과:
- `dart analyze` 대상 수정 파일 기준 `No issues found!`
- `flutter test test/features/home/presentation/providers/home_provider_test.dart test/features/sleep_record/presentation/providers/sleep_provider_test.dart` 통과
- 전체 `flutter analyze`: `146 issues found`
  - 대부분 deprecated API, legacy provider generation, `withOpacity`, `print`, unused import/variable 계열
- 전체 `flutter test`: 실패
  - `test/features/garden/domain/services/plant_service_test.dart`
  - `test/features/anger/rule_engine_test.dart`
  - 그 외 legacy sleep/home 계열 테스트 일부가 함께 red 상태

남은 리스크:
- iOS simulator 기준 첫 실행 수동 QA는 아직 실행 전이다.
- 전체 `flutter analyze`와 `flutter test`가 아직 통과하지 않아 FC-002 완료 조건을 닫지 못했다.
- 온보딩 중단 후 마지막 안전 단계부터 복구하는 흐름은 아직 없다.
- 온보딩 강제 진입 후 원래 요청한 메인 라우트로 복귀시키는 로직은 아직 없다.
- `MindGardener`, `garden`, `seeding`, `caring`, `login/session` 계열 레거시 구조와 카피가 내부에 남아 있다.
- `tmp_onboarding_start.png` 등 QA 산출물은 커밋 전 보관/삭제 여부를 정해야 한다.

후속 task:
- `FC-003-onboarding-resume-and-return-route`
- `FC-004-quality-baseline-stabilization`
