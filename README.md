# fcm_test
### FCM(**Firebase Cloud Messaging**)
- Google의 Firebase 플랫폼에서 제공하는 푸시 알림 서비스
- 모바일 앱, 웹 앱, 또는 서버 간에 메시지를 전달할 수 있게 해주는 서비스
- 개발자는 특정 기기나 사용자 그룹에게 실시간으로 알림을 보낼 수 있음

---

## 기능
- 푸시 알림
    - 개발자는 모바일 또는 웹 앱 사용자에게 푸시 알림을 보낼 수 있음
    - 이 알림은 사용자가 앱을 실행하지 않고도 받을 수 있음
- 주제 기반 메시징
    - 사용자는 특정 주제를 구독하고, 개발자는  구독한 모든 사용자에게 메시지를 보낼 수 있음
- 타겟팅
    - 특정 사용자 그룹, 특정 기기,  앱 인스턴스에 대해 타겟팅된 메시지를 보낼 수 있음
    - 클라우드-클라우드 및 클라이언트-클라우드 메시징
- 서버와 클라이언트 간에 실시간 메시징을 지원
    - 서버에서 클라이언트로 메시지를 보내거나 클라이언트 간에 메시지를 주고받을 수 있음
---

## 의존성
- get: ^4.6.6 // GetX 사용
- firebase_messaging: ^15.1.0
- firebase_analytics: ^11.3.0 // 푸쉬 알림을 받을 때 필요함
- webview_flutter: ^4.9.0
- flutter_local_notifications: ^17.2.2

---

## 순서
1. FIreBase 프로젝트 만들기 : Id
2. Flutter 프로젝트에 연결하기 : token
3. 파일 구현하기 : 초기화, fcm 설정
4. 테스트하기 : Firebase 사이트에서 하기, Postman으로 하기
```
POST https://fcm.googleapis.com/v1/projects/YOUR_PROJECT_ID/messages:send
Authorization: Bearer YOUR_ACCESS_TOKEN // 위에서 구한 토큰값 복붙
Content-Type: application/json
{
  "message": {
    "token": "DEVICE_REGISTRATION_TOKEN", // Fluuter 콘솔에서 토큰 값 복붙
    "notification": {
      "body": "This is an FCM notification message!",
      "title": "FCM Message"
    }
  }
}
```
6. 백그라운드 메세지 구현 : 앱이 실행 상태이고 화면에 안보이는 경우
7. 포그라운드 메세지 구현 : 앱이 실행 상태이고 화면에 보이는 경우
