<!-- COMMIT_STATUS START -->
> **커밋 상태**
> - 기준 커밋: `b0e0439333d8124f868b16da66c3849455b86f30` (`main`)
> - 최근 커밋: `b0e0439333d8` feat: align FullCon core loop
> - 커밋 일시: `2026-05-03T20:36:51+09:00`
> - 워킹트리: `dirty (73 files)`
> - 문서 갱신: `2026-06-20 22:34:20 +0900`
<!-- COMMIT_STATUS END -->

# zestinme 문서 홈

이 디렉터리는 zestinme 저장소의 현재 제품 판단을 빠르게 찾기 위한 문서 묶음이다. 기존 루트 문서와 `spec/` 문서는 표준 구조 아래로 이동했다.

## 문서 구조

- `product/`: 제품 포지션, 핵심 루프, 기능 범위, 리포트 스펙
- `go-to-market/`: 수익 모델, 시장/사용자 리서치 로그
- `operations/`: 구현 요약, Firebase, 데이터 모델 같은 운영 문서
- `decisions/`: 제품/기술 의사결정 로그
- `work/`: 현재 goal, roadmap, active task
- `archive/`: 과거 문서 보관 자리

## 현재 정본 기준

- 사용자-facing 제품명은 `FullCon` / `풀컨`으로 둔다.
- 현재 제품은 기록 앱이 아니라 로컬 우선 컨디션 코치다.
- MVP 판단은 `상태 파악 -> 행동 제안 -> 결과 기록` 루프가 로컬 데이터만으로 안정적으로 도는지에 둔다.
- 루트 `README.md`는 저장소 소개로 유지한다.
- 기존 `MVP_SCOPE.md`는 `product/MVP_SCOPE.md`로 이동했다.
- 기존 `IMPLEMENTATION_SUMMARY.md`는 `operations/CURRENT_IMPLEMENTATION.md`로 이동했다.
- 기존 `PROJECT_DOCUMENTATION.md`, `TODO.md`, `spec/00-meta`, `spec/GEMINI.md`는 `archive/`로 이동했다.
- 기존 `spec/current`, `spec/10-domain`, `spec/20-feature`, `spec/50-ui`는 `product/` 아래로 이동했다.
- 기존 `spec/15-data-model`, `app/FIREBASE_SETUP.md`는 `operations/` 아래로 이동했다.

## 지금 읽을 문서

- `work/README.md`: 현재 목표, 로드맵, 작업 티켓
- `work/TODO.md`: 현재 우선순위 TODO와 교차 기술 부채
- `product/POSITIONING_DECISION.md`: FullCon 포지셔닝
- `product/CORE_LOOP_SPEC.md`: 핵심 루프
