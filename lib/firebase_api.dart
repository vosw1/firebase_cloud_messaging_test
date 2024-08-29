import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  // 백그라운드에서 메시지 처리 함수
  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    print('mattabu: Title: ${message.notification?.title}');
    print('mattabu: Body: ${message.notification?.body}');
    print('mattabu: Payload: ${message.data}');
  }

  Future<void> initNotifications() async {
    // 사용자에게 알림 권한 요청 (배지, 알림, 소리 옵션 설정)
    await _firebaseMessaging.requestPermission(
      badge: true, // 배지 표시 허용
      alert: true, // 알림 표시 허용
      sound: true, // 알림 소리 허용
    );

    final FCMToken = await _firebaseMessaging.getToken();

    print('Token: $FCMToken');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Message received: ${message.notification?.body}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked: ${message.notification?.body}');
    });

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}