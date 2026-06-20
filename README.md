# FullCon

FullCon은 감정, 수면, 회고 데이터를 바탕으로 사용자의 컨디션 패턴을 읽고 먼저 제안하는 Flutter 기반 컨디션 코치 앱입니다. 기록을 쌓는 데서 멈추지 않고, 오늘 무엇을 조정하면 최상의 상태를 더 오래 유지할 수 있는지 보여주는 방향으로 제품을 재정의했습니다.

## 빠른 시작

Flutter 앱은 `app/` 디렉터리에서 실행합니다.

```bash
cd app
flutter pub get
flutter run
```

## 자주 쓰는 명령

정적 분석:

```bash
cd app
flutter analyze
```

테스트:

```bash
cd app
flutter test
```

코드 생성:

```bash
cd app
dart run build_runner build --delete-conflicting-outputs
```

## 문서

### 현재 문서

- [문서 홈](./docs/README.md)
- [현재 작업 관리](./docs/work/README.md)
- [현재 TODO](./docs/work/TODO.md)
- [현재 제품 스펙](./docs/product/current-spec/README.md)
- [현재 구현 요약](./docs/operations/CURRENT_IMPLEMENTATION.md)
- [MVP 현실화 정리](./docs/product/MVP_SCOPE.md)
- [Isar 데이터 모델 설계](./docs/operations/data-model/10-isar-entities.md)

### 레거시 참고

- [레거시 전환 참고](./docs/archive/PROJECT_DOCUMENTATION_LEGACY.md)
- [레거시 제품 핵심 콘셉트](./docs/archive/spec-meta/00-master-concept.md)
- [레거시 TODO 보관본](./docs/archive/TODO.md)

## 저장소 구조

```text
.
├── app/                      # Flutter 애플리케이션
├── docs/                     # 제품, 시장, 운영, 결정 문서
├── bg_remover/               # 이미지 배경 제거 보조 도구
└── README.md                 # 프로젝트 진입 문서
```

## 현재 주의할 점

- 메인 수면 기록 저장 흐름은 현재 `Isar` 단일 write path로 동작하고, `Hive` 코드는 레거시 정리 대상으로 남아 있습니다.
- Firebase Auth는 아직 연결되지 않았고, 코칭 저장소의 사용자 ID는 임시값을 사용합니다.
- 루트 `package.json`은 보조 Node 의존성용이며, Flutter 앱의 주 설정은 `app/pubspec.yaml`입니다.
