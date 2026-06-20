<!-- COMMIT_STATUS START -->
> **커밋 상태**
> - 기준 커밋: `4a19cab93dfc60bebbcd001fbb8bbf196b447490` (`main`)
> - 최근 커밋: `4a19cab93dfc` docs: refresh project documentation status
> - 커밋 일시: `2026-06-20T22:38:59+09:00`
> - 워킹트리: `dirty (12 files)`
> - 문서 갱신: `2026-06-20 22:39:28 +0900`
<!-- COMMIT_STATUS END -->

# Development Workflow

이 repo의 개발 작업은 project-manager의 공통 워크플로우를 따른다.

공통 원본:

`/Users/basil/Projects/project-manager/PROJECT_WORKFLOW.md`

## 시작 전 확인

- `docs/README.md`
- `docs/product/POSITIONING_DECISION.md`
- `docs/product/USE_CASES.md`
- `docs/product/CORE_LOOP_SPEC.md`
- `docs/product/SCOPE_CLEANUP.md`
- `docs/product/FEATURE_MAP.md`
- `docs/product/INSIGHT_REPORT_SPEC.md`
- `docs/go-to-market/REVENUE_MODEL.md`
- `docs/decisions/DECISIONS.md`

## repo별 주의점

- `FullCon` / `풀컨`의 풀컨디션 유지 약속을 기준으로 판단한다.
- 새 기능보다 `상태 파악 -> 행동 제안 -> 결과 기록` 루프를 우선한다.
- 레거시 정원/식물/감정 기록 메타포가 다시 전면에 나오지 않게 한다.
- 데이터 모델, 온보딩, 홈, 체크인, 회복 로그 변경은 스펙 확인 후 진행한다.
- UI 변경은 iOS 시뮬레이터 수동 확인 스킬을 필요할 때 사용한다.
- 배포 요청은 기본적으로 배포 전 사용자 확인이 필요하다.

## 검증 기록

작업 후 최종 보고에 아래를 남긴다.

- 확인한 문서
- 실행한 테스트/빌드 명령
- 수동 확인한 핵심 시나리오
- 갱신한 문서
- 커밋/푸시 여부
