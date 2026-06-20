<!-- COMMIT_STATUS START -->
> **커밋 상태**
> - 기준 커밋: `b0e0439333d8124f868b16da66c3849455b86f30` (`main`)
> - 최근 커밋: `b0e0439333d8` feat: align FullCon core loop
> - 커밋 일시: `2026-05-03T20:36:51+09:00`
> - 워킹트리: `dirty (73 files)`
> - 문서 갱신: `2026-06-20 22:34:20 +0900`
<!-- COMMIT_STATUS END -->

# FullCon 레거시 전환 참고 문서

작성일: 2026-05-01  
기준 경로: `/Users/basil/Projects/flutter/zestinme`

이 문서는 현재 제품 스펙 문서가 아니다.  
목적은 **코드와 오래된 문서에 남아 있는 ZestInMe / Mind-Gardener 흔적을 해석하는 참고 정보**를 제공하는 것이다.

현재 제품 정의, 실제 구현 상태, MVP 범위는 아래 문서를 우선한다.

1. `README.md`
2. `docs/product/current-spec/README.md`
3. `docs/operations/CURRENT_IMPLEMENTATION.md`
4. `docs/product/MVP_SCOPE.md`

## 1. 이 문서의 역할

이 문서는 아래 질문에 답하기 위해 남긴다.

- 왜 코드 안에 `MindGardener`, `garden`, `seeding`, `caring` 같은 이름이 남아 있는가
- 왜 일부 문서와 현재 FullCon 제품 언어가 다르게 보이는가
- 어떤 구조가 현재 메인 플로우이고, 어떤 구조가 레거시 흔적인가

이 문서로 현재 제품 요구사항을 결정하지 않는다.

## 2. 현재 제품 기준

현재 제품은 `ZestInMe`나 `Mind-Gardener`가 아니라 `FullCon`이다.

현재 한 줄 정의:

> FullCon은 사용자의 상태, 행동, 맥락을 지속적으로 학습하고 필요한 순간에만 개입하여 하루 퍼포먼스를 유지시키는 로컬 우선 컨디션 코치 앱이다.

현재 메인 사용자 플로우는 아래 5개다.

- 온보딩
- 컨디션 체크인
- 회복 로그
- 홈의 단일 CTA
- 타임라인 / 설정

즉, 핵심은 `정원 시각화`가 아니라 `상태 파악 -> 행동 제안 -> 결과 반영`이다.

## 3. 코드에 남아 있는 레거시 흔적

현재 코드베이스에는 과거 제품 구조의 흔적이 여전히 남아 있다.

### 3.1 네이밍 흔적

- 홈 화면 클래스명은 아직 `MindGardenerHomeScreen`이다
- 홈 관련 폴더에 `features/garden/`이 남아 있다
- 체크인 라우트명은 아직 `/seeding`이다
- 후속 돌봄 모듈 이름으로 `features/caring/`이 남아 있다
- 온보딩과 홈 일부 로직에 `PlantService`, `MindPlantNotifier`가 남아 있다

### 3.2 데이터 모델 흔적

- 현재 FullCon 메인 루프는 `ConditionRecord`, `SleepRecord` 중심으로 읽는 것이 맞다
- 동시에 과거 구조의 `EmotionRecord`도 코드와 일부 화면 흐름에 남아 있다
- 메인 수면 저장은 현재 `Isar` 단일 write path로 동작하고, `Hive` repository 구조는 레거시 코드로 남아 있다

### 3.3 화면/라우트 흔적

- `/dev`
- `/dev/plant-setting`
- `/login`

이 라우트들은 현재 메인 사용자 경험의 중심이 아니라 개발 또는 레거시 참고 표면이다.

### 3.4 자산과 문서 흔적

