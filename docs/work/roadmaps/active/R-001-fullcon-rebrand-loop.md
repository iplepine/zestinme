<!-- COMMIT_STATUS START -->
> **커밋 상태**
> - 기준 커밋: `4a19cab93dfc60bebbcd001fbb8bbf196b447490` (`main`)
> - 최근 커밋: `4a19cab93dfc` docs: refresh project documentation status
> - 커밋 일시: `2026-06-20T22:38:59+09:00`
> - 워킹트리: `dirty (12 files)`
> - 문서 갱신: `2026-06-20 22:39:28 +0900`
<!-- COMMIT_STATUS END -->

# Roadmap

ID: `R-001-fullcon-rebrand-loop`

상태: `Active`

연결 Goal: `G-001-fullcon-core-loop`

마지막 갱신일: 2026-06-20

## 목적

FullCon 브랜딩, 컨디션 모델, 홈/온보딩 문구, 핵심 문서를 하나의 풀컨디션 유지 루프로 맞춘다.

## 기간

시작: 2026-05-03

목표 종료: 2026-06-27

## 진행률

진행률: 65%

근거: FC-001에서 브랜딩, 라우팅, 홈 CTA, 회복 저장, 핵심 문서 정합성을 맞췄다. 현재는 FC-002에서 simulator QA와 레거시 표현 판단을 진행 중이다. 일부 targeted test는 통과했지만 전체 `flutter analyze`/`flutter test` 기준선이 아직 red 상태라 roadmap 완료로 보지 않는다.

## Milestones

| 순서 | Milestone | 완료 기준 | 상태 |
|---:|---|---|---|
| 1 | 브랜딩 정리 | 앱 이름/아이콘/핵심 문구가 FullCon 기준 | `Done` |
| 2 | 컨디션 루프 정리 | 상태 파악/행동 제안/결과 기록 흐름 문서화 | `Done` |
| 3 | 실행 검증과 레거시 범위 정리 | simulator QA와 유지/제거/보류 기준 기록 | `Active` |

## Active Tasks

- `FC-002-first-run-core-loop-simulator-qa`

## Completed Tasks

- `FC-001-condition-loop-alignment`

## Backlog Tasks

- `FC-003-onboarding-resume-and-return-route`
- `FC-004-quality-baseline-stabilization`
- 인사이트 리포트 유료 가설 정리

## 제외

이번 roadmap에서 하지 않는 일:

- 결제 구현
- 장문 리포트 화면
- 의료/치료 효능 메시지

## 검증 계획

테스트: core model/unit tests, Flutter widget tests

빌드/QA: Flutter analyze/test, iOS simulator 필요 시 수동 확인

사용자/시장 검증: 반복 사용 의향 인터뷰 또는 수동 사용 로그

## 완료 후 업데이트

- [ ] 연결 Goal 지표 갱신
- [ ] 제품 문서 갱신
- [ ] 진행상황 문서 갱신
- [ ] 완료 task 이동
