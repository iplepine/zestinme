# Task

ID: `FC-001-condition-loop-alignment`

유형: `Build`

상태: `Active`

연결 Roadmap: `R-001-fullcon-rebrand-loop`

연결 Goal: `G-001-fullcon-core-loop`

마지막 갱신일: 2026-05-03

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

- [ ] 앱 주요 화면 문구가 FullCon 약속과 충돌하지 않음
- [ ] 컨디션 기록 모델이 핵심 루프 문서와 맞음
- [ ] 테스트 또는 검증 완료
- [ ] 관련 문서 업데이트
- [ ] 남은 리스크 기록

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

## 결과

완료 내용:

검증 결과:

남은 리스크:

후속 task:
