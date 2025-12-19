import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:spa_admin/firebase_options.dart';
import 'package:spa_admin/utils/tokien_utils.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  print('BG Message: ${message.messageId}');
}

class FcmServices {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> init() async {
    // Permission
    await _fcm.requestPermission(alert: true, badge: true, sound: true);

    // Token
    final token = await _fcm.getToken();
    print('FCM TOKEN: $token');

    if (token != null) {
      await TokenUtils.saveTokenFCM(token);
    }

    // 🔥 WAJIB: handle refresh token
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      await TokenUtils.saveTokenFCM(newToken);
    });
  }
}
