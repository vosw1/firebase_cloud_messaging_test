import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  // Firebase Messaging 인스턴스 생성
  final _firebaseMessaging = FirebaseMessaging.instance;

  // 알림 초기화 함수
  Future<void> initNotifications() async {
    // 사용자에게 알림 권한 요청 (배지, 알림, 소리 옵션 설정)
    await _firebaseMessaging.requestPermission(
      badge: true, // 배지 표시 허용
      alert: true, // 알림 표시 허용
      sound: true, // 알림 소리 허용
    );

    // 이 기기의 FCM 토큰을 가져옴
    final FCMToken = await _firebaseMessaging.getToken();

    // FCM 토큰을 출력 (보통 서버로 전송하는 경우)
    print('Token: $FCMToken');

    // 알림 핸들러 설정
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Message received: ${message.notification?.body}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked: ${message.notification?.body}');
    });
  }
}