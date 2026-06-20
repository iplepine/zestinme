<!-- COMMIT_STATUS START -->
> **커밋 상태**
> - 기준 커밋: `4a19cab93dfc60bebbcd001fbb8bbf196b447490` (`main`)
> - 최근 커밋: `4a19cab93dfc` docs: refresh project documentation status
> - 커밋 일시: `2026-06-20T22:38:59+09:00`
> - 워킹트리: `dirty (12 files)`
> - 문서 갱신: `2026-06-20 22:39:28 +0900`
<!-- COMMIT_STATUS END -->

# Task

ID: `FC-004-quality-baseline-stabilization`

유형: `Build`

상태: `Ready`

연결 Roadmap: `R-001-fullcon-rebrand-loop`

연결 Goal: `G-001-fullcon-core-loop`

마지막 갱신일: 2026-05-10

## 목표

FullCon core-loop roadmap을 닫을 수 있도록 전체 `flutter analyze`와 `flutter test` 실패를 triage하고, 메인 제품 검증을 막는 blocker를 줄인다.

## 배경

2026-05-10 기준 전체 `flutter analyze`는 `146 issues found`, 전체 `flutter test`는 legacy `garden`, `anger`, `sleep/home` 계열 일부 테스트에서 실패한다. FC-002는 simulator QA를 진행할 수 있지만, roadmap 완료 기준을 닫으려면 전역 품질 기준도 정리해야 한다.

## 범위

포함:

- analyzer issue 분류
- failing test suite triage
- FullCon 메인 루프와 무관한 legacy failure 분리 또는 수리
- 최소한 roadmap 종료 판단에 필요한 품질 기준 명확화

제외:

- 전체 레거시 기능의 완전 재작성
- 신규 제품 기능 추가
- 대규모 디자인 리프레시

## 완료 기준

- [ ] 전체 `flutter analyze` blocker 분류 문서화
- [ ] 전체 `flutter test` red suite 원인 문서화
- [ ] 메인 제품 검증을 막는 failure가 줄거나 우회 기준이 합의됨
- [ ] 관련 roadmap / TODO / implementation 문서 업데이트

## 검증 계획

명령:

- `flutter analyze`
- `flutter test`

수동 확인:

- 없음, 문서화 중심

## 후속 task

- 레거시 범위 판단에 따라 별도 cleanup task 분리
