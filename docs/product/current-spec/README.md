<!-- COMMIT_STATUS START -->
> **커밋 상태**
> - 기준 커밋: `b0e0439333d8124f868b16da66c3849455b86f30` (`main`)
> - 최근 커밋: `b0e0439333d8` feat: align FullCon core loop
> - 커밋 일시: `2026-05-03T20:36:51+09:00`
> - 워킹트리: `dirty (73 files)`
> - 문서 갱신: `2026-06-20 22:34:20 +0900`
<!-- COMMIT_STATUS END -->

# FullCon Current Spec

이 폴더는 **현재 FullCon 기준의 실전 스펙 묶음**이다.  
현재는 `00-master-spec.md` 하나를 정본으로 사용한다.

## 문서 구성

1. [00-master-spec.md](./00-master-spec.md)
   - 단일 정본 스펙
   - 제품 정의, 시스템 구조, 화면 계약
   - 데이터/저장/로직 계약
   - 구현 원칙, 로드맵, 성공 기준

2. [05-use-cases.md](./05-use-cases.md)
   - 사용자/시스템 유즈케이스 분리 문서
   - 온보딩, 홈, 체크인, 회복 로그, 개입, 타임라인, 설정, 운영 시나리오

3. [10-screen-contracts.md](./10-screen-contracts.md)
   - 병합 안내 문서
   - 실제 내용은 `00-master-spec.md`의 화면 계약 섹션 참조

4. [20-data-logic-contracts.md](./20-data-logic-contracts.md)
   - 병합 안내 문서
   - 실제 내용은 `00-master-spec.md`의 데이터/로직 섹션 참조

5. [30-vibe-coding-playbook.md](./30-vibe-coding-playbook.md)
   - 병합 안내 문서
   - 실제 내용은 `00-master-spec.md`의 구현 원칙 섹션 참조

## 읽는 순서

1. `00-master-spec.md`
2. `05-use-cases.md`
3. 필요 시 나머지 문서는 병합 위치 안내만 확인

## 문서 해석 원칙

- `00-master-spec.md`가 현재 기준의 **유일한 우선 명세**다.
- `05-use-cases.md`는 `00-master-spec.md`에서 파생된 실행 시나리오 문서다.
- 기존 `features/*`, `ui/*` 문서는 참고는 가능하지만 다수가 레거시다.
- `product/domain/*`도 현재는 mixed reference로 보고, 특히 `growth-system`, `plant-database` 계열은 레거시 해석 비중이 높다.
- 현재 구현 설명은 루트의 [docs/operations/CURRENT_IMPLEMENTATION.md](../../operations/CURRENT_IMPLEMENTATION.md)를 본다.
- 분리 문서에 새 규칙을 추가하지 않는다.
- “실제 코드가 이미 존재하는가”와 “앞으로 어떤 방향으로 계속 정리할 것인가”를 함께 반영한다.
