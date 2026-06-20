<!-- COMMIT_STATUS START -->
> **커밋 상태**
> - 기준 커밋: `b0e0439333d8124f868b16da66c3849455b86f30` (`main`)
> - 최근 커밋: `b0e0439333d8` feat: align FullCon core loop
> - 커밋 일시: `2026-05-03T20:36:51+09:00`
> - 워킹트리: `dirty (73 files)`
> - 문서 갱신: `2026-06-20 22:34:20 +0900`
<!-- COMMIT_STATUS END -->

# 작업 관리

마지막 갱신일: 2026-05-10

## 현재 집중

현재 active goal: `G-001-fullcon-core-loop`

현재 active roadmap: `R-001-fullcon-rebrand-loop`

현재 active task: `FC-002-first-run-core-loop-simulator-qa`

다음 후보 task: `FC-003-onboarding-resume-and-return-route`

현재 TODO 요약: `docs/work/TODO.md`

2026-06-20 업데이트: FC-002는 아직 완료가 아니다. targeted 검증은 일부 통과했지만 전체 `flutter analyze`/`flutter test`가 red이고 iOS simulator 첫 실행 QA가 남아 있다. 신규 기능보다 QA 산출물 정리와 `FC-004-quality-baseline-stabilization` 준비가 우선이다.

## 읽는 순서

1. `goals/active/`에서 지금 왜 이 일을 하는지 확인한다.
2. `roadmaps/active/`에서 이번 사이클의 순서를 확인한다.
3. `tasks/active/`에서 지금 실제로 끝낼 작업을 확인한다.
4. 완료된 작업은 `tasks/done/`으로 옮기고 roadmap 진행률을 갱신한다.

## 운영 규칙

- active task는 최대 3개만 둔다.
- task는 반드시 roadmap에 연결한다.
- roadmap은 반드시 goal에 연결한다.
- 완료 기준이 없는 task는 active에 두지 않는다.
- 개발 task는 테스트, 빌드/검증, 문서 업데이트 체크를 포함한다.
