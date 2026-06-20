<!-- COMMIT_STATUS START -->
> **커밋 상태**
> - 기준 커밋: `b0e0439333d8124f868b16da66c3849455b86f30` (`main`)
> - 최근 커밋: `b0e0439333d8` feat: align FullCon core loop
> - 커밋 일시: `2026-05-03T20:36:51+09:00`
> - 워킹트리: `dirty (73 files)`
> - 문서 갱신: `2026-06-20 22:34:20 +0900`
<!-- COMMIT_STATUS END -->

# Goal

ID: `G-001-fullcon-core-loop`

상태: `Active`

마지막 갱신일: 2026-06-20

## 목표

FullCon을 `컨디션 파악 -> 행동 제안 -> 결과 기록` 루프가 선명한 로컬 우선 컨디션 코치로 정리한다.

## 이유

FullCon은 감정 일기나 수면 기록장으로 넓어지면 수익화와 차별성이 약해진다. 지금은 신규 기능보다 풀컨디션 유지 약속과 레거시 범위 정리가 우선이다.

## 성공 기준

| 지표 | 목표 | 현재 | 근거 수준 |
|---|---:|---:|---|
| 핵심 루프 문서 정합성 | 충돌 없음 | 정렬 완료, QA 대기 | `Signal` |
| 앱 첫 화면의 제품 약속 | FullCon 기준 | 코드 반영 완료, simulator 검증 대기 | `Signal` |
| 레거시 제거/유지 기준 | 문서화 | 초안 정리, 후속 task 대기 | `Signal` |

## 범위

포함:

- FullCon 브랜딩
- 컨디션 기록 모델
- 핵심 루프 문서 정리
- 레거시 스펙 격리

제외:

- 유료 리포트 구현
- 의료/치료 메시지
- 대형 신규 웰니스 기능

## 연결 문서

- 제품: `docs/product/POSITIONING_DECISION.md`, `docs/product/CORE_LOOP_SPEC.md`, `docs/product/SCOPE_CLEANUP.md`
- 시장: `docs/go-to-market/REVENUE_MODEL.md`
- 결정: `docs/decisions/DECISIONS.md`

## 연결 Roadmap

- `R-001-fullcon-rebrand-loop`

## 리스크

- 레거시 정원/감정/수면 메타포가 제품 약속을 흐릴 수 있다.
- 웰니스 앱은 반복 사용과 유료 전환이 어렵다.

## 다음 판단

판단할 것: 앱과 문서가 FullCon 핵심 루프 하나로 설명되는가?

판단일: 2026-06-27

2026-06-20 판단 메모: 풀컨디션 유지 루프의 문서/코드 방향은 맞춰졌지만, iOS simulator 첫 실행 QA와 전체 analyze/test red 해소가 남아 있다. 신규 기능보다 FC-002/FC-004 기준선 안정화가 우선이다.
