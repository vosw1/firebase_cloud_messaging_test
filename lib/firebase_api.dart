import 'dart:convert'; // jsonEncode를 사용하기 위한 import
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// 백그라운드에서 메시지를 처리할 함수
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('백그라운드 메시지 제목: ${message.notification?.title}');
  print('백그라운드 메시지 본문: ${message.notification?.body}');
  print('백그라운드 메시지 데이터: ${message.data}');
}

class FirebaseApi {
  // Firebase Messaging 인스턴스 생성
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // FlutterLocalNotificationsPlugin 인스턴스 생성
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  // Android 알림 채널 설정
  final AndroidNotificationChannel _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: '이 채널은 알림을 표시하는 데 사용됩니다.',
    importance: Importance.defaultImportance,
  );

  // 알림 초기화 함수
  Future<void> initNotifications() async {
    // 사용자에게 알림 권한 요청 (배지, 알림, 소리 옵션 설정)
    await _firebaseMessaging.requestPermission(
      badge: true, // 배지 표시 허용
      alert: true, // 알림 표시 허용
      sound: true, // 알림 소리 허용
    );

    // 이 기기의 FCM 토큰을 가져옴
    final String? FCMToken = await _firebaseMessaging.getToken();
    // FCM 토큰을 출력 (서버로 전송하거나 디버깅에 사용)
    print('FCM 토큰: $FCMToken');

    // 앱이 백그라운드에 있을 때 메시지를 처리할 함수 등록
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    // 알림 초기화 및 설정 추가
    await initPushNotifications();
    await initLocalNotification();
  }

  // 로컬 알림 초기화 함수
  Future<void> initLocalNotification() async {
    // Android 초기화 설정
    const AndroidInitializationSettings android = AndroidInitializationSettings('ic_launcher');
    const InitializationSettings settings = InitializationSettings(android: android);
    // 로컬 알림 초기화
    await _localNotifications.initialize(settings);

    // Android 플랫폼에 맞게 알림 채널 생성
    final AndroidFlutterLocalNotificationsPlugin? platform = _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  // 메시지 처리 함수 추가 (앱이 열려있을 때)
  void handleMessage(RemoteMessage? message) {
    // 메시지가 null인 경우 아무 작업도 하지 않음
    if (message == null) return;
    print('포그라운드 메시지: $message');
  }

  // 푸시 알림 설정 함수 추가
  Future<void> initPushNotifications() async {
    // 포그라운드 알림 설정 (알림, 배지, 소리 허용)
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    // 앱이 처음 시작될 때 메시지 처리
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    // 알림 클릭 시 메시지 처리
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

    // 포그라운드에서 메시지 수신 시 알림 표시
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('포그라운드 메시지 수신: ${message.messageId}');

      final RemoteNotification? notification = message.notification;
      if (notification != null) {
        print('알림 제목: ${notification.title}');
        print('알림 본문: ${notification.body}');

        // 로컬 알림을 사용하여 메시지 표시
        _localNotifications.show(
          notification.hashCode, // 알림 ID
          notification.title ?? '제목 없음', // 제목
          notification.body ?? '본문 없음',   // 본문
          NotificationDetails(
            android: AndroidNotificationDetails(
              _androidChannel.id,      // 채널 ID
              _androidChannel.name,    // 채널 이름
              channelDescription: _androidChannel.description, // 채널 설명
              icon: 'ic_launcher', // 알림 아이콘(확장자 제외)
            ),
          ),
          payload: jsonEncode(message.toMap()), // 메시지 데이터
        );
      }
    });
  }
}