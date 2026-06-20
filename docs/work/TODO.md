<!-- COMMIT_STATUS START -->
> **커밋 상태**
> - 기준 커밋: `4a19cab93dfc60bebbcd001fbb8bbf196b447490` (`main`)
> - 최근 커밋: `4a19cab93dfc` docs: refresh project documentation status
> - 커밋 일시: `2026-06-20T22:38:59+09:00`
> - 워킹트리: `dirty (12 files)`
> - 문서 갱신: `2026-06-20 22:39:28 +0900`
<!-- COMMIT_STATUS END -->

# FullCon Current TODO

마지막 갱신일: 2026-05-10

이 문서는 roadmap/task 문서를 가로지르는 현재 우선순위 TODO만 짧게 모아둔 운영용 목록이다. 세부 완료 기준은 `docs/work/tasks/` 문서를 우선한다.

## 지금 바로

- [ ] `FC-002` iOS simulator로 `온보딩 -> 홈 -> 체크인 -> 회복 로그 -> 타임라인` 첫 실행 루프 수동 QA
- [ ] `FC-002` 첫 화면 약속, 단일 CTA, 결과 기록 흐름이 `풀컨디션 유지`로 읽히는지 기록
- [ ] `FC-002` QA 결과를 `docs/work`, `docs/operations/CURRENT_IMPLEMENTATION.md`, roadmap에 반영

## 다음 작업

- [ ] `FC-003` 온보딩 중단 복구와 원래 요청 라우트 복귀 구현
- [ ] `FC-004` 전체 `flutter analyze` / `flutter test` blocker 정리와 기준선 안정화
- [ ] `ConditionRecord` / `SleepRecord` nullable 스키마와 정본 문서의 필수 입력 계약 정리

## 레거시 정리

- [ ] `MindGardener`, `garden`, `seeding`, `caring`, `login/session` 레거시 네이밍과 표면 축소
- [ ] 사용하지 않는 `Hive` 수면 레거시 코드의 제거 또는 마이그레이션 계획 확정
- [ ] old localization / legacy route / dev-only 표면이 메인 제품 메시지를 흐리지 않게 정리

## 나중

- [ ] 인사이트 리포트 유료 가설 정리
- [ ] 반복 사용과 유료 전환으로 이어지는 인터뷰/사용 로그 기준선 만들기
