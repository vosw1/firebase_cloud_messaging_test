import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'firebase_api.dart';
import 'firebase_options.dart';

final homeUrl = Uri.parse("https://www.example.com"); // 웹뷰에 로드할 URL 설정

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter의 위젯 시스템 초기화
  await Firebase.initializeApp( // Firebase 초기화 (비동기 함수)
    options: DefaultFirebaseOptions.currentPlatform, // 현재 플랫폼에 맞는 Firebase 설정 적용
  );

  // Firebase 알림 초기화 (필요한 경우)
  await FirebaseApi().initNotifications();

  runApp(const MyApp()); // MyApp 실행
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo', // 앱의 제목 설정
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), // 앱의 테마 색상 설정
        useMaterial3: true, // Material 3 사용 설정
      ),
      home: const HomePage(), // 앱의 홈 화면으로 HomePage 위젯 설정
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState(); // 상태(State) 클래스 생성
}

class _HomePageState extends State<HomePage> {
  late final WebViewController controller; // WebView 컨트롤러 선언

  @override
  void initState() {
    super.initState();
    controller = WebViewController() // WebView 컨트롤러 초기화
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // 자바스크립트 허용 모드 설정
      ..addJavaScriptChannel(
        'Toaster', // 'Toaster'라는 이름의 JavaScript 채널 추가
        onMessageReceived: (JavaScriptMessage msg) async {
          // WebView의 자바스크립트에서 보낸 메시지를 처리하는 콜백 함수
        },
      )
      ..loadRequest(homeUrl); // 설정된 URL 로드
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(controller: controller), // WebView를 표시할 위젯
    );
  }
}