# ZestInMe

ZestInMe는 `Mind-Gardener` 콘셉트의 Flutter 기반 자기돌봄 앱입니다. 감정, 수면, 회고 데이터를 정원과 식물의 상태로 시각화해 사용자가 자기 상태를 더 쉽게 인식하고 돌볼 수 있도록 돕는 것을 목표로 합니다.

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

- [MVP 현실화 정리](./MVP_SCOPE.md)
- [프로젝트 구현 현황](./PROJECT_DOCUMENTATION.md)
- [제품 핵심 콘셉트](./spec/00-meta/00-master-concept.md)
- [디자인 시스템](./spec/50-ui/00-design-system.md)
- [Isar 데이터 모델 설계](./spec/15-data-model/10-isar-entities.md)
- [현재 TODO](./TODO.md)

## 저장소 구조

```text
.
├── app/                      # Flutter 애플리케이션
├── spec/                     # 제품, 도메인, UI, ADR 설계 문서
├── bg_remover/               # 이미지 배경 제거 보조 도구
├── MVP_SCOPE.md              # MVP 현실화 기준
├── PROJECT_DOCUMENTATION.md  # 현재 구현 상태 상세 문서
├── TODO.md                   # 작업 TODO
└── README.md                 # 프로젝트 진입 문서
```

## 현재 주의할 점

- 앱 라우터의 초기 경로가 개발용 `/dev`로 설정되어 있습니다.
- 수면 기록 저장 흐름은 Hive 기반 Repository와 Isar 기반 `LocalDbService`가 함께 존재합니다.
- Firebase Auth는 아직 연결되지 않았고, 코칭 저장소의 사용자 ID는 임시값을 사용합니다.
- 루트 `package.json`은 보조 Node 의존성용이며, Flutter 앱의 주 설정은 `app/pubspec.yaml`입니다.
