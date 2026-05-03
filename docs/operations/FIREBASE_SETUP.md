# Firebase 설정 가이드

ZestInMe 앱에서 Firebase를 사용하기 위한 설정 가이드입니다.

## 1. Firebase 프로젝트 생성

1. [Firebase Console](https://console.firebase.google.com/)에 접속
2. "프로젝트 만들기" 클릭
3. 프로젝트 이름을 "zestinme" 또는 원하는 이름으로 설정
4. Google Analytics 사용 여부 선택 (권장: 사용)
5. 프로젝트 생성 완료

## 2. 앱 등록

### Android 앱 등록
1. Firebase 프로젝트 대시보드에서 Android 아이콘 클릭
2. Android 패키지 이름 입력: `com.example.zestinme`
3. 앱 닉네임 입력 (선택사항)
4. `google-services.json` 파일 다운로드
5. `android/app/` 폴더에 `google-services.json` 파일 복사

### iOS 앱 등록
1. Firebase 프로젝트 대시보드에서 iOS 아이콘 클릭
2. iOS 번들 ID 입력: `com.example.zestinme`
3. 앱 닉네임 입력 (선택사항)
4. `GoogleService-Info.plist` 파일 다운로드
5. `ios/Runner/` 폴더에 `GoogleService-Info.plist` 파일 복사

## 3. Firebase 서비스 활성화

### Firestore Database
1. Firebase 콘솔에서 "Firestore Database" 선택
2. "데이터베이스 만들기" 클릭
3. 보안 규칙 모드 선택: "테스트 모드에서 시작" (개발 중)
4. 데이터베이스 위치 선택 (가까운 지역 권장)

### Remote Config
1. Firebase 콘솔에서 "Remote Config" 선택
2. "시작하기" 클릭
3. 기본값 설정 (자동으로 설정됨)

## 4. 보안 규칙 설정

### Firestore 보안 규칙
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // 사용자별 데이터 접근 제어
    match /users/{userId}/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // 공개 설정 데이터 (읽기만 허용)
    match /config/{document} {
      allow read: if true;
      allow write: if false;
    }
  }
}
```

## 5. 코드 설정

### firebase_options.dart 업데이트
`lib/firebase_options.dart` 파일의 설정값을 실제 Firebase 프로젝트 값으로 교체:

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: '실제-API-키',
  appId: '실제-앱-ID',
  messagingSenderId: '실제-센더-ID',
  projectId: '실제-프로젝트-ID',
  authDomain: '실제-프로젝트-ID.firebaseapp.com',
  storageBucket: '실제-프로젝트-ID.appspot.com',
  measurementId: '실제-측정-ID',
);
```

### 사용자 인증 설정 (선택사항)
현재는 익명 사용자로 설정되어 있습니다. 실제 사용자 인증을 원한다면:

1. Firebase Auth 활성화
2. `lib/core/services/firebase_service.dart`에서 사용자 ID 설정 로직 구현
3. `lib/di/injection.dart`에서 실제 사용자 ID 사용

## 6. 테스트

### Firebase 연결 테스트
1. 앱 실행
2. `TestFirebasePage`로 이동하여 Firebase 연결 테스트
3. 각 서비스별 테스트 실행

### 예상 결과
- ✅ Firebase 연결 성공
- ✅ 질문 뱅크 로더 테스트 성공 (fallback 데이터 사용)
- ✅ 코칭 Repository 테스트 성공

## 7. 문제 해결

### 일반적인 오류

#### "Firebase is not initialized"
- `main.dart`에서 `Injection.init()` 호출 확인
- Firebase 설정 파일이 올바른 위치에 있는지 확인

#### "Permission denied"
- Firestore 보안 규칙 확인
- 사용자 인증 상태 확인

#### "Network error"
- 인터넷 연결 확인
- Firebase 프로젝트 설정 확인

### 디버깅 팁
1. Firebase 콘솔의 로그 확인
2. 앱의 콘솔 로그 확인
3. `TestFirebasePage`의 상세 로그 확인

## 8. 프로덕션 배포

### 보안 규칙 강화
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/{document=**} {
      allow read, write: if request.auth != null && 
        request.auth.uid == userId &&
        request.auth.token.email_verified == true;
    }
  }
}
```

### 에러 추적 설정
- Firebase Crashlytics 활성화
- 에러 로깅 및 모니터링 설정

## 9. 추가 리소스

- [Firebase Flutter 문서](https://firebase.flutter.dev/)
- [Firestore 보안 규칙 가이드](https://firebase.google.com/docs/firestore/security/get-started)
- [Remote Config 가이드](https://firebase.google.com/docs/remote-config)

---

**주의사항**: 실제 프로덕션 환경에서는 보안 규칙을 더 엄격하게 설정하고, 사용자 인증을 반드시 구현해야 합니다.
