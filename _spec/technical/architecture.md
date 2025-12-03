# 기술 아키텍처 명세서

## 🏗️ 전체 아키텍처 개요

### 아키텍처 패턴
**Clean Architecture + BLoC 패턴**을 기반으로 한 계층형 아키텍처

```
┌─────────────────────────────────────────┐
│               Presentation              │
│  (Pages, Widgets, BLoC/Controllers)     │
├─────────────────────────────────────────┤
│                Domain                   │
│     (Entities, UseCases, Repository     │
│           Abstract Interfaces)          │
├─────────────────────────────────────────┤
│                  Data                   │
│  (Repository Implementation, DTOs,      │
│         DataSources, Models)           │
├─────────────────────────────────────────┤
│              Infrastructure             │
│   (Firebase, Local Storage, Network)    │
└─────────────────────────────────────────┘
```

### 핵심 설계 원칙
- **관심사 분리**: 각 계층은 명확한 책임을 가짐
- **의존성 역전**: 상위 계층이 하위 계층의 인터페이스에만 의존
- **테스트 가능성**: 각 계층별 독립적인 단위 테스트 지원
- **확장성**: 새로운 기능 추가시 기존 코드 영향 최소화

## 📁 프로젝트 구조

### 디렉토리 구조
```
lib/
├── app/                        # 앱 전역 설정
│   ├── app.dart               # MaterialApp 설정
│   ├── routes/                # 라우팅 설정
│   └── theme/                 # 테마 및 스타일
├── core/                      # 공통 핵심 기능
│   ├── constants/            # 상수 정의
│   ├── errors/               # 에러 처리
│   ├── models/               # 공통 모델
│   ├── network/              # 네트워크 설정
│   ├── services/             # 핵심 서비스
│   └── utils/                # 유틸리티 함수
├── di/                        # 의존성 주입 설정
│   └── injection.dart
├── features/                  # 기능별 모듈
│   ├── happy_record/         # 행복 기록 기능
│   ├── sleep_record/         # 수면 기록 기능
│   ├── auth/                 # 인증 기능
│   └── main/                 # 메인 화면
└── shared/                   # 공유 위젯 및 서비스
    ├── widgets/              # 공통 위젯
    └── services/             # 공유 서비스
```

### 기능별 모듈 구조 (Feature 기준)
```
features/[feature_name]/
├── data/
│   ├── models/              # DTO 모델
│   │   ├── [model]_dto.dart
│   │   └── [model]_dto.g.dart  # JSON 직렬화
│   └── repositories/        # Repository 구현체
│       └── [feature]_repository_impl.dart
├── domain/
│   ├── models/              # 도메인 엔티티
│   │   └── [entity].dart
│   ├── repositories/        # Repository 인터페이스
│   │   └── [feature]_repository.dart
│   └── usecases/           # 비즈니스 로직
│       └── [action]_usecase.dart
└── presentation/
    ├── [screen_name]/       # 화면별 디렉토리
    │   ├── [screen]_page.dart
    │   ├── controller/      # BLoC/Controller
    │   ├── state/          # 상태 관리
    │   └── widgets/        # 화면별 위젯
    └── widgets/            # 기능 공통 위젯
```

## 🔧 기술 스택

### Frontend (Flutter)
- **UI 프레임워크**: Flutter 3.16+
- **상태 관리**: BLoC Pattern + Provider
- **라우팅**: GoRouter
- **의존성 주입**: GetIt + Injectable
- **JSON 직렬화**: json_annotation + build_runner

### Backend (Firebase)
- **인증**: Firebase Authentication
- **데이터베이스**: Cloud Firestore
- **클라우드 함수**: Firebase Cloud Functions
- **파일 저장**: Firebase Storage
- **푸시 알림**: Firebase Cloud Messaging
- **분석**: Firebase Analytics
- **크래시 리포팅**: Firebase Crashlytics

### 개발 도구
- **코드 생성**: build_runner, freezed
- **테스팅**: flutter_test, mockito
- **정적 분석**: flutter_lints
- **CI/CD**: GitHub Actions
- **디자인**: Figma (디자인 시스템)

## 📊 데이터 아키텍처

### 데이터 흐름
```
UI Widget → BLoC/Controller → UseCase → Repository Interface
                                            ↓
Local Cache ← Repository Implementation → Firebase/API
     ↓
SQLite/SharedPreferences
```

### 데이터 계층 설계

#### 1. Domain Layer (도메인 계층)
```dart
// 엔티티 정의
class EmotionRecord {
  final String id;
  final DateTime timestamp;
  final int emotionIntensity;
  final List<String> tags;
  // ... other fields
}

// Repository 인터페이스
abstract class RecordRepository {
  Future<List<EmotionRecord>> getRecords();
  Future<void> addRecord(EmotionRecord record);
  Future<void> deleteRecord(String id);
}

// UseCase 정의
class GetRecentRecordsUseCase {
  final RecordRepository repository;
  
  GetRecentRecordsUseCase(this.repository);
  
  Future<List<EmotionRecord>> call(int limit) {
    return repository.getRecentRecords(limit);
  }
}
```

#### 2. Data Layer (데이터 계층)
```dart
// DTO 모델
@JsonSerializable()
class RecordDto {
  final String id;
  final String timestamp;
  final int emotionIntensity;
  // ... Firebase 직렬화에 최적화된 필드
}

// Repository 구현체
class RecordRepositoryImpl implements RecordRepository {
  final FirebaseFirestore firestore;
  final LocalDatabase localDb;
  
  @override
  Future<List<EmotionRecord>> getRecords() async {
    try {
      // 1. 로컬 캐시 확인
      // 2. 캐시 만료시 Firebase에서 가져오기
      // 3. 로컬 캐시 업데이트
      // 4. 도메인 엔티티로 변환 후 반환
    } catch (e) {
      // 에러 처리 및 로깅
    }
  }
}
```