- `assets/images/plants/`, `assets/images/pots/` 같은 자산이 남아 있다
- `docs/archive/spec-meta/`, `docs/product/features/`, `docs/product/ui/` 하위에는 Mind-Gardener 시절 문서가 다수 남아 있다
- `docs/archive/TODO.md`에는 과거 식물/정원 중심 TODO 보관본이 남아 있고, 현재 backlog는 `docs/work/TODO.md`에서 관리한다

## 4. 오래된 이름을 현재 의미로 읽는 방법

| 오래된 이름 | 현재 읽는 방법 |
| --- | --- |
| `MindGardenerHomeScreen` | 현재 FullCon 메인 홈 화면 구현체 |
| `seeding` | 컨디션 체크인 입력 흐름 |
| `caring` | 과거 감정 돌봄/회고 모듈, 현재 메인 코어 루프는 아님 |
| `garden` / `mind plant` | 과거 시각 메타포 계층, 현재 제품 중심이 아님 |
| `EmotionRecord` | 과거 감정 기록 모델, 현재는 `ConditionRecord`와 구분해서 봐야 함 |
| `PlantService` | 레거시 식물 배정 로직, 현재 제품 차별화의 핵심은 아님 |

## 5. 현재 코드베이스를 볼 때 기억할 점

현재 구현을 읽을 때는 아래 기준을 우선한다.

- 제품 카피와 스펙은 `FullCon` 기준으로 해석한다
- 코드 클래스명과 폴더명은 일부 레거시라도 실제 동작은 현재 제품 흐름에 맞춰 본다
- 홈, 체크인, 회복 로그, 타임라인이 현재 메인 플로우다
- 식물/정원/회고 설명은 현재 요구사항이 아니라 레거시 참고로 본다

현재 코드에서 특히 주의할 점:

- 라우터 `initialLocation`은 현재 `/`다
- 온보딩 미완료 시 `/onboarding`으로 리다이렉트한다
- 다만 `/dev`, `/dev/plant-setting`, `/login`은 내부/레거시 표면으로 우회 진입이 가능하다
- 수면 저장 단일 write path 정리는 메인 플로우 기준 완료됐고, 남은 부채는 레거시 `Hive` 코드 제거 여부 판단이다

## 6. 현재 문서 체계에서의 위치

문서 역할은 아래처럼 나눈다.

- `docs/product/current-spec/00-master-spec.md`
  - 현재 제품 정본 스펙
- `docs/product/current-spec/05-use-cases.md`
  - 현재 실행 시나리오
- `docs/operations/CURRENT_IMPLEMENTATION.md`
  - 현재 코드가 실제로 어떻게 동작하는지 설명
- `docs/product/MVP_SCOPE.md`
  - 현재 FullCon MVP 범위 정리
- `docs/archive/PROJECT_DOCUMENTATION_LEGACY.md`
  - 레거시 구조와 네이밍을 해석하기 위한 참고 문서

## 7. 당장 정리해야 하는 대표 레거시 부채

우선순위가 높은 것은 아래 항목들이다.

- dev-only 표면을 계속 둘지, 더 깊게 숨길지 판단
- `MindGardener`, `garden`, `seeding`, `caring` 같은 네이밍 정리 방향 확정
- 식물/정원 자산과 로직을 유지할지, 축소할지, 제거할지 결정
- 레거시 문서와 현재 문서의 역할 경계를 더 명확히 하기

## 8. 이 문서를 쓸 때의 규칙

이 문서는 아래 용도로만 사용한다.

- 오래된 코드 이름의 의미를 해석할 때
- 과거 설계와 현재 FullCon 방향의 차이를 설명할 때
- 리팩터링 전에 어떤 구조가 레거시인지 구분할 때

이 문서를 아래 용도로 사용하면 안 된다.

- 현재 제품 스펙 결정
- 현재 MVP 범위 판단
- 현재 화면 계약의 단일 출처

현재 동작과 요구사항은 항상 `docs/product/current-spec/`와 `docs/operations/CURRENT_IMPLEMENTATION.md`를 우선한다.
