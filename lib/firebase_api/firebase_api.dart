import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:reporter/firebase_api/token_repository.dart';

class FirebaseApi{
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    TokenRepository.saveTokenToUserCollection(fcmToken!);
    FirebaseMessaging.onBackgroundMessage(handler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    });

  }
}

Future<void> handler(RemoteMessage message) async{

}