### 캐싱 전략
- **L1 Cache**: 메모리 캐시 (앱 실행 중)
- **L2 Cache**: 로컬 데이터베이스 (오프라인 지원)
- **L3 Cache**: Firebase 로컬 퍼시스턴스

## 🎨 UI 아키텍처

### 상태 관리 패턴
**BLoC Pattern**을 기본으로 하되, 단순한 상태는 **Provider** 사용

```dart
// BLoC 구조
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetRecentRecordsUseCase getRecentRecords;
  final AddRecordUseCase addRecord;
  
  HomeBloc({
    required this.getRecentRecords,
    required this.addRecord,
  }) : super(HomeInitial()) {
    on<LoadRecentRecords>(_onLoadRecentRecords);
    on<AddNewRecord>(_onAddNewRecord);
  }
}

// 상태 정의 (Freezed 사용)
@freezed
class HomeState with _$HomeState {
  const factory HomeState.initial() = HomeInitial;
  const factory HomeState.loading() = HomeLoading;
  const factory HomeState.loaded(List<EmotionRecord> records) = HomeLoaded;
  const factory HomeState.error(String message) = HomeError;
}
```

### 화면 구성 패턴
```dart
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return state.when(
            initial: () => LoadingWidget(),
            loading: () => LoadingWidget(),
            loaded: (records) => HomeContent(records: records),
            error: (message) => ErrorWidget(message: message),
          );
        },
      ),
    );
  }
}
```

## 🔐 보안 아키텍처

### 인증 및 권한 관리
```dart
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // JWT 토큰 기반 인증
  Future<User?> signInWithEmailAndPassword(String email, String password);
  
  // OAuth 로그인 (Google, Apple)
  Future<User?> signInWithGoogle();
  Future<User?> signInWithApple();
  
  // 토큰 갱신 및 만료 처리
  Future<String?> getValidToken();
}
```

### 데이터 보안
- **전송 암호화**: HTTPS/TLS 1.3
- **저장 암호화**: Firebase 기본 암호화 + 민감 데이터 추가 암호화
- **접근 제어**: Firebase Security Rules
- **개인정보 처리**: 최소 수집 원칙, 로컬 처리 우선

## 🚀 성능 최적화

### 앱 성능
- **지연 로딩**: 기능별 모듈 지연 로딩
- **이미지 최적화**: 캐싱, 압축, 지연 로딩
- **메모리 관리**: 위젯 재사용, 불필요한 리빌드 방지

### 데이터베이스 성능
```dart
// Firestore 최적화
class OptimizedQueries {
  // 인덱스 최적화된 쿼리
  Query getRecordsByDateRange(DateTime start, DateTime end) {
    return firestore
        .collection('records')
        .where('userId', isEqualTo: currentUserId)
        .where('timestamp', isGreaterThanOrEqualTo: start)
        .where('timestamp', isLessThanOrEqualTo: end)
        .orderBy('timestamp', descending: true);
  }
  
  // 페이지네이션
  Future<List<Record>> getRecordsPage(int pageSize, DocumentSnapshot? lastDoc);
}
```

### 네트워크 최적화
- **요청 배칭**: 여러 API 호출을 하나로 묶기
- **캐시 전략**: HTTP 캐시 헤더 활용
- **오프라인 지원**: 로컬 DB 우선 조회

## 📱 플랫폼별 고려사항

### iOS
- **App Store 정책**: 개인정보 라벨, 인앱구매 가이드라인
- **퍼포먼스**: 메모리 워닝 처리, 백그라운드 실행 제한
- **접근성**: VoiceOver, Dynamic Type 지원

### Android
- **재료 디자인**: Material Design 3 가이드라인 준수
- **퍼포먼스**: ANR 방지, 메모리 릭 방지
- **권한 관리**: 런타임 권한 요청 처리

## 🔄 업데이트 및 배포

### CI/CD 파이프라인
```yaml
# GitHub Actions workflow 예시
name: Build and Deploy
on:
  push:
    branches: [main, develop]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - name: Run Tests
        run: flutter test
      
  build:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - name: Build APK
        run: flutter build apk --release
      
  deploy:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to Firebase App Distribution
        run: firebase appdistribution:distribute
```

### 코드 품질 관리
- **정적 분석**: flutter analyze, custom lint rules
- **코드 리뷰**: PR 기반 리뷰 프로세스
- **테스트 커버리지**: 80% 이상 유지 목표

## 🔧 개발 환경 설정

### 필수 도구
- Flutter SDK 3.16+
- Dart SDK 3.2+
- Android Studio / VS Code
- Firebase CLI
- Git

### 환경별 설정
```dart
// 환경별 설정 관리
abstract class Environment {
  static const String dev = 'development';
  static const String staging = 'staging';
  static const String prod = 'production';
  
  static String get current => 
      const String.fromEnvironment('ENVIRONMENT', defaultValue: dev);
  
  static FirebaseOptions get firebaseConfig {
    switch (current) {
      case dev:
        return DefaultFirebaseOptions.dev;
      case staging:
        return DefaultFirebaseOptions.staging;
      case prod:
        return DefaultFirebaseOptions.currentPlatform;
      default:
        return DefaultFirebaseOptions.dev;
    }
  }
}
```